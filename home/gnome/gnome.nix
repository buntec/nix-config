{
  pkgs,
  lib,
  mode,
  ...
}:
{

  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      speed = 0.0;
      accel-profile = "adaptive";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.0;
      accel-profile = "adaptive";
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 600; # 10 mins
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 250;
      repeat-interval = lib.hm.gvariant.mkUint32 25;
      repeat = true;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        # "just-perfection-desktop@just-perfection" # clashes with stylix
        "hidetopbar@mathieu.bidon.ca"
      ];
    };
    "org/gnome/shell/extensions/just-perfection" = {
      panel = false; # remove top bar
      dash = false; # hide dock
      search = true;
    };
  };

}
