autoload -U colors && colors

# source ~/apps/zsh-autocomplete/zsh-autocomplete.plugin.zsh

### General
# allow comments in zsh shell
setopt interactivecomments
# Disable ^S, ^Q, ^\
setopt noflowcontrol
stty -ixon quit undef

setopt autocd
setopt correct
# Don't guess when slashes should be removed (too magic)
setopt noautoremoveslash
# Disable 'do you wish to see all %d possibilities'
LISTMAX=999999

### History
setopt histignoredups
setopt histignorespace
# Append immediately rather than only at exit
setopt inc_append_history
setopt appendhistory
# Store some metadata as well
setopt extendedhistory

# setopt share_history
HISTFILE=~/.zsh_history
HISTSIZE=40000
SAVEHIST=40000
 # Don't add these to the history file.
HISTORY_IGNORE='([bf]g *|disown|cd ..|cd -)'

### Completion
autoload -U compinit && compinit && zmodload zsh/complist
zstyle ':completion:*' completer _expand _complete _ignored

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Always ignore these files/functions
zstyle ':completion:*:*:*:*:*files' ignored-patterns '*?.pyc'

# Show more info in some completions
zstyle ':completion:*' verbose yes

# Warn when there are no completions
zstyle ':completion:*:warnings' format 'No completions'

# # Show ls-like colours in file completion
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### Prompt
# Expand parameters commands, and arithmetic in PROMPT
setopt promptsubst
PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
    zle reset-prompt

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
    zle reset-prompt
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

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


source ~/.config/scripts/completion.zsh
source ~/.config/scripts/key-bindings.zsh

### Paths
export PATH=$PATH:$HOME/.config/scripts
export PATH="$HOME/.local/bin:$PATH"

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

eval "$(hub alias -s)"
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --follow --glob "!.git/*"'
export PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

source /home/dzmitry/apps/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

