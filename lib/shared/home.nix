{
  inputs,
  pkgs,
  userName,
  ...
}: let
  inherit (pkgs) system;
  freeze = inputs.freeze-flake.packages.${system}.default;
  action-table = inputs.action-table.packages.${system}.default;
  # gitce = inputs.git-ce.packages.${system}.default;
  gitce-url =
    if pkgs.stdenv.isDarwin
    then "https://github.com/ethanholz/git-ce/releases/download/v0.4.1/git-ce-universal2-apple-darwin-0.4.1"
    else "https://github.com/ethanholz/git-ce/releases/download/v0.4.1/git-ce-x86_64-unknown-linux-musl-0.4.1";
  gitce-hash =
    if pkgs.stdenv.isDarwin
    then "1q21jyj09ban3ll23gisq69c6fs5n0p3q91ilnnxxhx4bvaip5sl"
    else "14gnxdc0c2jv6r84mlqxg84l8074i7i64a1ar8rk50pqfcmlvb42";
  gitce = pkgs.stdenvNoCC.mkDerivation {
    name = "git-ce";
    version = "v0.3.6";
    src = pkgs.fetchurl {
      url = gitce-url;
      sha256 = gitce-hash;
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/git-ce
      chmod +x $out/bin/git-ce
    '';
  };
  zig = inputs.zig.packages.${system}."0.13.0";
  base =
    if pkgs.stdenv.isDarwin
    then "/Users/${userName}"
    else "/home/${userName}";
  font-size =
    if pkgs.stdenv.isDarwin
    then "16"
    else "14";
  zellij-rose-pine = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/rose-pine/zellij/main/dist/rose-pine.kdl";
    sha256 = "18885c1x9zmjpxahmhffbnf7nf47jxq9baz0a8q6w3iwc088vjds";
  };
