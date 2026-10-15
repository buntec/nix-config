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

      wallpaper-shader = "ink-flow";
      wallpaper-saturate = 1.0;
      wallpaper-speed = 1.0;
      wallpaper-fps = 60;
      wallpaper-shader-follows-keyboard-input = true;

      wallpaper-shader-params = {
        chroma-flow = {
          intensity = 1;
          momentum = 25;
          radius = 2;
        };
        ink-flow = {
          curl = 0;
          decay = 2;
          momentum = 0.5;
          radius = 0.25;
        };
      };
    };
  };
}
