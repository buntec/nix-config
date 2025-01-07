{ pkgs, lib, ... }:
{

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
