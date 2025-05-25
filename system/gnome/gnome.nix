{ pkgs, lib, ... }:
{
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

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
    # gnomeExtensions.just-perfection # clashes with stylix
    gnomeExtensions.hide-top-bar
  ];

}
