update:
    nix flake update
switch-ha:
    home-manager switch --flake .
switch-darwin:
   darwin-rebuild switch --flake .
fmt:
    nix fmt
prefetch url:
    @nix-prefetch-url {{url}} --type sha256 2> /dev/null | xargs wl-copy
