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
build profile:
    nix build --json --no-link --print-build-logs "{{ profile }}" \
    | jq -r ".[0].outputs.out"
build-home-manager name="ethan":
    just build ".#homeConfigurations.{{name}}.activationPackage"
build-darwin name="Ethans-Laptop":
    just build ".#darwinConfigurations.{{name}}.config.system.build.toplevel"

