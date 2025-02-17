{ pkgs, ... }:
{

  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty; # currently marked broken on Darwin
  };

}
