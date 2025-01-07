{ config, pkgs, ... }:

{
  networking.hostName = "macbook-pro-m1";

  homebrew = {
    brews = [
      "pixi"
    ];
    casks = [
      "racket"
      "slack"
      "utm"
      "vmware-fusion"
      "whatsapp"
    ];
  };

}
