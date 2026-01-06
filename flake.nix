{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zig.url = "github:mitchellh/zig-overlay";
    zls-flake = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    superhtml.url = "https://flakehub.com/f/ethanholz/superhtml-flake/0.6.2.tar.gz";
    ziggy.url = "github:kristoff-it/ziggy";
    carbonfox = {
      url = "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/refs/heads/main/extra/carbonfox/carbonfox.ghostty";
      flake = false;
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    mkDarwin = self.my_lib.mkDarwin {};
    mkStandalone = self.my_lib.mkStandalone {};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        my_lib = import ./lib {inherit inputs;};
        darwinConfigurations."Ethans-Laptop" = mkDarwin {
          system = "aarch64-darwin";
        };
      };

      systems = ["aarch64-darwin"];
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        pre-commit-config = {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            flake-checker.enable = true;
          };
        };
      in {
        formatter = let
          config = (inputs.git-hooks-nix.lib.${system}.run pre-commit-config).config;
          inherit (config) package configFile;
          script = ''
            ${pkgs.lib.getExe package} run --all-files --config ${configFile}
          '';
        in
          pkgs.writeShellScriptBin "pre-commit-run" script;

        # # Run the hooks in a sandbox with `nix flake check`.
        # # Read-only filesystem and no internet access.
        # checks = {
        #   pre-commit-check = inputs.git-hooks-nix.lib.${system}.run pre-commit-config;
        # };

        devShells.default = pkgs.mkShell {
          buildInputs = [pkgs.just pkgs.jq];
        };
      };
    };
  nixConfig = {
    extra-substituters = ["https://attic-testing.fly.dev/system"];
    extra-trusted-public-keys = ["system:jO6HbDP3xnQbHy/llnSubs8NPK7cVWwG827k6inRZkY="];
  };
}
