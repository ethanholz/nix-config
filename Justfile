update:
    nix flake update
    home-manager switch
switch:
    home-manager switch
fmt:
    nix fmt
prefetch url:
    @nix-prefetch-url {{url}} --type sha256 2> /dev/null | xargs wl-copy
