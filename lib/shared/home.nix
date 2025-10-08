{
  inputs,
  pkgs,
  userName,
  ...
}: let
  inherit (pkgs) system lib;
  freeze = inputs.freeze-flake.packages.${system}.default;
  zig = inputs.zig.packages.${system}."0.15.1";
  base =
    if pkgs.stdenv.isDarwin
    then "/Users/${userName}"
    else "/home/${userName}";
  font-size =
    if pkgs.stdenv.isDarwin
    then "15"
    else "14";
  carbonfox = inputs.carbonfox;
in {
  home.username = userName;
  home.homeDirectory = base;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.sessionPath =
    [
      "$HOME/.local/bin"
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
      "$HOME/.cache/rebar3/bin"
      "$HOME/.pixi/bin"
      "$HOME/.bun/bin"
      "$GHOSTTY_BIN_DIR"
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      "/opt/homebrew/opt/node@22/bin"
      "/opt/homebrew/bin"
      "$HOME/.opencode/bin"
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
    zig

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
    pkgs.ripgrep
    pkgs.age
    pkgs.sops
    pkgs.golangci-lint
    pkgs.gitleaks
    # Git
    pkgs.bfg-repo-cleaner
    pkgs.just
    pkgs.git-cliff
    pkgs.nodePackages.typescript
    pkgs.yq-go
    pkgs.elixir
    pkgs.goreleaser
    pkgs.yubikey-manager
    pkgs.tailwindcss
    pkgs.act
    pkgs.neovim
    pkgs.htop
    pkgs.btop
    pkgs.stow
    pkgs.ffmpeg
    pkgs.actionlint
    pkgs.jupyter
    pkgs.dive
    pkgs.opentofu
    pkgs.croc
    pkgs.pipx
    pkgs.glow
    pkgs.iperf3
    pkgs.commit-mono
    pkgs.geist-font
    pkgs.flyctl
    pkgs.libwebp
    pkgs.yt-dlp
    pkgs.vhs
    pkgs.cmake
    pkgs.minisign
    pkgs.typst
    pkgs.turso-cli
    pkgs.scorecard
    pkgs.websocat
    pkgs.duckdb
    pkgs.hugo
    pkgs.attic-client
    pkgs.sqlc
    pkgs.tflint
    pkgs.syft
    pkgs.repomix
    pkgs.azure-storage-azcopy
    pkgs.lychee
    pkgs.vscode-langservers-extracted
    pkgs.prettierd
  ];
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zsh/plugins/zsh-functions/zsh-functions.zsh".source = ./zsh/zsh-functions.zsh;
    ".config/zls.json".text = ''
      {
          "enable_build_on_save": true,
          "build_on_save_step": "check"
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
    editor = "nvim";
  };

  programs.ghostty = {
    enable = true;
    # TODO: make this Linux capable in the future
    package = lib.mkIf pkgs.stdenv.isDarwin null;
    settings = {
      font-size = font-size;
      font-family = "GeistMono Nerd Font";
      theme = "Carbonfox";
      font-thicken = true;
      quit-after-last-window-closed = true;
      shell-integration-features = "no-cursor,ssh-env,ssh-terminfo";
      #   shell-integration = fish
      cursor-style = "block";
      command = "${pkgs.fish}/bin/fish";
      auto-update-channel = "tip";
      auto-update = "download";
      keybind = [
        "shift+enter=text:\n"
      ];
      macos-icon = "retro";
    };
    enableFishIntegration = true;
    enableZshIntegration = true;
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
      ".oprc"
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
      pixi = {
        disabled = true;
      };
      custom = {
        jj = {
          command = ''
                        jj log --revisions @ --limit 1 --ignore-working-copy --no-graph --color always  --template '
              separate(" ",
                bookmarks.map(|x| truncate_end(10, x.name(), "…")).join(" "),
                tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
                surround("\"", "\"", truncate_end(24, description.first_line(), "…")),
                if(conflict, "conflict"),
                if(divergent, "divergent"),
                if(hidden, "hidden"),
              )
            '
          '';
          when = "jj --ignore-working-copy root";
          symbol = "jj ";
        };
        jjstate = {
          when = "jj --ignore-working-copy root";
          command = ''
            jj log -r@ -n1 --ignore-working-copy --no-graph -T "" --stat | tail -n1 | sd "(\d+) files? changed, (\d+) insertions?\(\+\), (\d+) deletions?\(-\)" ' \$\{1\}m \$\{2\}+ \$\{3\}-' | sd " 0." ""
          '';
        };
      };
    };
  };

  programs.fish = {
    enable = true;
    package = pkgs.fish;
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
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
      if test -e /Users/ethan/.deno/env.fish
        source /Users/ethan/.deno/env.fish
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
    initContent = ''
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

  programs.helix = {
    enable = true;
    settings = {
      theme = "carbonfox";
    };
  };
}
