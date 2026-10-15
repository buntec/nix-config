{
  description = "NixOS/nix-darwin and HM configurations for my personal machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

    btmux = {
      url = "github:buntec/btmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      darwin,
      disko,
      nixpkgs,
      nixpkgs-nixos-unstable,
      nixos-hardware,
      home-manager,
      treefmt-nix,
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
          kind = "nixos";
          checkSystem = false;
        }
        {
          # nix-darwin w/ HM running on MacBook Pro
          name = "macbook-pro";
          user = "christoph";
          system = "aarch64-darwin";
          kind = "darwin";
        }
        {
          # nix-darwin w/ HM running on MacBook Neo (2026)
          name = "macbook-neo";
          user = "christoph";
          system = "aarch64-darwin";
          kind = "darwin";
        }
        {
          # NixOS w/ HM running inside VMWare Fusion guest on MacBook Pro
          name = "macbook-pro-vmw";
          user = "buntec";
          system = "aarch64-linux";
          kind = "nixos";
        }
        {
          # NixOS w/ HM running inside UTM guest on MacBook Pro
          name = "macbook-pro-utm";
          user = "buntec";
          system = "aarch64-linux";
          kind = "nixos";
        }
        {
          # NixOS w/ HM running inside VirtualBox guest on Windows 11 desktop
          name = "win11-vb";
          user = "buntec";
          system = "x86_64-linux";
          kind = "nixos";
        }
        {
          # NixOS w/ HM inside WSL running on Windows 11 desktop
          name = "wsl";
          user = "buntec";
          system = "x86_64-linux";
          kind = "nixos";
        }
        {
          # HM inside multipass guest (Ubuntu) on Apple Silicon
          name = "multipass-guest";
          user = "christoph";
          system = "aarch64-linux";
          kind = "home";
        }
      ];

      isDarwinSystem = system: (builtins.match ".*darwin" system) != null;

      isAppleSilicon = system: system == "aarch64-darwin";

      darwinMachines = builtins.filter (machine: machine.kind == "darwin") machines;

      nixosMachines = builtins.filter (machine: machine.kind == "nixos") machines;

      machinesBySystem = builtins.groupBy (machine: machine.system) machines;

      forEachMachine =
        machines: f:
        builtins.listToAttrs (
          builtins.map (machine: {
            inherit (machine) name;
            value = f machine;
          }) machines
        );

      systems = builtins.attrNames machinesBySystem;

      eachSystem = genAttrs systems;

      overlays = [ ];

      # we select the branch according to recommendation in https://nix.dev/concepts/faq.html#rolling
      pkgsBySystem = builtins.listToAttrs (
        builtins.map (system: {
          name = system;
          value = import (if (isDarwinSystem system) then nixpkgs else nixpkgs-nixos-unstable) {
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

      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

      nixosConfigurations = forEachMachine nixosMachines (
        machine:
        nixpkgs-nixos-unstable.lib.nixosSystem {
          inherit (machine) system;
          specialArgs = {
            inherit inputs machine;
          };
          modules = [
            (_: {
              nixpkgs = {
                pkgs = pkgsBySystem.${machine.system};
              };
            })
            disko.nixosModules.disko
            ./system/configuration-nixos.nix
            ./system/configuration-${machine.name}.nix
          ];
        }
      );

      darwinConfigurations = forEachMachine darwinMachines (
        machine:
        darwin.lib.darwinSystem {
          inherit (machine) system;
          specialArgs = {
            inherit inputs machine;
          };
          modules = [
            (_: {
              nixpkgs = {
                pkgs = pkgsBySystem.${machine.system};
              };
              system.primaryUser = machine.user;
            })
            ./system/configuration-darwin.nix
            ./system/configuration-${machine.name}.nix
          ];
        }
      );

      homeConfigurations = forEachMachine machines (
        machine:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsBySystem.${machine.system};
          extraSpecialArgs = {
            inherit inputs machine;
          };
          modules = [
            (_: {
              home.username = machine.user;
              home.homeDirectory =
                if (isDarwinSystem machine.system) then "/Users/${machine.user}" else "/home/${machine.user}";
            })
            ./home/home.nix
            ./home/home-${if (isDarwinSystem machine.system) then "darwin" else "nixos"}.nix
            ./home/home-${machine.name}.nix
          ];
        }
      );

      apps = builtins.mapAttrs (
        system: machines:
        builtins.listToAttrs (
          lib.flatten (
            builtins.map (
              machine:
              let
                pkgs = pkgsBySystem.${system};
              in
              (lib.optional (machine.kind != "home") {
                name = "rebuild-${machine.name}";
                value = {
                  type = "app";
                  meta.description = "Activate ${machine.name}";
                  program = "${pkgs.writeShellScript "rebuild-${machine.name}" (
                    if (machine.kind == "darwin") then
                      "${
                        self.darwinConfigurations.${machine.name}.system
                      }/sw/bin/darwin-rebuild switch --flake ${self}#${machine.name}"
                    else
                      "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${self}#${machine.name}"
                  )}";
                };
              })
              ++ [
                {
                  name = "hm-switch-${machine.name}";
                  value = {
                    type = "app";
                    meta.description = "Activate Home Manager for ${machine.name}";
                    program = "${pkgs.writeShellScript "hm-switch-${machine.name}" "${
                      inputs.home-manager.packages.${system}.home-manager
                    }/bin/home-manager switch -b backup --flake ${self}#${machine.name}"}";
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
          builtins.concatMap (
            machine:
            (lib.optional (machine.kind != "home" && machine.checkSystem or true) {
              name = "toplevel-${machine.name}";
              value =
                if (machine.kind == "darwin") then
                  self.darwinConfigurations.${machine.name}.config.system.build.toplevel
                else
                  self.nixosConfigurations.${machine.name}.config.system.build.toplevel;
            })
            ++ [
              {
                name = "hm-${machine.name}";
                value = self.homeConfigurations.${machine.name}.activationPackage;
              }
            ]
          ) machines
        )
        // {
          formatting = treefmtEval.${system}.config.build.check self;
        }
      ) machinesBySystem;

    };

}
