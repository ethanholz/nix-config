{inputs}: let
  defaultUsername = "ethan";
  pkgs = inputs.nixpkgs;
  pkgs-stable = inputs.nixpkgs-stable;
in {
  mkStandalone = {userName ? defaultUsername}: {system}:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import pkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [
        (import ./shared/home.nix {inherit inputs pkgs-stable;})
        ./shared/lsp.nix
        (import ./shared/python.nix {inherit pkgs-stable;})
        ./shared/nix.nix
      ];
      # modules = [./home.nix ./lsp.nix ./ocaml.nix ./python.nix];
      extraSpecialArgs = {inherit inputs userName pkgs-stable;};
    };
  mkDarwin = {userName ? defaultUsername}: {system}:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        {
          # Manage using determinate Nix instead
          nix.enable = false;

          nixpkgs.config.allowUnfree = true;
          environment.etc."determinate/config.json".text = ''
            {
                "authentication": {
                    "additionalNetrcSources": [
                        "/Users/ethan/.config/nix/netrc"
                    ]
                }
            }
          '';

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          programs.fish.enable = true;
          system.stateVersion = 4;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          users.users.${userName}.home = "/Users/${userName}";
          determinate-nix.customSettings = {
            trusted-users = ["root" "${userName}"];
          };
        }
        inputs.determinate.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userName} = {pkgs, ...}: {
            imports = [
              # inputs.ghostty.homeModules.default
              (import ./shared/home.nix {inherit inputs pkgs userName;})
              (import ./shared/lsp.nix {inherit inputs pkgs;})
              (import ./shared/python.nix {inherit inputs pkgs pkgs-stable;})
              (import ./shared/nix.nix {inherit inputs pkgs;})
            ];
          };
        }
      ];
    };
}
