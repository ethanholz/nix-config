{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs) system;
in {
  home.packages = [
    # Python
    pkgs.micromamba
    pkgs.cookiecutter
    pkgs.ruff
    pkgs.pyright
    pkgs.rye
    pkgs.pre-commit
  ];
}
