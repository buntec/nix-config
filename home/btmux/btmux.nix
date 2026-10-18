{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.btmux.homeManagerModules.default ];

  programs.btmux = {
    enable = true;
    service.enable = true;
    desktop.enable = true;
    enableFishIntegration = true;

    settings = {
      shell = "${pkgs.fish}/bin/fish";

      wallpaper-opacity = 0.25;
      wallpaper-saturate = 1.0;
      wallpaper-speed = 1.0;
      wallpaper-fps = 60;
      wallpaper-shader-follows-keyboard-input = true;

      wallpaper-shader = [
        {
          shader = "ink-flow";
          params = {
            color-speed = 1.2;
            curl = 0;
            decay = 1.75;
            force = 1.7;
            radius = 0.2;
          };
        }
        {
          shader = "pixelate";
          params = {
            gap = 0;
            roundness = 0;
            scale = 100;
          };
        }
      ];
    };
  };
}
