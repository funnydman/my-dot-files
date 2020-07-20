setopt prompt_subst
autoload -U colors && colors

export PATH=$PATH:$HOME/.config/scripts
export PATH="$HOME/.local/bin:$PATH"

PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"


autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit

setopt autocd
# setopt correct
# HISTIGNOREDUPS prevents the current line from being saved
# in the history if it is the same as the previous one;
# HISTIGNORESPACE prevents the current line from being saved if it begins with a space.
setopt histignoredups
setopt histignorespace

# history settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history
# Include hidden files in autocomplete:

_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey -v

export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
    zle reset-prompt
}
zle -N zle-keymap-select

# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init

# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

# Use fzf to switch directories and bind it to ctrl-o
bindkey -s '^o' 'vim -o $(fzf)\n'  # zsh

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/dzmitry/apps/google-cloud-sdk/path.zsh.inc' ]; then . '/home/dzmitry/apps/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/dzmitry/apps/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/dzmitry/apps/google-cloud-sdk/completion.zsh.inc'; fi

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

source ~/.config/scripts/completion.zsh
source ~/.config/scripts/key-bindings.zsh

eval "$(hub alias -s)"
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow --glob "!.git/*"'
