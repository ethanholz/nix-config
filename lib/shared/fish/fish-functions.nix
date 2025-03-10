{pkgs}: {
  copy =
    if pkgs.stdenv.isDarwin
    then ''
      $argv | pbcopy
    ''
    else ''
      if test $WAYLAND_DISPLAY
          $argv | wl-copy
      else
          $argv | xclip -sel c
      end
    '';
  copycat = ''
    set filename $argv[1]
    if not test -f $filename
        echo "File not found"
        return
    end
    copy cat $filename
  '';

  copycatfuzz = ''
    set selection (fzf)
    copycat $selection
    set -e selection
  '';

  new-session = ''
    zoxide query --interactive -- $argv[1]
    if test $status -ne 0
        return
    end
    zellij --session (basename (pwd))
    cd $current
  '';
  git-top-level = ''
    set item (git rev-parse --show-toplevel)
    if test $status -eq 0
        echo (basename $item)
    else
        echo (basename (pwd))
    end
  '';
  zellij-session = ''
    set current = (pwd)
    set change (zoxide query --interactive -- $argv[1])
    if test $status -ne 0
        return
    end
    cd $change
    set name (git-top-level)
    set item (zellij ls 2> /dev/null | grep $name)
    if test $status -ne 0
        zellij --session "$name"
    else
        zellij a "$name"
    end
    cd $current
  '';
  zellij-list = ''
    if test -z $argv[1]
        set item (zellij ls -s)
    else
        set item (zellij ls -s | grep $argv[1])
    end
    if test $status -ne 0
        new-session $argv[1]
    else
        string join \n $item | fzf | xargs -o zellij a
    end
  '';
  zellij-session-create = ''
    zellij --session (git-top-level)
  '';
  zellij-session-delete = ''
    zellij ls -s | fzf | xargs -o zellij d
  '';
  jump = ''
    set current = (pwd)
    set change (zoxide query --interactive -- $argv[1])
    if test $status -ne 0
        return
    end
    cd $change
  '';
  aws-login = ''
    aws sso login --sso-session $argv[1]
  '';
}
