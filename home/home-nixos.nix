{ pkgs, ... }: {
  programs.git = { extraConfig = { credential.helper = "store"; }; };

  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = { natural-scroll = false; };
  };

  home.packages = with pkgs; [ docker ];
}
