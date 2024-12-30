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

  dconf.settings = {
    # Inside the VM we never want to lock the screen etc.
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0; # never
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
  };

}
