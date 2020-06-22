# OK to perform console I/O before this point.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# for rustup completions: mkdir ~/.zfunc, then put next line before compinit
fpath+=~/.zfunc

# let prompt at bottom
# printf "\n%.0s" {1..100}

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
# Zplugin annexes
# zinit-zsh/z-a-man \
zinit light-mode for \
    zinit-zsh/z-a-test \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-submods \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-rust

# OMZ
zinit light-mode for \
    OMZ::lib/clipboard.zsh \
    OMZ::lib/completion.zsh \
    OMZ::lib/history.zsh \
    OMZ::lib/key-bindings.zsh \
    OMZ::lib/theme-and-appearance.zsh \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
    OMZ::plugins/systemd/systemd.plugin.zsh \
    OMZ::plugins/sudo/sudo.plugin.zsh \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# lib/git.zsh is loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zinit wait lucid for \
    zdharma/zsh-unique-id \
    OMZ::lib/git.zsh \
 atload"unalias grv g" \
    OMZ::plugins/git/git.plugin.zsh

# zsh-autopair
# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zinit light-mode lucid for \
    hlissner/zsh-autopair \
    urbainvaes/fzf-marks

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zinit will
# grep operating system name and architecture automatically when there's no `bpick'.
zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
zinit load docker/compose

# Vim repository on GitHub – a typical source code that needs compilation – Zinit
# can manage it for you if you like, run `./configure` and other `make`, etc. stuff.
# Ice-mod `pick` selects a binary program to add to $PATH. You could also install the
# package under the path $ZPFX, see: http://zdharma.org/zinit/wiki/Compiling-programs
zinit ice as"program" atclone"rm -f src/auto/config.cache; ./configure" \
    atpull"%atclone" make pick"src/vim"
zinit light vim/vim

# Scripts that are built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zinit light tj/git-extras

# jarun/nnn, a file browser, using the for-syntax
zinit pick"misc/quitcd/quitcd.zsh" sbin make light-mode for jarun/nnn


# cheat
zinit ice mv":zsh -> _cht" as"completion"
zinit snippet https://cheat.sh/:zsh

# conda
zinit wait lucid as"completion" for \
  blockf esc/conda-zsh-completion

# Fast-syntax-highlighting & autosuggestions
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# Theme no. 1 – pure
#zinit lucid load'![[ $MYPROMPT = 1 ]]' unload'![[ $MYPROMPT != 1 ]]' \
# pick"/dev/null" multisrc"{async,pure}.zsh" atload'!prompt_pure_precmd' nocd for \
#    sindresorhus/pure

# Theme no. 2 - powerlevel10k
#zinit load'![[ $MYPROMPT = 2 ]]' unload'![[ $MYPROMPT != 2 ]]' \
# atload'!source ~/.p10k.zsh; _p9k_precmd' lucid nocd for \
#    romkatv/powerlevel10k

zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

zinit wait'1' lucid from"gh-r" as"null" for \
     sbin"fzf"          junegunn/fzf-bin \
     sbin"**/fd"        @sharkdp/fd \
     sbin"**/bat"       @sharkdp/bat \
     sbin"exa* -> exa"  ogham/exa

# A few wait'2' plugins
zinit wait'2' lucid for \
    zdharma/declare-zsh \
    zdharma/zflai \
 blockf \
    zdharma/zui \
    zinit-zsh/zinit-console \
 trigger-load'!crasis' \
    zdharma/zplugin-crasis \
 atinit"forgit_ignore='fgi'" \
    wfxr/forgit

# powerlevel10k
#MYPROMPT=2

# Load within zshrc – for the instant prompt
#zinit ice depth=1; zinit light romkatv/powerlevel10k

### End of Zinit's installer chunk

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# For a full list of active aliases, run `alias`.
# Example aliases
# alias zshconfig="mate ~/.zshrc"

#[[ -s "/Users/Villager/.gvm/scripts/gvm" ]] && source "/Users/Villager/.gvm/scripts/gvm"
# gvm pkgset use global
# export GOPATH=$HOME/go
# export GOBIN=$HOME/go/bin
# export PATH=$PATH:$GOBIN

# add nvm path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# add rust path
# export PATH="$HOME/.cargo/bin:$PATH"
# export RUST_BACKTRACE=1

# add rust src path
# export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# add go path
# export PATH="$PATH:/usr/local/go/bin"

# add racer path
# export PATH="$HOME/.cargo/bin/racer:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
### End of Zinit's installer chunk

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/villager/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/villager/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/villager/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/villager/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Created by `userpath` on 2020-04-11 05:49:03
export PATH="$PATH:/home/villager/.local/bin"

autoload -U bashcompinit
bashcompinit

# rust cli
alias ls='exa'
alias x='exa'
alias find='fd'
alias grep='rg'
alias du='dust'
alias cat='bat'
alias time='hyperfine'
alias cloc='tokei'
alias ps='procs'
alias sed='sd'
alias top='btm'

# Add starship to the end of ~/.zshrc
eval "$(starship init zsh)"

