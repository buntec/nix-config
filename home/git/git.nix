{ pkgs, ... }:
{

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
      # fetch anonymously over https, push with the ssh key
      url."git@github.com:".pushInsteadOf = "https://github.com/";
      diff.sqlite3.textconv = "${pkgs.writeShellScript "sqlite-textconv" ''
        exec ${pkgs.sqlite}/bin/sqlite3 "$1" .dump
      ''}";
    };
  };

  home.file.".tigrc".source = ./.tigrc;
}
