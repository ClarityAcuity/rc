{
  config,
  pkgs,
  lib,
  ...
}:
let
  # yazi
  plugins-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "06e5fe1c7a2a4009c483b28b298700590e7b6784";
    hash = "sha256-jg8+GDsHOSIh8QPYxCvMde1c1D9M78El0PljSerkLQc=";
  };

in
#   sources = import ./nix/sources.nix;
#   overlays = let path = ./nix/overlays; in
#     with builtins;
#     map (n: import (path + ("/" + n)))
#       (filter
#         (n: match ".*\\.nix" n != null ||
#           pathExists (path + ("/" + n + "/default.nix")))
#         (attrNames (readDir path)));
#   pkgs = import sources.nixpkgs {
#     # Get all files in overlays
#     overlays = [
#       (_self: super: { inherit sources; })
#     ] ++ overlays;
#   };
#   link = config.lib.file.mkOutOfStoreSymlink;

{
  imports = [ ./darwin-application-activation.nix ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # # Adds the 'hello' command to your environment. It prints a friendly
  # # "Hello, world!" when run.
  # pkgs.hello
  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')

  home = {
    username = "villager";
    homeDirectory = /Users/villager;
    stateVersion = "24.05"; # Please read the comment before changing.
    packages = with pkgs; [
      bat
      bats
      colima
      docker
      exercism
      eza
      fd
      ffmpeg
      # git
      gitFull
      git-hub
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      htop
      kubectl
      nil
      nix-prefetch-github # prefetch sources from github for nix build tool
      nixfmt # To install nixfmt in Home Manager
      nerd-fonts.meslo-lg # nerd-fonts
      p7zip
      uv
      python3
      ripgrep
      rsync
      ta-lib
      volta
      # rust
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
    ];
  };

  nixpkgs.config = {
    allowUnsupportedSystem = true;
  };

  # TODO: check the following apps (might need nix-darwin)
  # duf
  # fortune
  # gnused
  # imagemagick
  # jq
  # loc
  # mtr
  # ncdu
  # netcat
  # niv
  # nmap
  # paperkey
  # python3Packages.tvnamer
  # readline
  # shellcheck
  # shfmt
  # tree
  # unar
  # xz
  # zstd

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
  };

  home.backupFileExtension = "backup";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".gitconfig".source = ./gitconfig;
    ".gitaliases".source = ./gitaliases;
    # the bellow 3 line are pretty much the same to put wezterm.lua to nix wezterm config
    # "./config/wezterm/wezterm.lua".source = ./dotfiles/wezterm/wezterm.lua;
    # xdg.configFile."wezterm/wezterm.lua".source = ./dotfiles/wezterm/wezterm.lua;
    # programs.wezterm.extraConfig
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/villager/etc/profile.d/hm-session-vars.sh
  #

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.volta/bin"
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
    UV_PYTHON_PREFERENCE = "only-system";
    VOLTA_HOME = "$HOME/.volta";
    VOLTA_FEATURE_PNPM = "1";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    # aliases are defined in ~/.gitaliases
    #   aliases = {
    #     ap = "add -p";
    #   };
    settings = {
      user = {
        email = "zonapha770709@hotmail.com";
        name = "ClarityAcuity";
      };
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        ui = "auto";
      };
      credential.helper = "osxkeychain";
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      repack.usedeltabaseoffset = "true";
      diff = {
        renames = "copies";
        mnemonicprefix = "true";
        algorithm = "histogram";
      };
      branch.autosetupmerge = "true";
      push.default = "current";
      merge.stat = "true";
      pull.ff = "only";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        autoupdate = true;
        enabled = true;
      };
      # Sort tags as version numbers whenever applicable, so 1.10.2 is AFTER 1.2.0.
      tag.sort = "version:refname";
    };
    # Replaces ~/.gitignore
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "*.elc"
      "auto-save-list"
      ".direnv/"
      # exclude nix-build result
      "result"
      "result-*"
    ];
    # see home.file.".gitaliases".source below
    includes = [ { path = "~/.gitaliases"; } ];
  };

  # enable Bash And Zsh shell history suggest box
  programs.hstr.enable = true;

  # Kubernetes CLI To Manage Your Clusters In Style
  programs.k9s = {
    enable = true;
    package = pkgs.k9s;
    aliases = {
      aliases = {
        # Use pp as an alias for Pod
        pp = "v1/pods";
      };
    };
    hotKeys = {
      # Make sure this is camel case
      hotKey = {
        shift-0 = {
          shortCut = "Shift-0";
          description = "Viewing pods";
          command = "pods";
        };
      };
    };
    plugins = {
      # Defines a plugin to provide a `ctrl-l` shortcut to
      # tail the logs while in pod view.
      fred = {
        shortCut = "Ctrl-L";
        description = "Pod logs";
        scopes = [ "po" ];
        command = "kubectl";
        background = false;
        args = [
          "logs"
          "-f"
          "$NAME"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CLUSTER"
        ];
      };
    };

    settings = {
      k9s = {
        refreshRate = 2;
      };
    };
    skins = {
      my_blue_skin = {
        k9s = {
          body = {
            fgColor = "dodgerblue";
          };
        };
      };
    };
    views = {
      "v1/pods" = {
        columns = [
          "AGE"
          "NAMESPACE"
          "NAME"
          "IP"
          "NODE"
          "STATUS"
          "READY"
        ];
      };
    };
  };

  # programs.openclaw = {
  #   enable = true;
  #   config = {
  #     gateway = {
  #       mode = "local";
  #       auth = {
  #         token = "<gatewayToken>"; # or set OPENCLAW_GATEWAY_TOKEN
  #       };
  #     };

  #     # channels.telegram = {
  #     #   tokenFile = "/run/agenix/telegram-bot-token"; # any file path works
  #     #   allowFrom = [ 12345678 ]; # your Telegram user ID
  #     # };
  #   };

  #   bundledPlugins = {
  #     summarize.enable = true; # Summarize web pages, PDFs, videos
  #     peekaboo.enable = true; # Take screenshots
  #     poltergeist.enable = false; # Control your macOS UI
  #     sag.enable = false; # Text-to-speech
  #     camsnap.enable = false; # Camera snapshots
  #     gogcli.enable = false; # Google Calendar
  #     goplaces = {
  #       # Google Places API
  #       enable = true;
  #       config.env.GOOGLE_PLACES_API_KEY = "/run/agenix/google-places-api-key";
  #     };
  #     bird.enable = false; # Twitter/X
  #     sonoscli.enable = false; # Sonos control
  #     imsg.enable = false; # iMessage
  #   };

  #   # Built-ins (tools + skills) shipped via nix-steipete-tools.
  #   plugins = [ { source = "github:openclaw/nix-steipete-tools?dir=tools/summarize"; } ];

  #   instances.default = {
  #     enable = true;
  #     package = pkgs.openclaw; # batteries-included
  #     stateDir = "~/.openclaw";
  #     workspaceDir = "~/.openclaw/workspace";
  #     launchd.enable = true;

  #     # Plugins (prod: pinned GitHub). Built-ins are via nix-steipete-tools.
  #     # MVP target: repo pointers resolve to tools + skills automatically.
  #     plugins = [
  #       { source = "github:openclaw/nix-steipete-tools?dir=tools/peekaboo"; }
  #       { source = "github:joshp123/xuezh"; }
  #     ];
  #   };
  # };

  # Starship cli
  programs.starship = {
    enable = true;
    settings = { };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = false;
    # plugins = with pkgs.vimPlugins; [
    # vim-easy-align
    # vim-fugitive
    # YouCompleteMe
    # syntastic
    # tagbar
    # webapi-vim
    # vim-github-dashboard
    # fzf-vim
    # vim-airline
    # vim-airline-themes

    # ultisnips
    # vim-snippets
    # nerdtree
    # ];
    extraConfig = ''
      " 編碼與換行格式
      set fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
      set fileformat=unix

      " 縮排與排版
      set expandtab                 " 用 space 代替 tab
      set shiftwidth=4              " 縮排寬度
      set softtabstop=4             " 編輯時 tab 等同 4 格
      set tabstop=4                 " tab 寬度為 4 格
      set cindent                   " C-style 縮排
      set formatoptions+=r          " 換行自動補註解

      " 行號與顯示
      set number                    " 顯示行數
      set relativenumber            " 顯示相對行數
      set nowrap                    " 不自動折行
      set scrolloff=3               " 捲動時邊界保留 3 行
      set showmatch                 " 顯示對應括號

      " 搜尋與互動
      set ignorecase                " 搜尋忽略大小寫
      set smartcase                 " 若包含大寫字母則轉為精準匹配
      set history=1000              " 保留指令歷史紀錄
      set confirm                   " 衝突時以對話詢問
      nohlsearch                    " 啟動時不殘留搜尋高亮

      " 摺疊
      set foldmethod=indent
      set foldlevel=99

      " 備份與剪貼簿
      set nobackup
      set nowritebackup
      set noswapfile
      set mouse=a
      set clipboard=unnamed         " 共享系統剪貼簿 (macOS)
      set noerrorbells              " 關閉錯誤嗶聲

      " 每次開啟移動到上次離開位置
      if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
      endif
    '';
  };

  # Yazi - ⚡️ Blazing Fast Terminal File Manager
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
      chmod = "${plugins-repo}/chmod.yazi";
      full-border = "${plugins-repo}/full-border.yazi";
      max-preview = "${plugins-repo}/max-preview.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "0a141f6dd80a4f9f53af8d52a5802c69f5b4b618";
        sha256 = "sha256-OL4kSDa1BuPPg9N8QuMtl+MV/S24qk5R1PbO0jgq2rA=";
      };
    };

    # initLua = ''
    #   			require("full-border"):setup()
    #   			require("starship"):setup()
    #   		'';

    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "T" ];
          run = "plugin --sync max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = builtins.readFile dotfiles/wezterm/wezterm.lua;
    # extraConfig = ''
    # -- Pull in the wezterm API
    # local wezterm = require 'wezterm'

    # -- This will hold the configuration.
    # local config = wezterm.config_builder()

    # -- This is where you actually apply your config choices

    # -- For example, changing the color scheme:
    # config.color_scheme = 'AdventureTime'

    # -- and finally, return the configuration to wezterm
    # return config
    # '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # This way, my functions could be stored under
    # .config/zsh/lib
    dotDir = "${config.home.homeDirectory}/.config/zsh";
    autosuggestion = {
      enable = true;
    };
    history = {
      size = 50000;
      save = 500000;
      path = "$HOME/.zsh_history";
      extended = true;
      ignoreDups = true;
      share = true;
    };

    sessionVariables = rec {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";

      NVIM_TUI_ENABLE_TRUE_COLOR = "1";

      BROWSER = if pkgs.stdenv.hostPlatform.isDarwin then "open" else "xdg-open";

      EDITOR = "vim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;

      # GOPATH = "$HOME/go";
      # PATH = "$HOME/bin:$GOPATH/bin:$PATH";
      # TERM = "xterm-256color";

      # LESS = "-F -g -i -M -R -S -w -X -z-4";

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "underline";
    };

    localVariables = {
      # This way, C-w deletes words (path elements)
      WORDCHARS = "*?_-.[]~&;
        !#$%^(){}<>";

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=8";
    };
    shellAliases = {
      # l = "eza --color auto";
      # ls = "eza -G --color auto -a -s type";
      # ll = "eza -l --color always -a -s type";
      "]" = "open";
      dl = "\curl -O -L";
      up = "\cd ..";
      p = "pushd";
      pd = "perldoc";
      mkdir = "nocorrect mkdir";
      # cat = "bat";
      # x = "unar";
      zb = "z -b";
      zh = "z -I -t .";
      # fd's default of not searching hidden files is annoying
      f = "fd -H --no-ignore";

      # commonly used git aliases (lifted from prezto)
      g = "git";
      ga = "git add";
      gai = "git add -i";
      gap = "git add --patch";
      gau = "git add --update";
      gb = "git branch";
      gbx = "git branch -d";
      gbX = "git branch -D";
      gba = "git branch -a";
      gbm = "git branch -m";
      gc = "git commit --verbose";
      gcm = "git commit --message";
      gcf = "git commit --amend --reuse-message HEAD";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      gm = "git merge";
      gma = "git merge --abort";
      gcpa = "git cherry-pick --abort";
      gp = "git push -u";
      gpf = "git push -u --force-with-lease";
      gpa = "git push --all && git push --tags";
      gr = "git rebase";
      gri = "git rebase --interactive";
      gra = "git rebase --abort";
      grc = "git rebase --continue";
      grs = "git rebase --skip";
      gst = "git status";
      gt = "git tag";
      gup = ''git fetch -p && git rebase --autostash "''${$(git symbolic-ref refs/remotes/origin/HEAD)#refs/remotes/}"'';
      gfa = "git fetch --all -v";
      stash = "git stash";
      unstash = "git stash pop";
      staged = "git diff --no-ext-diff --cached";
    };
    initContent = lib.mkBefore ''
      DIRSTACKSIZE=10

      setopt   notify globdots correct cdablevars autolist
      setopt   correctall autocd recexact longlistjobs
      setopt   autoresume
      setopt   rcquotes mailwarning
      unsetopt bgnice
      setopt   autopushd pushdminus pushdsilent pushdtohome pushdignoredups

      setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
      setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
      setopt AUTO_MENU           # Show completion menu on a successive tab press.
      setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
      setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
      unsetopt AUTO_PARAM_SLASH    # If completed parameter is a directory, do not add a trailing slash.
      unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
      unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.
    '';

    initExtra = ''
      # Nix setup (environment variables, etc.)
        if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
          . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      # Completion settings
      source ${config.xdg.configHome}/zsh/completion.zsh

      fpath=(${config.xdg.configHome}/zsh/functions(-/FN) $fpath)
      # functions must be autoloaded, do it in a function to isolate
      function {
        local pfunction_glob='^([_.]*|prompt_*_setup|README*|*~)(-.N:t)'

        local pfunction
        # Extended globbing is needed for listing autoloadable function directories.
        setopt LOCAL_OPTIONS EXTENDED_GLOB

        for pfunction in ${config.xdg.configHome}/zsh/functions/$~pfunction_glob; do
          autoload -Uz "$pfunction"
        done
      }

      alias ls='echo; ${pkgs.eza}/bin/eza'
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      ${builtins.readFile dotfiles/dot-zshrc}

      # volta
      VOLTA_FEATURE_PNPM=1
      unset _VOLTA_TOOL_RECURSION
    '';

    plugins = [
      {
        name = "zsh-history-substring-search";
        file = "zsh-history-substring-search.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "v1.1.0";
          sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
        };
      }
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
          sha256 = "sha256-B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
          sha256 = "sha256-4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
        };
      }
      {
        name = "zsh-completions";
        file = "zsh-completions.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "978e79e12c44b5b1d3e1e2920c537002087b82c2";
          sha256 = "sha256-J2L/jO8lWNGC4Bob+2mH7OEJ+U2g+NVkbPA1OdnIrp0=";
        };
      }
      {
        name = "zsh-you-should-use";
        file = "zsh-you-should-use.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "fc0be82b42b1cb205e67dbb4520cb77e248f710d";
          sha256 = "sha256-W8lo8UkkT5K5C1NLkLoe8QHuplaGUQc97pkIIJUWq4I=";
        };
      }
    ];
  };

  # xdg.configFile."zsh/functions".source = ./zsh/functions;
  # xdg.configFile."zsh/completion.zsh".source = ./zsh/completion.zsh;

  # Karabiner's config file
  # xdg.configFile."karabiner/karabiner.json".source = ./configs/karabiner/karabiner.json;
  # iTerm2 settings
  # Use link here, so when something changes, it gets propagated back
  # xdg.configFile."iterm2/com.googlecode.iterm2.plist".source = link ./preferences/com.googlecode.iterm2.plist;

  targets.darwin.defaults = {
    "com.apple.desktopservices" = {
      # Avoid creating .DS_Store files on network volumes (default: false).
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.dock" = {
      # hide and put it on right
      autohide = true;
      orientation = "right";
      # Don’t automatically rearrange Spaces based on most recent use
      "mru-spaces" = 0;
      # Don’t show Dashboard as a Space
      "dashboard-in-overlay" = true;
      # Make it small
      tilesize = 42;

      autohide-time-modifier = 0.5;
      autohide-delay = 0;
      springboard-columns = 7;
      springboard-rows = 5;
    };
    "Apple Global Domain" = {
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs) (default: not set).
      AppleKeyboardUIMode = 3;
      # Always show scrollbars (default: WhenScrolling).
      AppleShowScrollBars = "Always";
      # Show all filename extensions in Finder (default: false).
      AppleShowAllExtensions = true;
      # Expand save panel (default: false).
      NSNavPanelExpandedStateForSaveMode = true;
      # Display ASCII control characters using caret notation in standard text views
      # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
      NSTextShowsControlCharacters = true;
      # Disable smart quotes as they’re annoying when typing code
      NSAutomaticQuoteSubstitutionEnabled = false;
      # Disable smart dashes as they’re annoying when typing code
      NSAutomaticDashSubstitutionEnabled = false;
      # Disable automatic capitalization as it’s annoying when typing code
      NSAutomaticCapitalizationEnabled = false;
      # Disable automatic period substitution as it’s annoying when typing code
      NSAutomaticPeriodSubstitutionEnabled = false;
      # Disable auto-correct
      NSAutomaticSpellingCorrectionEnabled = false;
      # Enable “natural” (Lion-style) scrolling
      "com.apple.swipescrolldirection" = true;
      # Trackpad: enable tap to click for this user
      "com.apple.mouse.tapBehavior" = 1;
      # Trackpad: map tap with two fingers to secondary click
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
      "com.apple.trackpad.enableSecondaryClick" = true;
      # Set language and text formats
      AppleLanguages = [ "en" ];
      AppleLocale = "en_US";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = true;
    };
    "com.apple.finder" = {
      # Display full POSIX path as Finder window title (default: false).
      _FXShowPosixPathInTitle = true;
      # Disable the warning when changing a file extension (default: true).
      FXEnableExtensionChangeWarning = false;
      # Show hidden files by default
      AppleShowAllFiles = true;
      # Show status bar
      ShowStatusBar = true;
      # Show path bar
      ShowPathbar = true;
      # Allow text selection in Quick Look
      QLEnableTextSelection = true;
    };
    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
      # Trackpad: enable tap to click for this user
      Clicking = true;
      # Trackpad: map tap with two fingers to secondary click
      TrackpadCornerSecondaryClick = 1;
      TrackpadRightClick = true;
    };
    # Bash: defaults read com.apple.HIToolbox AppleEnabledInputSources
    "com.apple.HIToolbox" = {
      AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.ABC";
      AppleEnabledInputSources = [
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 252;
          "KeyboardLayout Name" = "ABC";
        }
        {
          "Bundle ID" = "com.apple.inputmethod.EmojiFunctionRowItem";
          InputSourceKind = "Non Keyboard Input Method";
        }
        {
          "Bundle ID" = "com.apple.PressAndHold";
          InputSourceKind = "Non Keyboard Input Method";
        }

        {
          "Bundle ID" = "com.apple.inputmethod.TCIM";
          InputSourceKind = "Input Mode";
          "Input Mode" = "com.apple.inputmethod.TCIM.Zhuyin";
        }
        {
          "Bundle ID" = "com.apple.inputmethod.TCIM";
          InputSourceKind = "Keyboard Input Method";
        }

        {
          "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
          "Input Mode" = "com.apple.inputmethod.Japanese";
          InputSourceKind = "Input Mode";
        }
        {
          "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
          InputSourceKind = "Keyboard Input Method";
        }
        {
          "Bundle ID" = "com.apple.50onPaletteIM";
          InputSourceKind = "Non Keyboard Input Method";
        }
      ];
      AppleSelectedInputSources = [
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 252;
          "KeyboardLayout Name" = "ABC";
        }
        {
          "Bundle ID" = "com.apple.inputmethod.EmojiFunctionRowItem";
          InputSourceKind = "Non Keyboard Input Method";
        }
        {
          "Bundle ID" = "com.apple.PressAndHold";
          InputSourceKind = "Non Keyboard Input Method";
        }
      ];
    };
  };
}
