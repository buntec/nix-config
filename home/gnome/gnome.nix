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
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = -0.4;
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 600; # 10 mins
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 250;
      repeat-interval = lib.hm.gvariant.mkUint32 25;
      repeat = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme =
        if (mode == "light") then
          "default" # or "prefer-light" ???
        else
          "prefer-dark";
    };
    "org/gnome/shell/extensions/just-perfection" = {
      panel = false; # this removes the top bar
    };
  };

}
