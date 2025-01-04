{ config, pkgs, ... }:

{

  networking.hostName = "macbook-pro-m1";

  homebrew = {
    brews = [
      "pixi"
    ];
    casks = [
      "racket"
      "vmware-fusion"
      "slack"
      "whatsapp"
    ];
  };

}
