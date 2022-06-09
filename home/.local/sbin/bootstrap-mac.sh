#!/bin/bash

set -xeuo pipefail

################################################################################
# Language/package manager/runtime install

# Install homebrew
if ! command -v brew 2>&- 1>&-; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! [[ -d ~/.asdf ]]; then
  git clone https://github.com/asdf-vm/asdf ~/.asdf
  export PATH=$PATH:$HOME/.asdf/bin

  asdf plugin add ruby
  asdf plugin add python
  asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git

  asdf install ruby 2.7.2
  asdf global ruby 2.7.2
  asdf install python 3.9.2
  asdf global python 3.9.2
  asdf install kubectl 1.22.10
  asdf global kubectl 1.22.10
fi

# shellcheck disable=SC1090
source "$HOME/.asdf/asdf.sh"

if ! command -v rustup 2>&- 1>&-; then
  brew install rustup
  rustup-init -qy
  export "PATH=$PATH:~/.cargo/bin"
fi

if ! command -v go 2>&- 1>&-; then
  brew install go
fi

################################################################################
# Development tools

gem install homesick

brew install zsh tmux neovim htop watch direnv jq pv gnu-sed taskwarrior-tui svn

zsh -c "autoload -Uz compaudit && compaudit | xargs chmod g-w,o-w"

# Also consider
# brew install pre-commit
# brew install k9s

cargo install bat
cargo install fd-find
cargo install git-delta
cargo install lsd
cargo install rargs
cargo install ripgrep
cargo install tealdeer
cargo install tokei
cargo install emojify
cargo install watchexec
cargo install procs
cargo install bottom

if ! [[ -f $HOME/.cargo/bin/sccache ]]; then
  cargo install sccache
fi

tldr --update

brew install homebrew/cask-fonts/font-roboto-mono-nerd-font
brew install fontconfig
fc-cache -frv
brew install --cask --no-quarantine alacritty

if ! [[ -d ~/.zinit ]]; then
  # zinit
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

nvim +:PlugInstall +:qall

################################################################################
# Auth

test -d ~/.ssh || install -m 0700 -d ~/.ssh
if ! [[ -f ~/.ssh/id_ed25519 ]]; then
  ssh-keygen -f ~/.ssh/id_ed25519 -t ed25519 -a 100 -C "$USER@$(hostname)" -N ""
fi
