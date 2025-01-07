{
  config,
  pkgs,
  machine,
  ...
}:
{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    extra-substituters = https://nix-community.cachix.org https://devenv.cachix.org
  '';

  # use TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    defaults = {
      dock = {
        autohide = true;
        static-only = true; # show only running apps
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false; # disable "natural" scroll

        # key repeat: lower is faster
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
      };
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = [
    # pkgs.kitty
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "discord"
      "firefox"
      "google-chrome"
      "keepassxc"
      "kitty"
      "skim"
      "spotify"
    ];
  };

  # environment.shells = [ pkgs.fish ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.tailscale.enable = true;

  nix.package = pkgs.nix; # this is the default

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.${machine.user} = {
    home = "/Users/${machine.user}";
    # shell = pkgs.fish;
  };
}
