{ pkgs, ... }:
{

  programs.diff-so-fancy = {
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Christoph Bunte";
      user.email = pkgs.lib.mkDefault "christophbunte@gmail.com"; # we might want to override this
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
