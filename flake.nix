{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    freeze-flake.url = "github:charmbracelet/freeze/fc03c0d7dda8eb742c0f64b4174e9d9720d50bf0";
    zig.url = "github:mitchellh/zig-overlay";
    zls-flake = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ghostty.url = "github:clo4/ghostty-hm-module";
    superhtml.url = "https://flakehub.com/f/ethanholz/superhtml-flake/0.5.0.tar.gz";
    ziggy.url = "github:kristoff-it/ziggy";
    git-ce.url = "github:ethanholz/git-ce";
    # TODO: Waiting on https://github.com/brizzbuzz/opnix/pull/16 so we can actually use on nix-darwin
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }: let
    mkDarwin = self.lib.mkDarwin {};
    mkStandalone = self.lib.mkStandalone {};
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        lib = import ./lib {inherit inputs;};
        darwinConfigurations."Ethans-Laptop" = mkDarwin {system = "aarch64-darwin";};
        homeConfigurations."ethan" = mkStandalone {system = "x86_64-linux";};
        homeConfigurations."ethan-aarch64" = mkStandalone {system = "aarch64-linux";};
        # This is for using in GH Actions
        homeConfigurations."runner" = mkStandalone {system = "x86_64-linux";};
      };

      systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          buildInputs = [pkgs.just pkgs.jq];
        };
      };
    };
}
