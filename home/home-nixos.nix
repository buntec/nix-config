{
  pkgs,
  lib,
  mode,
  ...
}:
{
  programs.git = {
    extraConfig = {
      credential.helper = "store";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = -0.4;
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 250;
      repeat-interval = lib.hm.gvariant.mkUint32 25;
      repeat = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = if (mode == "light") then "default" else "prefer-dark";
    };
  };

  home.packages = with pkgs; [ docker ];

}
