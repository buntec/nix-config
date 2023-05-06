{ pkgs, ... }: {

  programs.git = {
    extraConfig = {
      credential.helper = "store";
    };
  };

}
