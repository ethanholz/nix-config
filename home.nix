{
  config,
  pkgs,
  gopkgs,
  gitce,
  ...
}: let
  user = "ethan";
  base = "/home/${user}";
  git-ce = gitce;
  alacrittyTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/d2d26f1f02a800c6a5776a698b7ed4344332d8d5/extra/carbonfox/nightfox_alacritty.yml";
    sha256 = "0df8pgsn5lk8mym1lcqarr67mjf2rhj8hz6f6n1wmdygzg2yc422";
  };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = base;

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
    git-ce
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
    pkgs.fd
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.gopls
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
    pkgs.todoist
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/revive/revive.toml".source = ./revive/revive.toml;
    ".config/alacritty/carbonfox.yml".source = alacrittyTheme;
    ".config/zellij/layouts/ssh-layout.kdl".source =
      pkgs.writeText "ssh-layout.kdl"
      ''
        layout {
        }
      '';
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
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.go = {
    enable = true;
    package = gopkgs.go;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
      };
    };
  };

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
    userEmail = "iplaybassx2@gmail.com";
    signing = {
      key = "F5250C156C4CFD77";
      signByDefault = true;
    };
    ignores = [
      "salt-server.log"
      ".ccls*"
      "commit_convention.yml"
    ];
    includes = [
      {
        condition = "gitdir:${base}/Documents/code/work/**/*";
        path = "${base}/Documents/code/work/.gitconfig-work";
      }
    ];
    extraConfig = {
      url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
      difftool.prompt = true;
      difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      diff.tool = "nvimdiff";
      init.defaultBranch = "main";
      rebase.autoStash = true;
    };
  };

  programs.starship = {
    enable = true;
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
      default_shell = "zsh";
      theme = "modified_carbonfox";
      copy_command = "wl-copy";
      themes = {
        modified_carbonfox = {
          fg = "#f2f4f8";
          red = "#ee5396";
          green = "#de3163";
          blue = "#78a9ff";
          yellow = "#08bdba";
          magenta = "#be95ff";
          orange = "#3ddbd9";
          cyan = "#33b1ff";
          black = "#161616";
          white = "#b6b8bb";
          bg = "#b6b8bb";
        };
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      import = ["~/.config/alacritty/carbonfox.yml"];
      font = {
        normal.family = "JetBrains Mono Nerd Font";
        size = 14.0;
      };
      shell.program = "/bin/zsh";
    };
  };
}
