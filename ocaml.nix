{ config
, pkgs
, gitce
, ...
}:
{
    home.packages = [
        pkgs.opam
    ];
}
