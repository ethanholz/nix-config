{
  config,
  pkgs,
  gitce,
  zls,
  ...
}: {
  home.packages = [
    pkgs.lua-language-server
    pkgs.nil
    pkgs.gopls
    pkgs.ansible-language-server
    pkgs.ansible-lint
    zls
  ];
}
