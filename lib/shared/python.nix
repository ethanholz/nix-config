{
  config,
  pkgs,
  gitce,
  zls,
  ...
}: {
  home.packages = [
    # Python
    pkgs.uv
    pkgs.micromamba
    pkgs.cookiecutter
    pkgs.ruff
  ];
}
