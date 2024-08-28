{pkgs, ...}: {
  home.packages = [
    # Python
    pkgs.uv
    pkgs.micromamba
    pkgs.cookiecutter
    pkgs.pixi
    pkgs.ruff
    pkgs.pyright
    pkgs.rye
  ];
}
