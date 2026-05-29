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
    pkgs.ltex-ls
    pkgs.stylua
    pkgs.terraform-ls
    pkgs.zls
    pkgs.astro-language-server
    pkgs.svelte-language-server
    pkgs.typescript-language-server
    pkgs.just-lsp
    pkgs.yaml-language-server
    pkgs.harper
    pkgs.luajitPackages.tree-sitter-cli
    pkgs.actionlint
    pkgs.vscode-langservers-extracted
  ];
}
