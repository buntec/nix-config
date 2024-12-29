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
    "org/gnome/desktop/background" = {
      primary-color = "#999999";
      secondary-color = "#222222";
      picture-uri = "";
      picture-uri-dark = "";
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "just-perfection-desktop@just-perfection"
      ];
    };
    "org/gnome/shell/extensions/just-perfection" = {
      panel = false; # remove top bar
      dash = false; # hide dock
      search = true;
    };
  };

}
