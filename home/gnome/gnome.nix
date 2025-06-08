{
  pkgs,
  lib,
  mode,
  ...
}:
{

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      toggle-fullscreen = [ "<Super>f" ];
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "ctrl:nocaps"
        "compose:ralt"
      ];
    };
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
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
        "space-bar@luchrioh"
      ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      show-favorites = false;
      intellihide = false;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      panel = false; # remove top bar
      dash = false; # hide dock
      search = true;
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    # arcmenu
    # date-menu-formatter
    # forge
    # just-perfection # clashes with stylix
    # appindicator
    # caffeine
    dash-to-panel
    hide-top-bar
    space-bar
    # tray-icons-reloaded
    # user-themes
    vitals
  ];

}
