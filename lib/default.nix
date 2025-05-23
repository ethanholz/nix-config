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
          # environment.systemPackages =
          #   [
          #   ];
          nix.enable = true;

          nixpkgs.config.allowUnfree = true;
          nix.gc = {
            automatic = true;
            interval = [
                {
                    Hour = 8;
                    Minute = 0;
                    Weekday = 1;
                }
            ];
          };

          # Necessary for using flakes on this system.
          # nix.settings.experimental-features = "nix-command flakes";
          nix.settings = {
            experimental-features = "nix-command flakes";
            trusted-users = ["root" "${userName}"];
            trusted-substituters = ["https://cache.nixos.org" "https://git-ce.cachix.org" "https://action-table.cachix.org"];
            trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "git-ce.cachix.org-1:U+Gm5iuIbU4Q/RKIlK1eCB5HPXH5eqDTlp4tbOjG30M=" "action-table.cachix.org-1:IbI8XIJqLPAuAPS4c9X86ZJ0vgwwJpZHXO38IbknRAQ="];
          };

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          programs.fish.enable = true;
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          # system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
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
          # home-manager.extraSpecialArgs = {inherit gitce freeze zls pkgs userName;};
          # extraSpecialArgs = {inherit inputs.gitce inputs.grlx inputs.zls inputs.freeze;};
          # home-manager.sharedModules = [./nix-config/lsp.nix];
        }
      ];
    };
}
