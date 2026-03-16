{pkgs, ...}: let
  inherit (pkgs) system;
in {
  home.sessionPath = [
    "/opt/homebrew/opt/node@22/bin"
    "/opt/homebrew/bin"
    "/opt/podman/bin"
    "/Applications/Obsidian.app/Contents/MacOS"
  ];
}
