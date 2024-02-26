export XDG_DATA_HOME="/home/devops/.local/share"
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
    alias clr='clear'
    alias pjd='sshpass -p "ftedev!@#" ssh -J ftedev@149.129.219.106 -o StrictHostKeyChecking=no'
    alias pjp='sshpass -p "ftedev!@#" ssh -J ftedev@149.129.224.212 -o StrictHostKeyChecking=no'
    alias cp-dev='scp -J ftedev@149.129.219.106'
    alias jks-dev='sshpass -p "ftedev!@#" ssh -J ftedev@149.129.219.106 ftedev@172.31.123.0'
    alias sch-dev='sshpass -p "ftedev!@#" ssh -J ftedev@149.129.219.106 ftedev@192.168.101.10'
    alias cp-prod='scp -J ftedev@149.129.224.212'
    alias runner-jks='sshpass -p "RCTIplus2019" ssh -J ftedev@149.129.219.106 root@172.31.112.141'
    alias jsd='function jsd() { sshpass -p "ftedev!@#" ssh "$1@149.129.219.106"; }; jsd'
    alias jsp='function jsp() { sshpass -p "ftedev!@#" ssh "$1@149.129.224.212"; }; jsp'
    alias sch-prod='sshpass -p "ftedev!@#" ssh -J ftedev@149.129.219.106 ftedev@172.31.4.35'
    alias jsp-hwc='function jsd-hwc() { sshpass -p "ftedev!@#" ssh -p 2222 "$1@110.239.67.83"; }; jsd-hwc'
fi

export PATH=/usr/bin:/usr/local/bin:${HOME}/.krew/bin
export JDTLS_JVM_ARGS="-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar"
export VAULT_ADDR='https://vault.mncplus.com'
export VAULT_TOKEN=hvs.3YUJG4KwLh9WSPEnlhqF8vmC
export KUBE_EDITOR=/usr/bin/nvim

# ssh -fN -L 8001:192.168.101.218:6443 ftedev@149.129.219.106
# ssh -fN -L 8002:192.168.12.60:6443  ftedev@149.129.219.106
# ssh -fN -L 8003:172.31.54.20:6443  ftedev@149.129.219.106
# ssh -fN -L 8004:172.31.142.210:6443 ftedev@149.129.224.212
ssh -p 2222 -fN -L  8009:172.17.9.1:5443 dev-newrplus@110.239.67.83


function roov() {
    case $1 in
        fe)
            ssh -i /home/devops/repository/rtx/rtxprod.pem rtxprod@149.129.243.137
            ;;
        be)
            ssh -i /home/devops/repository/rtx/rtxprod.pem rtxprod@149.129.239.154
            ;;
        rc)
            ssh -i /home/devops/repository/rtx/rtx-rc.pem rtx-rc@149.129.245.249
            ;;
        *)
            echo "Pilihan server tidak valid. Gunakan fe, be, atau rc."
            ;;
    esac
}



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
autoload -U compinit && compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
