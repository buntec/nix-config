{
  description = "NixOS/nix-darwin and HM configurations for my personal machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    nixpkgs-nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager"; # for nixpkgs-unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    kauz = {
      url = "github:buntec/kauz";
      flake = false;
    };

  };

  outputs =
    inputs@{
      self,
      darwin,
      disko,
      nixpkgs,
      nixpkgs-master,
      nixpkgs-nixos-unstable,
      nixos-wsl,
      nixos-hardware,
      home-manager,
      stylix,
      treefmt-nix,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      kauz,
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
          system = "x86_64-linux";
        }
        {
          # nix-darwin w/ HM running on MacBook Pro M1 (2021)
          name = "macbook-pro-m1";
          user = "christoph";
          system = "aarch64-darwin";
        }
        {
          # nix-darwin w/ HM running on MacBook Neo (2026)
          name = "macbook-neo";
          user = "christoph";
          system = "aarch64-darwin";
        }
        {
          # NixOS w/ HM running inside VMWare Fusion guest on MacBook Pro M1
          name = "macbook-pro-m1-vmw";
          user = "buntec";
          system = "aarch64-linux";
        }
        {
          # NixOS w/ HM running inside UTM guest on MacBook Pro M1
          name = "macbook-pro-m1-utm";
          user = "buntec";
          system = "aarch64-linux";
        }
        {
          # nix-darwin w/ HM running on MacBook Pro (Intel, Late 2013)
          name = "macbook-pro-intel";
          user = "christophbunte";
          system = "x86_64-darwin";
        }
        {
          # NixOS w/ HM running inside VirtualBox guest on Windows 11 desktop
          name = "win11-vb";
          user = "buntec";
          system = "x86_64-linux";
        }
        {
          # NixOS w/ HM inside WSL running on Windows 11 desktop
          name = "wsl";
          user = "buntec";
          system = "x86_64-linux";
        }
        {
          # HM inside multipass guest (Ubuntu) on Apple Silicon
          name = "multipass-guest";
          user = "christoph";
          system = "aarch64-linux";
        }
      ];

      isDarwin = system: (builtins.match ".*darwin" system) != null;

      isAppleSilicon = system: system == "aarch64-darwin";

      darwinMachines = builtins.filter (machine: (isDarwin machine.system)) machines;

      nixosMachines = builtins.filter (machine: !(isDarwin machine.system)) machines;

      machinesBySystem = builtins.groupBy (machine: machine.system) machines;

      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = [
        (final: prev: {
          # direnv for Darwin is currently broken in nixpkgs-unstable
          inherit (nixpkgs-master.legacyPackages.${prev.stdenv.hostPlatform.system}) direnv;
        })
      ];

      # we select the branch according to recommendation in https://nix.dev/concepts/faq.html#rolling
      pkgsBySystem = builtins.listToAttrs (
        builtins.map (system: {
          name = system;
          value = import (if (isDarwin system) then nixpkgs else nixpkgs-nixos-unstable) {
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

      stylixConfig =
        mode:
        { pkgs, ... }:
        let
          schemes = {
            light = "${kauz}/base24/kauz-light.yml";
            dark = "${kauz}/base24/kauz-dark.yml";
          };
        in
        {
          stylix = {
            enable = true;
            enableReleaseChecks = false;
            base16Scheme = schemes.${mode};
            polarity = mode;

            opacity = {
              applications = 0.95;
              desktop = 0.95;
              popups = 0.95;
              terminal = 0.95;
            };

            image = ./wallpapers/lex-sirikiat-hmcyWDzjWHo-unsplash.jpg;

            fonts = {
              serif = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Serif";
              };

              sansSerif = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Sans";
              };

              # monospace = {
              #   package = pkgs.dejavu_fonts;
              #   name = "DejaVu Sans Mono";
              # };

              # monospace = {
              #   package = pkgs.nerd-fonts.iosevka;
              #   name = "Iosevka Nerd Font";
              # };

              monospace = {
                package = pkgs.nerd-fonts.jetbrains-mono;
                name = "JetBrains Mono Nerd Font";
              };

              emoji = {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
              };

              sizes = {
                applications = 8;
                desktop = 8;
                terminal = 10;
                popups = 10;
              };
            };
          };
        };

    in
    {

      formatter = eachSystem (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        treefmtEval.${pkgs.system}.config.build.wrapper
      );

      nixosConfigurations = builtins.listToAttrs (
        builtins.concatMap
          (
            mode:
            builtins.map (machine: {
              name = "${machine.name}-${mode}";
              value = nixpkgs-nixos-unstable.lib.nixosSystem {
                inherit (machine) system;
                specialArgs = {
                  inherit inputs machine;
                };
                modules = [
                  (pkgs: {
                    nixpkgs = {
                      inherit overlays;
                      config = {
                        allowUnfree = true;
                      };
                    };
                  })
                  disko.nixosModules.disko
                  nixos-wsl.nixosModules.default
                  stylix.nixosModules.stylix
                  (stylixConfig mode)
                  ./system/configuration-nixos.nix
                  ./system/configuration-${machine.name}.nix
                ];
              };
            }) nixosMachines
          )
          [
            "light"
            "dark"
          ]
      );

      darwinConfigurations = builtins.listToAttrs (
        builtins.concatMap
          (
            mode:
            builtins.map (machine: {
              name = "${machine.name}-${mode}";
              value = darwin.lib.darwinSystem {
                inherit (machine) system;
                specialArgs = {
                  inherit inputs machine;
                };
                modules = [
                  (pkgs: {
                    nixpkgs = {
                      inherit overlays;
                      config = {
                        allowUnfree = true;
                      };
                    };
                    system.primaryUser = machine.user;
                  })
                  stylix.darwinModules.stylix
                  (stylixConfig mode)
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
          )
          [
            "light"
            "dark"
          ]
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
                  (pkgs: {
                    home.username = machine.user;
                    home.homeDirectory =
                      if (isDarwin machine.system) then "/Users/${machine.user}" else "/home/${machine.user}";

                  })
                  stylix.homeModules.stylix
                  (stylixConfig mode)
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

                osRebuildScript =
                  mode:
                  pkgs.writeShellScript "rebuild-${machine.name}" (
                    if (isDarwin machine.system) then
                      "${
                        self.darwinConfigurations.${"${machine.name}-${mode}"}.system
                      }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}-${mode}"
                    else
                      "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}-${mode}"
                  );

                hmSwitchScript =
                  mode:
                  pkgs.writeShellScript "hm-switch-${machine.name}-${mode}" "${
                    inputs.home-manager.packages.${system}.home-manager
                  }/bin/home-manager switch -b backup --flake ${self}#${machine.name}-${mode}";

              in
              [
                {
                  name = "rebuild-${machine.name}-dark";
                  value = {
                    type = "app";
                    program = "${osRebuildScript "dark"}";
                  };
                }
                {
                  name = "rebuild-${machine.name}-light";
                  value = {
                    type = "app";
                    program = "${osRebuildScript "light"}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}-dark";
                  value = {
                    type = "app";
                    program = "${hmSwitchScript "dark"}";
                  };
                }
                {
                  name = "hm-switch-${machine.name}-light";
                  value = {
                    type = "app";
                    program = "${hmSwitchScript "light"}";
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
                    self.darwinConfigurations.${"${machine.name}-light"}.config.system.build.toplevel
                  else
                    self.nixosConfigurations.${"${machine.name}-light"}.config.system.build.toplevel;
              }
              {
                name = "hm-${machine.name}";
                value =
                  builtins.trace "system: ${machine.system}, name: ${machine.name}"
                    self.homeConfigurations.${"${machine.name}-light"}.activationPackage;
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
