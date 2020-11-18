pkgs:
let
  syntax-highlighting = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
  autosuggestions = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
  powerlevel10k = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  gruvbox-material-dark = ./p10k-themes/gruvbox-material-dark.zsh;
  gruvbox-material-light = ./p10k-themes/gruvbox-material-light.zsh;
  theme = gruvbox-material-dark;
in
pkgs.writeText "zshrc" ''

# Startx and startup
# if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
  source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
fi

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory

# Setup custom interactive shell init stuff
# Bind gpg-agent to this TTY if gpg commands are used.
export GPG_TTY=$(tty)

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)    # Include hidden files.

# use emacs mode
bindkey -e

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# This function is called whenever a command is not found.
command_not_found_handler() {
  local p=/nix/store/3ialdl03v18nh05965598vj0w0xdgp4b-command-not-found/bin/command-not-found
  if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
    # Run the helper program.
    $p "$@"

    # Retry the command if we just installed it.
    if [ $? = 126 ]; then
      "$@"
    fi
  else
    # Indicate than there was an error so ZSH falls back to its default handler
    echo "$1: command not found" >&2
    return 127
  fi
}

# Setup aliases.
alias l='ls -alh'
alias ll='ls -l'
alias ls='ls --color=tty'

# Set up direnv
command -v direnv > /dev/null && eval "$(direnv hook zsh)"
# Powerlevel10k
source ${powerlevel10k}
# Theme
source ${theme}
# Auto Suggestions
source ${autosuggestions}
# Load zsh-syntax-highlighting; should be last.
source ${syntax-highlighting}
''
