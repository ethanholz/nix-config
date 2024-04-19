{
  description = "Home Manager configuration of ethan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-ce.url = "github:ethanholz/git-ce";
    freeze-flake.url = "github:charmbracelet/freeze";
    zig.url = "github:mitchellh/zig-overlay";
    zls-flake = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grlx.url = "github:ethanholz/grlx-flake";
  };

  outputs = {
    nixpkgs,
    home-manager,
    git-ce,
    zig,
    zls-flake,
    grlx,
    freeze-flake,
    ...
  }: let
    system = "x86_64-linux";
    gitce = git-ce.packages.${system}.default;
    zls = zls-flake.packages.${system}.default;
    freeze = freeze-flake.packages.${system}.default;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [zig.overlays.default];
      config = {allowUnfree = true;};
    };
  in {
    homeConfigurations."ethan" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix ./lsp.nix ./ocaml.nix ./python.nix];
      extraSpecialArgs = {inherit gitce grlx zls freeze;};

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
