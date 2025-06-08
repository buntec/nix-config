{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    userEmail = pkgs.lib.mkDefault "christophbunte@gmail.com"; # we might want to override this
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
    extraConfig = {
      column = {
        ui = "auto";
      };

      branch = {
        sort = "-committerdate";
      };

      tag = {
        sort = "-version:refname";
      };

      push = {
        autoSetupRemote = true;
      };

      init = {
        defaultBranch = "main";
      };
    };
  };

  home.file.".tigrc".source = ./.tigrc;
}
