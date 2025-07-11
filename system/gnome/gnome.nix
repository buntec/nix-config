{ pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      # disableWhileTyping = true;
      # horizontalScrolling = true;
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour # remove annoying tour popup on first start
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    dconf-editor
  ];

}
