{pkgs, ...}: {
  home.packages = [
    # Python
    pkgs.uv
    pkgs.micromamba
    pkgs.cookiecutter
    pkgs.ruff
    pkgs.pixi
    pkgs.ruff
    pkgs.pyright
    pkgs.rye
  ];
}
