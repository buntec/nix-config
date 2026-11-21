{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.btmux.homeManagerModules.default ];

  programs.btmux = {
    enable = true;

    service.enable = true;
    service.tailscale = true;

    desktop.enable = lib.mkDefault true;

    enableFishIntegration = true;
    fishPickMenus = true;

    settings = {
      shell = "${pkgs.fish}/bin/fish";
      native-editor = {
        vim = true;
        virtual-text = true;
      };

      wallpaper-opacity = 0.25;
      wallpaper-saturate = 1.0;
      wallpaper-speed = 1.0;
      wallpaper-fps = 60;
      wallpaper-shader-follows-keyboard-input = true;

      wallpaper-shader = [
        {
          shader = "aquarium";
          params = {
            pixel-size = 2;
            speed = 1;
          };
        }
      ];
    };
  };
}
