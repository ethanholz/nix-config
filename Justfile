update:
    nix flake update

switch := if os() == "macos" { "just switch-darwin " } else { "just switch-ha" }
build := if os() == "macos" { "just build-darwin" } else if arch() == "aarch64" { "just build-home-manager-arm" } else { "just build-home-manager" }

switch:
    {{ switch }}

switch-ha:
    home-manager switch --flake .

switch-darwin:
    sudo darwin-rebuild switch --flake .

fmt:
    nix fmt

prefetch url:
    @nix-prefetch-url {{ url }} --type sha256 2> /dev/null | xargs wl-copy

build:
    {{ build }}

build-system profile:
    set -e
    nix build --no-link --print-build-logs --accept-flake-config "{{ profile }}"

build-home-manager name="ethan":
    just build-system ".#homeConfigurations.{{ name }}.activationPackage"

build-home-manager-arm name="ethan-aarch64":
    just build-system ".#homeConfigurations.{{ name }}.activationPackage"

build-darwin name="Ethans-Laptop":
    just build-system ".#darwinConfigurations.{{ name }}.config.system.build.toplevel"
