{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    userEmail = pkgs.lib.mkDefault "christophbunte@gmail.com"; # we might want to override this
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

}