in {
  home.username = userName;
  home.homeDirectory = base;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.cache/rebar3/bin"
    "$HOME/.pixi/bin"
    "$HOME/.bun/bin"
    "/opt/homebrew/bin"
    "$GHOSTTY_BIN_DIR"
  ];
  # environment.pathsToLink = ["/usr/share/zsh/vendor-completions"];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    freeze
    gitce
    zig
    action-table
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
    # Git
    pkgs.bfg-repo-cleaner
    pkgs.minicom
    pkgs.just
    pkgs.git-cliff
    pkgs.google-cloud-sdk
    pkgs.nodePackages.typescript
    pkgs.rust-analyzer
    # pkgs.nodejs_20
    pkgs.nodejs_22
    pkgs.yq-go
    pkgs.elixir
    pkgs.ranger
    pkgs.goreleaser
    pkgs.nfpm
    pkgs.wasmtime
    pkgs.wabt
    pkgs.wazero
    pkgs.rust-analyzer
    pkgs.yubikey-manager
    pkgs.helix
    pkgs.tailwindcss
    pkgs.ttyd
    pkgs.act
    # pkgs.extism-cli
    pkgs.neovim
    pkgs.fermyon-spin
    pkgs.htop
    pkgs.btop
    pkgs.stow
    pkgs.wally-cli
    pkgs.ffmpeg
    pkgs.actionlint
    pkgs.jupyter
    pkgs.dive
    pkgs.opentofu
    pkgs.croc
    pkgs.pipx
    pkgs.glow
    pkgs.iperf3
    pkgs.mr
    pkgs.fio
    pkgs.commit-mono
    pkgs.geist-font
    pkgs.flyctl
    pkgs.libwebp
    pkgs.yt-dlp
    pkgs.vhs
    pkgs.cmake
    pkgs.fastfetch
    pkgs.minisign
    pkgs.typst
    pkgs.turso-cli
    pkgs.gleam
    pkgs.rebar3
    pkgs.scorecard
    pkgs.websocat
    pkgs.duckdb
    pkgs.nom
    pkgs.hugo
    pkgs.attic-client
    pkgs.sqlc
    pkgs.tflint
    pkgs.syft
    pkgs.repomix
    pkgs.azure-storage-azcopy
  ];
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/zellij/themes/rose-pine.kdl".source = zellij-rose-pine;
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
    ".config/zls.json".text = ''
      {
          "enable_build_on_save": true,
          "build_on_save_step": "check"
      }
    '';
    ".config/ghostty/config".text = ''
      font-size = ${font-size}
      font-family = GeistMono Nerd Font
      font-style = Regular
      theme = rose-pine-moon
      font-thicken = true
      quit-after-last-window-closed = true
      shell-integration-features = no-cursor
      shell-integration = fish
      cursor-style = block
      command = ${pkgs.fish}/bin/fish
      auto-update-channel = stable
      auto-update = download
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
    editor = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.go.enable = true;

  programs.lazygit = {
    enable = true;
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
    userEmail = "ethan.holz@thoriumworks.com";
    signing = {
      key = "B4E94FDF35334301";
      signByDefault = true;
    };
    lfs.enable = true;
    ignores = [
      "salt-server.log"
      ".ccls*"
      "commit_convention.yml"
      ".direnv/"
      ".envrc"
      "repomix-output.txt"
    ];
    includes = [
      {
        condition = "gitdir:${base}/Documents/code/work/**/*";
        path = "${base}/Documents/code/work/.gitconfig-work";
      }
      {
        condition = "gitdir:${base}/Documents/work/**/*";
        path = "${base}/Documents/work/.gitconfig-work";
      }
      {
        condition = "gitdir:${base}/Documents/code/work/";
        path = "${base}/Documents/code/work/.gitconfig-work";
      }
    ];
    aliases = {
        co = "checkout";
        a = "add";
    };
    extraConfig = {
      # url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
      # url."git@github.com:".insteadOf = "https://github.com/";
      # difftool.prompt = true;
      # difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      # diff.tool = "nvimdiff";
      init.defaultBranch = "main";
      rebase.autoStash = true;
      push.autoSetupRemote = true;
      # core.editor = "nvim";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
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
      aws = {
        disabled = true;
      };
    };
  };

  programs.zellij = {
    enable = false;
    settings = {
      copy_command = "wl-copy";
      default_shell = "fish";
      theme = "rose-pine";
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
    functions = import fish/fish-functions.nix {inherit pkgs;};
    shellAliases = import fish/fish-alias.nix;
    # interactiveShellInit = "set fish_greeting";
    interactiveShellInit = ''
      set fish_greeting
      set EDITOR nvim
      set SUDO_EDITOR nvim
        if set -q ZED_TERM && test $ZED_TERM = "true"
          set fish_greeting "Welcome to the Zed Terminal"
          set EDITOR zed --wait
        end

       set -x GPG_TTY (tty)
       set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
       gpgconf --launch gpg-agent
       eval "$(micromamba shell hook --shell fish)"
      set fish_cursor_default block
      # gpg-connect-agent updatestartuptty /bye >/dev/null
      # source ~/.config/op/plugins.sh
      if set -q GHOSTTY_RESOURCES_DIR
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
      end
      fish_vi_key_bindings
    '';
    shellInitLast = ''
      set fish_cursor_default block
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
      # GPG_TTY = "$(tty)";
      # SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      # SSH_AUTH_SOCK = "/run/user/$UID/gnupg/S.gpg-agent.ssh";
    };
    initExtra = ''
      # gpg-connect-agent updatestartuptty /bye >/dev/null
      source $HOME/.zsh/plugins/zsh-functions/zsh-functions.zsh
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
      # eval $(opam env)
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
    icons = "auto";
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      protocol = "ssh";
      aliases = {
        "b" = "browse";
      };
    };
    extensions = [pkgs.gh-dash];
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # programs.ghostty = {
  #   enable = true;
  #   shellIntegration.enable = false;
  #   settings = {
  #     inherit font-size;
  #     font-family = "GeistMono Nerd Font";
  #     font-style = "Regular";
  #     theme = "rose-pine-moon";
  #     command = "${pkgs.fish}/bin/fish";
  #     font-thicken = true;
  #     quit-after-last-window-closed = true;
  #     # shell-integration-features = "no-cursor";
  #     cursor-style = "block";
  #   };
  #   keybindings = {
  #     "super+left" = "goto_split:left";
  #     "super+right" = "goto_split:right";
  #   };
  # };
}
