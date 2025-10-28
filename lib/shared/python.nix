{pkgs, ...}: {
  home.packages = with pkgs; [
    # Python
    micromamba
    cookiecutter
    ruff
    pyright
    rye
    pre-commit
  ];
}
