{
  description = "My Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    my-pkgs.url = "github:buntec/pkgs";
    my-pkgs.inputs.nixpkgs.follows = "nixpkgs";
    git-summary.url = "github:buntec/git-summary-scala";
    git-summary.inputs.nixpkgs.follows = "nixpkgs";
    nil.url = "github:oxalica/nil";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ self, darwin, nixpkgs, home-manager, flake-utils, my-pkgs
    , git-summary, nil, treefmt-nix, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) genAttrs;

      machines = [
        {
          name = "thinkpad-x1";
          user = "buntec";
          system = flake-utils.lib.system.x86_64-linux;
        }
        {
          name = "macbook-pro-m1";
          user = "christophbunte";
          system = flake-utils.lib.system.aarch64-darwin;
        }
        {
          name = "imac-intel";
          user = "christophbunte";
          system = flake-utils.lib.system.x86_64-darwin;
        }
        {
          name = "macbook-pro-intel";
          user = "christophbunte";
          system = flake-utils.lib.system.x86_64-darwin;
        }
      ];

      isDarwin = machine: (builtins.match ".*darwin" machine.system) != null;
      darwinMachines = builtins.filter isDarwin machines;
      nixosMachines = builtins.filter (machine: !isDarwin machine) machines;
      machinesBySystem = builtins.groupBy (machine: machine.system) machines;
      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = [
        my-pkgs.overlays.default
        git-summary.overlays.default
        nil.overlays.default
      ];

      treefmtEval = eachSystem (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

    in rec {

      formatter = eachSystem (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in treefmtEval.${pkgs.system}.config.build.wrapper);

      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = nixpkgs.lib.nixosSystem {
          inherit (machine) system;
          specialArgs = {
            inherit inputs;
          }; # attributes in this set will be passed to modules as args
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config = { allowUnfree = true; };
            }
            ./system/configuration-nixos.nix
            ./system/configuration-${machine.name}.nix
          ];
        };
      }) nixosMachines);

      darwinConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = darwin.lib.darwinSystem {
          inherit (machine) system;
          specialArgs = {
            inherit inputs;
          }; # attributes in this set will be passed to modules as args
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config = { allowUnfree = true; };
            }
            ./system/configuration-darwin.nix
            ./system/configuration-${machine.name}.nix
          ];
        };
      }) darwinMachines);

      homeConfigurations = builtins.listToAttrs (builtins.map (machine:
        let
          pkgs = import nixpkgs {
            inherit (machine) system;
            inherit overlays;
            config = { allowUnfree = true; };
          };
        in {
          inherit (machine) name;
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              {
                home.username = machine.user;
                home.homeDirectory = if (isDarwin machine) then
                  "/Users/${machine.user}"
                else
                  "/home/${machine.user}";
              }
              ./home/home.nix
              ./home/home-${
                if (isDarwin machine) then "darwin" else "nixos"
              }.nix
              ./home/home-${machine.name}.nix
            ];
          };
        }) machines);

      apps = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (lib.flatten (builtins.map (machine:
          let
            pkgs = import nixpkgs { inherit system; };
            rebuildScript = pkgs.writeShellScript "rebuild-${machine.name}"
              (if (isDarwin machine) then
                "${
                  darwinConfigurations.${machine.name}.system
                }/sw/bin/darwin-rebuild switch --flake .#${machine.name}"
              else
                "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .#${machine.name}");
            hmScript = pkgs.writeShellScript "hm-switch-${machine.name}" "${
                inputs.home-manager.packages.${system}.home-manager
              }/bin/home-manager switch --flake ${self}#${machine.name}";
          in [
            {
              name = "rebuild-${machine.name}";
              value = {
                type = "app";
                program = "${rebuildScript}";
              };
            }
            {
              name = "hm-switch-${machine.name}";
              value = {
                type = "app";
                program = "${hmScript}";
              };
            }
          ]) machines))) machinesBySystem;

      # add all nixos, darwin and hm configs to checks
      checks = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (lib.flatten (builtins.map (machine:
          let
            toplevel = if (isDarwin machine) then
              darwinConfigurations.${machine.name}.config.system.build.toplevel
            else
              nixosConfigurations.${machine.name}.config.system.build.toplevel;
          in [
            {
              name = "toplevel-${machine.name}";
              value = toplevel;
            }
            {
              name = "hm-${machine.name}";
              value = self.homeConfigurations.${machine.name}.activation-script;
            }
          ]) machines)) // {
            formatting = treefmtEval.${system}.config.build.check self;
          }) machinesBySystem;

    };

}
