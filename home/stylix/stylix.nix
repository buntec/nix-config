{ pkgs, ... }:

{

  stylix = {
    targets.neovim = {
      transparentBackground = {
        main = true;
        numberLine = true;
        signColumn = true;
      };
    };
  };

}
