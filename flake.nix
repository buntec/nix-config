{
  description = "NixOS/nix-darwin and HM configurations for my personal machines";

  inputs = {
    # default branch
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # stable branches
    nixpkgs-nixos.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";

    # unstable branches
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11"; # for nixpkgs-23.11
      url = "github:nix-community/home-manager"; # for nixpkgs-unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    kauz.url = "github:buntec/kauz";
    kauz.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

  };

  outputs =
    inputs@{
      self,
      darwin,
      disko,
      nixpkgs,
      nixpkgs-nixos,
      nixpkgs-darwin,
      nixpkgs-unstable,
      nixpkgs-nixos-unstable,
      home-manager,
      devenv,
      flake-utils,
      treefmt-nix,
      kauz,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) genAttrs;

      machines = [
        {
          # NixOS w/ HM running on ThinkPad X1 Carbon 7th
          name = "thinkpad-x1";
          user = "buntec";
          system = flake-utils.lib.system.x86_64-linux;
        }
        {
          # nix-darwin w/ HM running on MacBook Pro M1 (2021)
          name = "macbook-pro-m1";
          user = "christophbunte";
          system = flake-utils.lib.system.aarch64-darwin;
        }
        {
          # NixOS w/ HM running inside VMWare Fusion guest on MacBook Pro M1
          name = "macbook-pro-m1-vmw";
          user = "buntec";
          system = flake-utils.lib.system.aarch64-linux;
        }
        {
          # NixOS w/ HM running inside UTM guest on MacBook Pro M1
          name = "macbook-pro-m1-utm";
          user = "buntec";
          system = flake-utils.lib.system.aarch64-linux;
        }
        {
          # nix-darwin w/ HM running on MacBook Pro (Intel, Late 2013)
          name = "macbook-pro-intel";
          user = "christophbunte";
          system = flake-utils.lib.system.x86_64-darwin;
        }
      ];

      isDarwin = system: (builtins.match ".*darwin" system) != null;

      isAppleSilicon = system: system == flake-utils.lib.system.aarch64-darwin;

      darwinMachines = builtins.filter (machine: (isDarwin machine.system)) machines;

      nixosMachines = builtins.filter (machine: !(isDarwin machine.system)) machines;

      machinesBySystem = builtins.groupBy (machine: machine.system) machines;

      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = [
        # overlay idea taken from https://github.com/Misterio77/nix-starter-configs/blob/main/standard/overlays/default.nix
        (final: prev: {
          nixpkgs-stable = import (if (isDarwin final.system) then nixpkgs-darwin else nixpkgs-nixos) {
            inherit (final) system;
            config.allowUnfree = true;
          };
        })

        # pick some packages from stable
        # (final: prev: {
        # inherit (final.nixpkgs-stable)
        # ncdu
        # })

        kauz.overlays.default
      ];

      # we select the branch according to recommendation in https://nix.dev/concepts/faq.html#rolling
      pkgsBySystem = builtins.listToAttrs (
        builtins.map (system: {
          name = system;
          value = import (if (isDarwin system) then nixpkgs-unstable else nixpkgs-nixos-unstable) {
            inherit system;
            inherit overlays;
            config = {
              allowUnfree = true;
            };
          };
        }) systems
      );

      treefmtEval = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        treefmt-nix.lib.evalModule pkgs ./treefmt.nix
      );

    in
    {

      devShells = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              (
                { pkgs, config, ... }:
                {
                  languages.lua.enable = true;
                  languages.nix.enable = true;
                }
              )
            ];
          };
        }
      );

      formatter = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        treefmtEval.${pkgs.system}.config.build.wrapper
      );

      nixosConfigurations = builtins.listToAttrs (
        builtins.map (machine: {
          inherit (machine) name;
          value = lib.nixosSystem {
            inherit (machine) system;
            specialArgs = {
              inherit inputs machine;
            };
            modules = [
              {
                nixpkgs = {
                  inherit overlays;
                  config = {
                    allowUnfree = true;
                  };
                };
              }
              disko.nixosModules.disko
              ./system/configuration-nixos.nix
              ./system/configuration-${machine.name}.nix
            ];
          };
        }) nixosMachines
      );

      darwinConfigurations = builtins.listToAttrs (
        builtins.map (machine: {
          inherit (machine) name;
          value = darwin.lib.darwinSystem {
            inherit (machine) system;
            specialArgs = {
              inherit inputs machine;
            };
            modules = [
              {
                nixpkgs = {
                  inherit overlays;
                  config = {
                    allowUnfree = true;
                  };
                };
              }
              ./system/configuration-darwin.nix
              ./system/configuration-${machine.name}.nix
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  inherit (machine) user;
                  enable = true;
                  enableRosetta = isAppleSilicon machine.system;
                  taps = {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                  };
                  autoMigrate = true; # Automatically migrate existing Homebrew installations
                };
              }
            ];
          };
        }) darwinMachines
      );

      homeConfigurations = builtins.listToAttrs (
        builtins.concatMap
          (
            mode:
            builtins.map (machine: {
              name = "${machine.name}-${mode}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = pkgsBySystem.${machine.system};
                extraSpecialArgs = {
                  inherit inputs machine mode;
                };
                modules = [
                  {
                    imports = [ kauz.homeModules.default ];
                    kauz."light" = mode == "light";
                    home.username = machine.user;
                    home.homeDirectory =
                      if (isDarwin machine.system) then "/Users/${machine.user}" else "/home/${machine.user}";
                  }
                  ./home/home.nix
                  ./home/home-${if (isDarwin machine.system) then "darwin" else "nixos"}.nix
                  ./home/home-${machine.name}.nix
                ];
              };
            }) machines
          )
          [
            "light"
            "dark"
          ]
      );

      apps = builtins.mapAttrs (
        system: machines:
        builtins.listToAttrs (
          lib.flatten (
            builtins.map (
              machine:
              let
                pkgs = pkgsBySystem.${system};
                rebuildScript = pkgs.writeShellScript "rebuild-${machine.name}" (
                  if (isDarwin machine.system) then
                    "${
                      self.darwinConfigurations.${machine.name}.system
                    }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}"
                  else
                    "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}"
                );
                hmSwitchScriptLight = pkgs.writeShellScript "hm-switch-${machine.name}-light" "${
                  inputs.home-manager.packages.${system}.home-manager
                }/bin/home-manager switch --flake ${self}#${machine.name}-light";
                hmSwitchScriptDark = pkgs.writeShellScript "hm-switch-${machine.name}-dark" "${
                  inputs.home-manager.packages.${system}.home-manager
                }/bin/home-manager switch --flake ${self}#${machine.name}-dark";
              in
              [
                {
                  name = "rebuild-${machine.name}";
                  value = {
                    type = "app";
                    program = "${rebuildScript}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}-dark";
                  value = {
                    type = "app";
                    program = "${hmSwitchScriptDark}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}-light";
                  value = {
                    type = "app";
                    program = "${hmSwitchScriptLight}";
                  };
                }
              ]
            ) machines
          )
        )
      ) machinesBySystem;

      # add all nixos, darwin and hm configs to checks
      checks = builtins.mapAttrs (
        system: machines:
        builtins.listToAttrs (
          lib.flatten (
            builtins.map (machine: [
              {
                name = "toplevel-${machine.name}";
                value =
                  if (isDarwin machine.system) then
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
            ]) machines
          )
        )
        // {
          formatting = treefmtEval.${system}.config.build.check self;
        }
      ) machinesBySystem;

    };

}
