{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.system;
  superhtml = inputs.superhtml.packages.${system}.default;
  # ziggy = inputs.ziggy.packages.${system}.default;
in {
  home.packages = [
    pkgs.lua-language-server
    pkgs.nil
    pkgs.gopls
    # pkgs.ansible-language-server
    pkgs.ltex-ls
    # pkgs.ansible-lint
    pkgs.stylua
    pkgs.terraform-ls
    pkgs.zls
    superhtml
    # ziggy
    pkgs.astro-language-server
  ];
}
