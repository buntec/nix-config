{ config, pkgs, ... }: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    extra-substituters = https://nix-community.cachix.org https://cache.iog.io https://devenv.cachix.org
  '';

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs;
    [
      # kitty
    ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs;
    [
      (nerdfonts.override {
        fonts = [ "FiraCode" "JetBrainsMono" "DroidSansMono" ];
      })
    ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "brave-browser"
      "discord"
      "docker"
      "firefox"
      "google-chrome"
      "keepassxc"
      "kitty"
      "mattermost"
      "skim"
      "spotify"
      "telegram"
      "whatsapp"
    ];
  };

  # environment.shells = [ pkgs.fish ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix; # this is the default

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.christophbunte = {
    name = "christophbunte";
    home = "/Users/christophbunte";
    # shell = pkgs.fish;
  };
}
