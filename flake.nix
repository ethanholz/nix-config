{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    freeze-flake.url = "github:charmbracelet/freeze";
    zig.url = "github:mitchellh/zig-overlay";
    git-ce.url = "github:ethanholz/git-ce";
    zls-flake = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      };

      systems = ["aarch64-darwin" "x86_64-linux"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };
}
