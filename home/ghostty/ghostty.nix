{ pkgs, ... }:
{

  programs.ghostty = {
    enable = true;
    settings = {
      gtk-titlebar-hide-when-maximized = true;
      macos-option-as-alt = true;
    };
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty; # currently marked broken on Darwin
  };

}
