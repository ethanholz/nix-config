{pkgs, ...}: let
  inherit (pkgs) system;
  font-size =
    if pkgs.stdenv.isDarwin
    then "15"
    else "14";
in {
  home.sessionPath = [
    "/opt/homebrew/opt/node@22/bin"
    "/opt/homebrew/bin"
    "/opt/podman/bin"
    "/Applications/Obsidian.app/Contents/MacOS"
  ];

  programs.ghostty = {
    enable = true;
    # TODO: make this Linux capable in the future
    package = null;
    settings = {
      font-size = font-size;
      font-family = "GeistMono Nerd Font";
      theme = "Carbonfox";
      font-thicken = true;
      quit-after-last-window-closed = true;
      shell-integration-features = "no-cursor,ssh-env,ssh-terminfo";
      #   shell-integration = fish
      cursor-style = "block";
      command = "${pkgs.fish}/bin/fish";
      auto-update-channel = "tip";
      auto-update = "download";
      keybind = [
        "shift+enter=text:\n"
      ];
    };
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
