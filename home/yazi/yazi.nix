{ pkgs, ... }:
{
  # https://github.com/sxyazi/yazi
  programs.yazi = {
    enable = true;

    keymap = {
      mgr = {
        prepend_keymap = [
          {
            run = "leave";
            on = "-";
          }
          {
            run = "seek 20";
            on = "<C-d>";
          }
          {
            run = "seek -20";
            on = "<C-u>";
          }
        ];
      };
    };

    settings = {
      mgr = {
        linemode = "size";
        ratio = [
          0
          4
          4
        ];
      };
    };
  };
}
