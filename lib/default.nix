{inputs}: let
  defaultUsername = "ethan";
  pkgs = inputs.nixpkgs;
in {
  mkStandalone = {userName ? defaultUsername}: {system}:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import pkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [./shared/home.nix ./shared/lsp.nix ./shared/ocaml.nix ./shared/python.nix ./shared/nix.nix];
      # modules = [./home.nix ./lsp.nix ./ocaml.nix ./python.nix];
      extraSpecialArgs = {inherit inputs userName;};
    };
  mkDarwin = {userName ? defaultUsername}: {system}:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        {
          # Manage using determinate Nix instead
          nix.enable = false;

          nixpkgs.config.allowUnfree = true;

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          programs.fish.enable = true;
          system.stateVersion = 4;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          users.users.${userName}.home = "/Users/${userName}";
        }
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userName} = {pkgs, ...}: {
            imports = [
              # inputs.ghostty.homeModules.default
              (import ./shared/home.nix {inherit inputs pkgs userName;})
              (import ./shared/lsp.nix {inherit inputs pkgs;})
              (import ./shared/python.nix {inherit inputs pkgs;})
              (import ./shared/ocaml.nix {inherit inputs pkgs;})
              (import ./shared/nix.nix {inherit inputs pkgs;})
            ];
          };
        }
      ];
    };
}
