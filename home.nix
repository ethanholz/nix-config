{
  config,
  pkgs,
  gitce,
  grlx,
  freeze,
  ...
}: let
  user = "ethan";
  base = "/home/${user}";
  git-ce = gitce;
  grlx-cli = grlx.packages.x86_64-linux.default;
  # alacrittyTheme = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/main/extra/terafox/alacritty.toml";
  #   sha256 = "1q7cq7gc7s3pfa807rg4vc5ss78xngz136pa9a6vrvkwark40mjv";
  # };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = base;
  home.sessionPath = [
    "$HOME/.local/bin"
    "/usr/local/go/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.cache/rebar3/bin"
    "$HOME/.pixi/bin"
    "$HOME/.bun/bin"
  ];
  # environment.pathsToLink = ["/usr/share/zsh/vendor-completions"];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    freeze
    git-ce
    grlx-cli
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.pfetch
    pkgs.fd
    pkgs.govulncheck
    pkgs.revive
    pkgs.fzf
    pkgs.android-tools
    pkgs.scrcpy
    pkgs.ripgrep
    pkgs.age
    pkgs.sops
    pkgs.golangci-lint
    pkgs.gitleaks
    pkgs.natscli
    pkgs.nixd
    pkgs.git-lfs
    pkgs.bfg-repo-cleaner
    pkgs.minicom
    pkgs.cachix
    pkgs.just
    pkgs.hurl
    pkgs.git-cliff
    pkgs.google-cloud-sdk
    # node
    pkgs.nodePackages.typescript
    pkgs.rust-analyzer
    pkgs.nodejs_20
    pkgs.alejandra
    pkgs.yq-go
    pkgs.elixir
    pkgs.ranger
    pkgs.wally-cli
    pkgs.goreleaser
    pkgs.nfpm
    pkgs.wasmtime
    pkgs.wabt
    pkgs.wazero
    pkgs.rust-analyzer
    pkgs.yubikey-manager
    pkgs.helix
    pkgs.zigpkgs.master
    pkgs.tailwindcss
    pkgs.valgrind
    pkgs.ttyd
    pkgs.distrobox
    pkgs.slides
    pkgs.nushell
    pkgs.nix-prefetch-github
    pkgs.poop
    pkgs.kcov
    pkgs.act
    pkgs.delta
    pkgs.stripe-cli
    pkgs.extism-cli
    pkgs.uv
    pkgs.micromamba
    pkgs.cookiecutter
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/revive/revive.toml".source = ./revive/revive.toml;
    ".config/ghostty/config".source = ./ghostty/config;
    ".config/alacritty/terafox.toml".source = ./terafox.toml;
    ".config/alacritty/alacritty.toml".text = ''
      import = [ "~/.config/alacritty/terafox.toml" ]
      [font]
      size = 14.0
      [font.normal]
      family = "GeistMono Nerd Font"
      [shell]
      # program = "${pkgs.zsh}/bin/zsh"
      program = "${pkgs.fish}/bin/fish"
      [window]
      opacity = 0.90
    '';
    ".zsh/plugins/zsh-functions/zsh-functions.zsh".source = ./zsh/zsh-functions.zsh;
  };

  # You can also manage environment variables but you will have to manually
  # source
  # ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ethan/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    editor = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.go = {
  #   enable = true;
  #   package = pkgs.go_1_21;
  # };

  programs.gitui = {
    enable = true;
    keyConfig = ''
      (
          open_help: Some(( code: F(1), modifiers: ( bits: 0,),)),

          move_left: Some(( code: Char('h'), modifiers: ( bits: 0,),)),
          move_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
          move_up: Some(( code: Char('k'), modifiers: ( bits: 0,),)),
          move_down: Some(( code: Char('j'), modifiers: ( bits: 0,),)),

          popup_up: Some(( code: Char('p'), modifiers: ( bits: 2,),)),
          popup_down: Some(( code: Char('n'), modifiers: ( bits: 2,),)),
          page_up: Some(( code: Char('b'), modifiers: ( bits: 2,),)),
          page_down: Some(( code: Char('f'), modifiers: ( bits: 2,),)),
          home: Some(( code: Char('g'), modifiers: ( bits: 0,),)),
          end: Some(( code: Char('G'), modifiers: ( bits: 1,),)),
          shift_up: Some(( code: Char('K'), modifiers: ( bits: 1,),)),
          shift_down: Some(( code: Char('J'), modifiers: ( bits: 1,),)),

          edit_file: Some(( code: Char('I'), modifiers: ( bits: 1,),)),

          status_reset_item: Some(( code: Char('U'), modifiers: ( bits: 1,),)),

          diff_reset_lines: Some(( code: Char('u'), modifiers: ( bits: 0,),)),
          diff_stage_lines: Some(( code: Char('s'), modifiers: ( bits: 0,),)),

          stashing_save: Some(( code: Char('w'), modifiers: ( bits: 0,),)),
          stashing_toggle_index: Some(( code: Char('m'), modifiers: ( bits: 0,),)),

          stash_open: Some(( code: Char('l'), modifiers: ( bits: 0,),)),

          abort_merge: Some(( code: Char('M'), modifiers: ( bits: 1,),)),

          quit : Some(( code: Char('q'), modifiers: ( bits: 0,),)),
      )
    '';
    theme = ''
      (
          selected_tab: Reset,
          command_fg: White,
          selection_bg: Blue,
          selection_fg: White,
          cmdbar_bg: Blue,
          cmdbar_extra_lines_bg: Blue,
          disabled_fg: DarkGray,
          diff_line_add: Green,
          diff_line_delete: Red,
          diff_file_added: LightGreen,
          diff_file_removed: LightRed,
          diff_file_moved: LightMagenta,
          diff_file_modified: Yellow,
          commit_hash: Magenta,
          commit_time: LightCyan,
          commit_author: Green,
          danger_fg: Red,
          push_gauge_bg: Blue,
          push_gauge_fg: Reset,
          tag_fg: LightMagenta,
          branch_fg: LightYellow,
      )
    '';
  };

  programs.git = {
    enable = true;
    userName = "Ethan Holz";
    userEmail = "ethan.holz@thoriumworks.com";
    signing = {
      key = "B4E94FDF35334301";
      signByDefault = true;
    };
    ignores = [
      "salt-server.log"
      ".ccls*"
      "commit_convention.yml"
      ".direnv/"
      ".envrc"
    ];
    delta = {
      enable = true;
    };
    includes = [
      {
        condition = "gitdir:${base}/Documents/code/work/**/*";
        path = "${base}/Documents/code/work/.gitconfig-work";
      }
      {
        condition = "gitdir:${base}/Documents/code/work/";
        path = "${base}/Documents/code/work/.gitconfig-work";
      }
    ];
    extraConfig = {
      # url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
      # url."git@github.com:".insteadOf = "https://github.com/";
      # difftool.prompt = true;
      # difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      # diff.tool = "nvimdiff";
      init.defaultBranch = "main";
      rebase.autoStash = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {
        success_symbol = "[❯](purple)";
      };
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      cmd_duration = {
        min_time = 10000;
      };
      python = {
        pyenv_version_name = true;
      };
      cmake = {
        disabled = true;
      };
      java = {
        disabled = true;
      };
      gcloud = {
        disabled = true;
      };
      battery = {
        disabled = true;
      };
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      copy_command = "wl-copy";
      default_shell = "fish";
      theme = "terafox";
      themes = {
        terafox = {
          bg = "#152528";
          fg = "#e6eaea";
          red = "#e85c51";
          green = "#7aa4a1";
          blue = "#5a93aa";
          yellow = "#fda47f";
          magenta = "#ad5c7c";
          orange = "#ff8349";
          cyan = "#a1cdd8";
          black = "#254147";
          white = "#cbd9d8";
        };
        modified_carbonfox = {
          bg = "#b6b8bb";
          black = "#161616";
          blue = "#78a9ff";
          cyan = "#33b1ff";
          fg = "#f2f4f8";
          green = "#de3163";
          magenta = "#be95ff";
          orange = "#3ddbd9";
          red = "#ee5396";
          white = "#b6b8bb";
          yellow = "#08bdba";
        };
      };
      keybinds.locked = {
        "bind \"Ctrl p\"" = {SwitchToMode = "Pane";};
        "bind \"Ctrl h\"" = {MoveFocus = "Left";};
        "bind \"Ctrl j\"" = {MoveFocus = "Down";};
        "bind \"Ctrl k\"" = {MoveFocus = "Up";};
        "bind \"Ctrl l\"" = {MoveFocus = "Right";};
      };
    };
  };
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    functions = import fish/fish-functions.nix;
    shellAliases = import fish/fish-alias.nix;
    # interactiveShellInit = "set fish_greeting";
    interactiveShellInit = ''
      set fish_greeting
      set EDITOR nvim
      set SUDO_EDITOR nvim
      set -x GPG_TTY (tty)
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
      # gpg-connect-agent updatestartuptty /bye >/dev/null
      # source ~/.config/op/plugins.sh
    '';
  };
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    shellAliases = {
      # ls = "exa --icons";
      python = "python3";
      zs = "zellij-session-create";
      zlist = "zellij-list";
      zis = "zellij-session";
      zd = "zellij-delete";
      update = "sudo apt update && sudo apt upgrade && flatpak update";
    };
    enableCompletion = false;
    completionInit = "skip_global_compinit=1";
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete.src;
      }
    ];
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      SSH_AUTH_SOCK = "/run/user/$UID/gnupg/S.gpg-agent.ssh";
    };
    initExtra = ''
      gpg-connect-agent updatestartuptty /bye >/dev/null
      source $HOME/.zsh/plugins/zsh-functions/zsh-functions.zsh
      eval $(opam env)
    '';
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  programs.eza = {
    enable = true;
    icons = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      protocol = "ssh";
    };
  };

  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     import = [ "~/.config/alacritty/terafox.toml" ];
  #     font = {
  #       normal.family = "GeistMono Nerd Font";
  #       size = 14.0;
  #     };
  #     shell.program = "${pkgs.zsh}/bin/zsh";
  #   };
  # };
}
