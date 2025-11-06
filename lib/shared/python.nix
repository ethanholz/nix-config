{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs) system;
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in {
  home.packages = [
    # Python
    pkgs-stable.micromamba
    pkgs.cookiecutter
    pkgs.ruff
    pkgs.pyright
    pkgs.rye
    pkgs.pre-commit
  ];
}
