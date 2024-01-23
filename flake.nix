{
  description = "My Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    my-pkgs.url = "github:buntec/pkgs";
    my-pkgs.inputs.nixpkgs.follows = "nixpkgs";

    git-summary.url = "github:buntec/git-summary-scala";
    git-summary.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    kauz.url = "github:buntec/kauz";
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ self, darwin, nixpkgs, nixpkgs-darwin, nixpkgs-unstable
    , nixpkgs-nixos-unstable, home-manager, devenv, flake-utils, my-pkgs
    , git-summary, treefmt-nix, kauz, ... }:
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
          name = "macbook-pro-intel";
          user = "christophbunte";
          system = flake-utils.lib.system.x86_64-darwin;
        }
      ];

      isDarwin = system: (builtins.match ".*darwin" system) != null;
      darwinMachines =
        builtins.filter (machine: (isDarwin machine.system)) machines;
      nixosMachines =
        builtins.filter (machine: !(isDarwin machine.system)) machines;
      machinesBySystem = builtins.groupBy (machine: machine.system) machines;
      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = [
        # my-pkgs.overlays.default
        git-summary.overlays.default
        kauz.overlays.default
        # unstable overlay idea taken from https://github.com/Misterio77/nix-starter-configs/blob/main/standard/overlays/default.nix
        # we select the unstable branch according to advise in https://nix.dev/concepts/faq.html#rolling
        (final: prev: {
          unstable = import (if (isDarwin final.system) then
            nixpkgs-unstable
          else
            nixpkgs-nixos-unstable) {
              inherit (final) system;
              config.allowUnfree = true;
            };
        })
      ];

      pkgsBySystem = builtins.listToAttrs (builtins.map (system: {
        name = system;
        value = import (if (isDarwin system) then nixpkgs-darwin else nixpkgs) {
          inherit system;
          inherit overlays;
          config = { allowUnfree = true; };
        };
      }) systems);

      treefmtEval = eachSystem (system:
        let pkgs = pkgsBySystem.${system};
        in treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

    in {

      devShells = eachSystem (system:
        let pkgs = pkgsBySystem.${system};
        in {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              ({ pkgs, config, ... }: {
                languages.lua.enable = true;
                # languages.nix.enable = true; # TODO: uncomment when fixed
              })
            ];
          };
        });

      formatter = eachSystem (system:
        let pkgs = pkgsBySystem.${system};
        in treefmtEval.${pkgs.system}.config.build.wrapper);

      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = lib.nixosSystem {
          inherit (machine) system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.pkgs = pkgsBySystem.${machine.system}; }
            ./system/configuration-nixos.nix
            ./system/configuration-${machine.name}.nix
          ];
        };
      }) nixosMachines);

      darwinConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = darwin.lib.darwinSystem {
          inherit (machine) system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.pkgs = pkgsBySystem.${machine.system}; }
            ./system/configuration-darwin.nix
            ./system/configuration-${machine.name}.nix
          ];
        };
      }) darwinMachines);

      homeConfigurations = builtins.listToAttrs (builtins.map (machine: {
        inherit (machine) name;
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsBySystem.${machine.system};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            {
              imports = [ kauz.homeModules.default ];
              home.username = machine.user;
              home.homeDirectory = if (isDarwin machine.system) then
                "/Users/${machine.user}"
              else
                "/home/${machine.user}";
            }
            ./home/home.nix
            ./home/home-${
              if (isDarwin machine.system) then "darwin" else "nixos"
            }.nix
            ./home/home-${machine.name}.nix
          ];
        };
      }) machines);

      apps = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (lib.flatten (builtins.map (machine:
          let
            pkgs = pkgsBySystem.${system};
            rebuildScript = pkgs.writeShellScript "rebuild-${machine.name}"
              (if (isDarwin machine.system) then
                "${
                  self.darwinConfigurations.${machine.name}.system
                }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}"
              else
                "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}");
            hmSwitchScript = pkgs.writeShellScript "hm-switch-${machine.name}"
              "${
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
                program = "${hmSwitchScript}";
              };
            }
          ]) machines))) machinesBySystem;

      # add all nixos, darwin and hm configs to checks
      checks = builtins.mapAttrs (system: machines:
        builtins.listToAttrs (lib.flatten (builtins.map (machine: [
          {
            name = "toplevel-${machine.name}";
            value = if (isDarwin machine.system) then
              self.darwinConfigurations.${machine.name}.config.system.build.toplevel
            else
              self.nixosConfigurations.${machine.name}.config.system.build.toplevel;
          }
          {
            name = "hm-${machine.name}";
            value =
              builtins.trace "system: ${machine.system}, name: ${machine.name}"
              self.homeConfigurations.${machine.name}.activationPackage;
          }
        ]) machines)) // {
          formatting = treefmtEval.${system}.config.build.check self;
        }) machinesBySystem;

    };

}
