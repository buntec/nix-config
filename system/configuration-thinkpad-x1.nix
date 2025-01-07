{ config, pkgs, ... }:
{
  imports = [ ./gnome/gnome.nix ];

  networking.hostName = "thinkpad-x1";

  networking.networkmanager.enable = true;

  services.openssh.settings.PasswordAuthentication = false;

  users.users.buntec = {

    packages = with pkgs; [
      keepassxc
      spotify
      discord
      whatsapp-for-linux
    ];

  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # audio stuff
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

}
