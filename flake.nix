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
  };

  outputs = inputs@{ darwin, nixpkgs, home-manager, flake-utils, my-pkgs
    , git-summary, nil, ... }:
    let
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
      darwinMachines = builtins.filter (machine: isDarwin machine) machines;
      nixosMachines = builtins.filter (machine: !isDarwin machine) machines;
      machinesBySystem = builtins.groupBy (machine: machine.system) machines;
      overlays = [
        my-pkgs.overlays.default
        git-summary.overlays.default
        nil.overlays.default
      ];
    in rec {
      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine.name;
        value = nixpkgs.lib.nixosSystem {
          system = machine.system;
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
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${machine.user} = {
                imports = [
                  ./home/home.nix
                  ./home/home-nixos.nix
                  ./home/home-${machine.name}.nix
                ];
              };
            }
          ];
        };
      }) nixosMachines);

      darwinConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine.name;
        value = darwin.lib.darwinSystem {
          system = machine.system;
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
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${machine.user} = {
                imports = [
                  ./home/home.nix
                  ./home/home-darwin.nix
                  ./home/home-${machine.name}.nix
                ];
              };
            }
          ];
        };
      }) darwinMachines);

      apps = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (builtins.map (machine:
          let
            pkgs = import nixpkgs { inherit system; };
            script = (pkgs.writeShellScript "rebuild-${machine.name}"
              (if (isDarwin machine) then
                "${
                  darwinConfigurations.${machine.name}.system
                }/sw/bin/darwin-rebuild switch --flake .#${machine.name}"
              else
                "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .#${machine.name}"));
          in {
            name = "rebuild-${machine.name}";
            value = {
              type = "app";
              program = "${script}";
            };
          }) machines)) machinesBySystem;
    };
}
