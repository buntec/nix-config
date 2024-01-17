{ pkgs, lib, ... }: {
  programs.git = { extraConfig = { credential.helper = "store"; }; };

  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = { natural-scroll = false; };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = -0.4;
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 250;
      repeat-interval = lib.hm.gvariant.mkUint32 25;
      repeat = true;
    };
  };

  home.packages = with pkgs; [ docker ];

  programs.kitty.extraConfig = ''
    hide_window_decorations yes
  '';
}
