{ pkgs, mode, ... }:

let

  claudeSettings = {
    theme = mode;
    model = "opus";
    env = {
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
    };

    editorMode = "vim";
    permissions = {
      allow = [ "WebFetch" ];
      deny = [ ];
    };

    # effortLevel = "xhigh";
    # preferredNotifChannel = "terminal_bell";

    statusLine = {
      type = "command";
      command = "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context\"'";
    };

    enabledPlugins = {
      "clangd-lsp@claude-plugins-official" = true;
      "pyright-lsp@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
    };

    hooks =
      let
        btmuxHook = {
          type = "command";
          command = "curl -s -X POST -H 'Content-Type: application/json' --data-binary @- \"\${BTMUX_API_URL}/api/panes/\${BTMUX_PANE_ID}/notify\" >/dev/null";
        };
      in
      {
        SessionStart = [ ];
        SessionEnd = [ ];
        UserPromptSubmit = [ ];
        Stop = [
          {
            hooks = [ btmuxHook ];
          }
        ];
        PermissionRequest = [
          {
            hooks = [ btmuxHook ];
          }
        ];
        StopFailure = [
          {
            hooks = [ btmuxHook ];
          }
        ];
        SubagentStop = [
          {
            hooks = [ btmuxHook ];
          }
        ];
        TaskCompleted = [
          {
            hooks = [ btmuxHook ];
          }
        ];
        Notification = [
          {
            hooks = [ btmuxHook ];
          }
        ];
        PostToolUse = [ ];
      };

  };

in

{

  programs.claude-code = {
    enable = true;
    package = null;
    settings = claudeSettings;
  };

}
