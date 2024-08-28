{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.system;
  zls = inputs.zls-flake.packages.${system}.default;
  superhtml = inputs.superhtml.packages.${system}.default;
  ziggy = inputs.ziggy.packages.${system}.default;
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
    zls
    superhtml
    # The below is because ziggy is currently broken on linux
  ] ++ (if pkgs.stdenv.isDarwin then [ziggy] else []);
}
