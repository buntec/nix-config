{
  config,
  pkgs,
  machine,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.extraOptions = ''
    extra-trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    extra-substituters = https://nix-community.cachix.org https://devenv.cachix.org
  '';

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # https://github.com/NixOS/nix/issues/2982
  nix.channel.enable = false;

  # allow attaching to processes for e.g., heaptrack
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;

  services.tailscale = {
    enable = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      options = "ctrl:nocaps,compose:ralt";
      variant = "intl";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.${machine.user} = {
    description = "Christoph Bunte";

    isNormalUser = true;

    hashedPassword = "$y$j9T$vPUnEtURmG07hGZC8VKAD0$cXGnyTRcCpemAF.mAsL0xdVY1bSLXkvQOvTMYfgpdI5";

    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILp/zFH8Vb2GDOt4xSgjzRTYUULvPuJdb6MUnWvX7jbX christophbunte@gmail.com"
    ];

    packages = with pkgs; [
      chromium
      firefox
      keepassxc
      linuxPackages.perf
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    gnumake
    just
    vim # Do not forget to add an editor to edit configuration.nix!
    wget
    wl-clipboard
  ];

  programs.nix-ld.enable = true;

  # Shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
