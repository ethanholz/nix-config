{
  description = "Home Manager configuration of ethan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-ce.url = "github:ethanholz/git-ce";
  };

  outputs = {
    nixpkgs,
    home-manager,
    git-ce,
    ...
  }: let
    version = "1.20.6";
    goverlay = final: prev: {
      go =
        prev.go.overrideAttrs
        (old: {
          inherit version;
          src =
            final.fetchurl
            {
              url = "https://go.dev/dl/go${version}.src.tar.gz";
              sha256 = "0w3z1cp0jrr8kqkr7ksfddi56r3dz26wpq05yzlbmf2mzg35pvk2";
            };
        });
    };
    system = "x86_64-linux";
    gitce = git-ce.packages.${system}.default;
    pkgs = import nixpkgs {
      inherit system;
    };
    gopkgs = import nixpkgs {
      inherit system;
      overlays = [goverlay];
    };
  in {
    homeConfigurations."ethan" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];
      extraSpecialArgs = {inherit gopkgs gitce;};

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
