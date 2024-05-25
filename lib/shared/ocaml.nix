{
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.opam
  ];
}
