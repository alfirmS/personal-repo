ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias la='eza -a'
    alias ls='eza --group-directories-first --color=always --icons --git'
    alias ll='eza -l'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias kf='kubectl-remote_forward'
    alias vi='nvim'
    alias k='kubectl'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias v='vim'
    alias bat='/usr/local/bat/bat'
    alias anc='anchor'
    alias terra='terraform'
    alias npp='/mnt/d/npp/Notepad++/notepad++.exe'
    alias sail='/home/devops/laravel/example-app/vendor/bin/sail'
    alias u='git commit -m "update setup pipeline"'
    alias ngl='npm-groovy-lint'
    alias kc='kubie ctx'
    alias kn='kubie ns'
fi

export PATH=$PATH:${HOME}/.krew/bin
export JDTLS_JVM_ARGS="-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar"
export VAULT_ADDR='http://34.101.248.109:8200'
export VAULT_DEV_ROOT_TOKEN_ID=hvs.YzhRPmKE4MeADEyHW3NtdBtn
export KUBE_EDITOR=/usr/bin/nvim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
autoload -U compinit && compinit
