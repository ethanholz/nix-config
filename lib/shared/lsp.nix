{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.system;
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
    # ziggy
    pkgs.astro-language-server
    pkgs.svelte-language-server
    pkgs.typescript-language-server
    pkgs.just-lsp
    pkgs.yaml-language-server
    pkgs.harper
    pkgs.luajitPackages.tree-sitter-cli
  ];
}
