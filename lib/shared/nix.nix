{pkgs, ...}: {
    home.packages = [ 
        pkgs.nixd
        pkgs.nix-prefetch-github
        pkgs.statix
        pkgs.alejandra
        pkgs.cachix
    ];
}
