# Setup Doc
## vim setting

### Install vim and [vim-plug](https://github.com/junegunn/vim-plug)

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### `vi ~/.vimrc` config vim

Add a vim-plug section to your `~/.vimrc` (or `~/.config/nvim/init.vim` for Neovim):

1. Begin the section with `call plug#begin()`
1. List the plugins with `Plug` commands
1. `call plug#end()` to update `&runtimepath` and initialize plugin system
   - Automatically executes `filetype plugin indent on` and `syntax enable`.
     You can revert the settings after the call. e.g. `filetype indent off`, `syntax off`, etc.

### Reload .vimrc and `:PlugInstall` to install plugins.

### Compiling [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

1. Install cmake

```
sudo apt install build-essential cmake python3-dev
```

1. Compiling YCM

```
cd ~/.vim/plugged/YouCompleteMe
python3 install.py --clang-completer
```

---

## zsh setting

### Install zsh and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

`sudo apt install zsh`

### Set zsh to default shell

`chsh -s $(which zsh)`

### Powerline

```
sudo apt install powerline fonts-powerline
```

### Plugins

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```
plugins=(
  git
  sudo
  colored-man-pages
  zsh-syntax-highlighting
  zsh-autosuggestions
)
```
