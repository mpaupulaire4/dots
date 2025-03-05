# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

## Programs
zinit ice as"program" from"gh-r" \
  atclone"./fzf --zsh > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light junegunn/fzf

zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

zinit ice wait as"program" from"gh-r" lucid \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light ajeetdsouza/zoxide

zinit ice as"program" from"gh-r"
zinit light jesseduffield/lazygit

zinit ice as"program" from"gh-r" extract"!" pick"hx"
zinit light helix-editor/helix

zinit ice as"program" from"gh-r" extract"!"
zinit light ducaale/xh
alias http='xh'

zinit ice as"program" from"gh-r" extract"!" pick"sg"
zinit light ast-grep/ast-grep

zinit ice as"program" from"gh-r" extract"!"
zinit light yassinebridi/serpl

zinit ice as"program" from"gh-r" extract"!" \
  mv"dasel* -> dasel" \
  atclone"./dasel completion zsh > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light tomwright/dasel

zinit ice as"program" from"gh-r" pick"eza"
zinit light eza-community/eza

zinit ice as"program" from"gh-r" extract"!" pick"rg"
zinit light BurntSushi/ripgrep

zinit ice as"program" from"gh-r"
zinit light Wilfred/difftastic

zinit ice as"program" from"gh-r" extract"!"
zinit light dandavison/delta

zinit ice as"program" from"gh-r" extract"!"
zinit light mattn/efm-langserver

zinit ice as"program" from"gh-r" extract"!" \
  atclone"./k6 completion zsh > init.zsh" \
  atpull"%atclone" src"init.zsh"
zinit light grafana/k6

zinit ice pick"nvm.sh"
zinit light nvm-sh/nvm


# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::eza
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

zinit cdreplay -q

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Alias
alias cd='z'

# load zellij last
zinit ice wait as"program" from"gh-r" lucid \
  atclone"./zellij setup --generate-auto-start zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" 
zinit light zellij-org/zellij

bindkey '^[[1;5D'  backward-word
bindkey '^[[1;5C'  forward-word
bindkey '^[[H'     beginning-of-line
bindkey '^[[F'     end-of-line



function dprune () {
  green="`tput setaf 2`"
  normal="`tput sgr0`"

  echo -e 'Stopping containers... \c'
  docker stop `docker ps -aq` &> /dev/null || true
  echo "${green}done${normal}"

  echo -e 'Pruning containers... \c'
  docker rm `docker ps -aq` &> /dev/null || true
  echo "${green}done${normal}"

  echo -e 'Pruning volumes... \c'
  docker volume rm `docker volume ls` &> /dev/null || true
  echo "${green}done${normal}"

  echo -e 'Pruning dangling images... \c'
  docker rmi `docker images -f 'dangling=true' -q` &> /dev/null || true
  echo "${green}done${normal}"
}
