# Setup Doc

## vim setting

### Install vim and [vim-plug](https://github.com/junegunn/vim-plug)

```shell
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### `vi ~/.vimrc` config vim

Add a vim-plug section to your `~/.vimrc` (or `~/.config/nvim/init.vim` for Neovim):

- Begin the section with `call plug#begin()`
- List the plugins with `Plug` command
- `call plug#end()` to update `&runtimepath` and initialize plugin system
  - Automatically executes `filetype plugin indent on` and `syntax enable`.
    You can revert the settings after the call. e.g. `filetype indent off`, `syntax off`, etc.

### Reload .vimrc and `:PlugInstall` to install plugins.

### Compiling [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

- Install cmake

```shell
sudo apt install build-essential cmake python3-dev
```

- Compiling YCM

```shell
cd ~/.vim/plugged/YouCompleteMe
python3 install.py --clang-completer
```

### [Tagbar](https://github.com/majutsushi/tagbar)

- package needed

```shell
sudo apt-get install dh-autoreconf pkg-config
```

- clone and build [universal-ctags](https://github.com/universal-ctags/ctags)

see [autotools.rst](https://github.com/universal-ctags/ctags/blob/master/docs/autotools.rst)

---

## zsh setting

### Install zsh and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

```shell
sudo apt install zsh
```

### Set zsh to default shell

```shell
chsh -s $(which zsh)
```

### Powerline

```shell
sudo apt install powerline fonts-powerline
```

### Plugins

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```zshrc
plugins=(
  git
  sudo
  colored-man-pages
  zsh-syntax-highlighting
  zsh-autosuggestions
)
```

---

## system cmd tools

- htop/atop/[glances](https://github.com/nicolargo/glances)/[mnom](http://nmon.sourceforge.net/pmwiki.php)

- [neofetch](https://github.com/dylanaraps/neofetch)


## graphics

- mesa

```shell
sudo add-apt-repository ppa:ubuntu-x-swat/updates
sudo apt-get dist-upgrade
glxinfo | grep "OpenGL version"
sudo apt-get install ppa-purge && sudo ppa-purge ppa:ubuntu-x-swat/updates
```

- vulkan (if needed)

```shell
sudo apt install mesa-vulkan-drivers vulkan-utils
```