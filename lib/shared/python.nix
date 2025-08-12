{pkgs, ...}: {
  home.packages = [
    # Python
    pkgs.micromamba
    pkgs.cookiecutter
    pkgs.ruff
    pkgs.pyright
    pkgs.rye
  ];
}
