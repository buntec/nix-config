# HM config common to all VMWare Fusion guests
{ pkgs, lib, ... }:
{

  imports = [
    ./home-vm-guest.nix
  ];

  programs.fish = {
    functions = {
      # HACK: call this when copy-paste from guest to host dies
      restart-vmtoolsd = ''
        pkill -f 'vmtoolsd -n vmusr'
        nohup vmtoolsd -n vmusr > /dev/null 2>&1 &
      '';
    };
  };

}
