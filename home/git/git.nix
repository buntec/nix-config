{ pkgs, ... }:
{

  programs.git = {
    enable = true;
    userEmail = pkgs.lib.mkDefault "christophbunte@gmail.com"; # we might want to override this
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
    extraConfig = {
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      tag.sort = "-version:refname";
    };
  };

  home.file.".tigrc".source = ./.tigrc;
}
