{ pkgs, lib, ... }:
{

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
