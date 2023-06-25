{
  config,
  pkgs,
  ...
}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    # kitty
  ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override
      {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "DroidSansMono"
        ];
      })
  ];

  homebrew = {
    enable = true;
    casks = [
      "kitty"
      "firefox"
      "google-chrome"
      "brave-browser"
      "docker"
      "keepassxc"
      "spotify"
      "discord"
      "telegram"
      "whatsapp"
      "mattermost"
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
