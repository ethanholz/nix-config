{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    freeze-flake.url = "github:charmbracelet/freeze/6ee576f381e3a464718a72b8c7a805af91462175";
    zig.url = "github:mitchellh/zig-overlay";
    zls-flake = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    superhtml.url = "https://flakehub.com/f/ethanholz/superhtml-flake/0.5.0.tar.gz";
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
    mkDarwin = self.lib.mkDarwin {};
    mkStandalone = self.lib.mkStandalone {};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        lib = import ./lib {inherit inputs;};
        darwinConfigurations."Ethans-Laptop" = mkDarwin {system = "aarch64-darwin";};
        homeConfigurations."ethan" = mkStandalone {system = "x86_64-linux";};
        homeConfigurations."ethan-aarch64" = mkStandalone {system = "aarch64-linux";};
        # This is for using in GH Actions
        homeConfigurations."runner" = mkStandalone {system = "x86_64-linux";};
      };

      systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
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
}
