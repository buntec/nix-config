{ pkgs, lib, ... }:
{

  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour # remove annoying tour popup on first start
  ];

  # environment.systemPackages = with pkgs; [ gnomeExtensions.just-perfection ];

}
