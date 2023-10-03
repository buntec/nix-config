{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [{
      plugin = lazy-nvim;
      type = "lua";
      config = (builtins.readFile ./lazy.lua);
    }];

    extraPackages = with pkgs; [ gopls haskell-language-server ];

    extraLuaConfig = (builtins.readFile ./init.lua);
  };
}
