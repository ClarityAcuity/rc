"################### Magic vimrc #######################
" Home   SmartHome
" ctrl+n Enable/disable mouse
" ctrl+t Switch to text/binary
" ctrl+j To utf-8 file
" ctrl+s Convert tab to spaces
" ctrl+l Toggle line breaking
" ctrl+a Switch to full/simple

"#######################################################
" 去掉有關vi一致性模式, 避免以前版本一些bug和侷限
set nocompatible

"#######################################################
" vim-plug setup
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-fugitive'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Nerdtree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Initialize plugin system
call plug#end()

"#######################################################
" General settings
" encode
if has("multi_byte")
    set fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
else
    echoerr "If +multi_byte is not included, you should compile Vim with big features."
endif
 
set encoding=utf-8
set termencoding=utf-8
set fileformat=unix

syntax on                     "語法上色
set ai                        "自動縮排
set smartindent               "設定smartindent
set cindent                   "c style 縮排
set completeopt=longest,menu

set expandtab                 "用space代替tab
set shiftwidth=4              "自動縮排時空格數量
set softtabstop=4             "統一tab為4格 方便使用backspace
set tabstop=4                 "tab=4格space

set formatoptions+=r          "auto comment

set number                    "顯示行數
set ruler                     "顯示右下角詳細訊息

set ic                        "設定搜尋忽略大小寫
set hlsearch                  "搜尋字加highlight
set incsearch                 "未輸入完成即顯示搜尋結果
set confirm                   "操作有衝突 以明確文字詢問
set history=100               "保留1000個使用過指令
nohl                          "搜尋不會有底色
set nowrap                    "字串太長不自動換行

set showcmd                   "輸入命令顯示出來

" thx to Walker088
set showmode                  "showing the edit status

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with spacebar
nnoremap <space> za
:inoremap " ""<Esc>i
:inoremap ' ''<Esc>i
:inoremap [ []<Esc>i
:inoremap { {}<Esc>i

set wildmenu

" 解決backspace不能使用問題
set backspace=indent,eol,start
set backspace=2

" vim禁用自動備份
set nobackup
set nowritebackup
set noswapfile

" 顯示匹配的括號
set showmatch

" 文件縮排及tab個數
setl shiftwidth=4
setl tabstop=4

" 功能設定
set noeb                      "去掉輸入錯誤提示聲音
" set autowrite                "自動保存
set autoread                  "文件被改動時自動載入
set scrolloff=3               "捲動時保留3行
set mouse=a                   "啟用滑鼠

" 每次開啟 移動到上次離開位置
if has("autocmd")
     au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" 共享剪貼簿
set clipboard=unnamed

"#######################################################
" Color
set t_Co=256                  "set the terminal color to 256bit
colo desert                   "個人喜好顏色配置
set cursorline                "底線顯示目前游標行
set cursorcolumn              "顯示當前游標列
" 游標hilight
hi CursorLine cterm=none ctermbg=DarkGray  ctermfg=White
hi CursorColumn cterm=none ctermbg=DarkGray ctermfg=White
" Search hilight
hi Search cterm=reverse ctermbg=none ctermfg=none

"#######################################################
" Statusline
" 啟動顯示狀態行1 總是顯示狀態行2
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2             "1啟動開啟，2顯示狀態列
" Syntastic Settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_javascript_checkers = ['standard']
"let g:syntastic_javascript_standard_generic = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javiascript_eslint_exec = 'eslint'

"#######################################################
" Plugin settings
" Simpylfol
let g:SimpylFold_docstring_preview=1

" IndentLine
let g:indentLine_char = '¦'
let g:indentLine_enabled = 1

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
set completeopt=longest,menu
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_cache_omnifunc=0
let g:ycm_complete_in_strings=1
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" air-line
let g:airline_theme='simple'

" rust lang
" auto rustfmt
let g:rustfmt_autosave = 1
" :RustPlay copy the url to the clipboard
let g:rust_clip_command = 'xclip -selection clipboard'
" Naturally, this needs to be set to wherever your rust source tree resides.
let g:ycm_rust_src_path = $RUST_SRC_PATH
" rust racer setup
set hidden
let g:racer_cmd = "/home/user/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

" golang
au FileType go nmap gr (go-run)  
au FileType go nmap gt (go-test)  
let g:go_hightlight_functions = 1
let g:go_hightlight_methods = 1
let g:go_hightlight_structs = 1
let g:go_hightlight_interfaces = 1
let g:go_highlight_types = 1
let g:go_hightlight_operators = 1
let g:go_hightlight_build_constraints = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_fields = 1
let g:go_fmt_command = "goimports"

" nerdtree
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
let NERDTreeWinSize=25
map <C-n> :NERDTreeToggle<CR>

" python exec
autocmd BufRead *.py nmap<leader>c :w<Esc>G:r!python3.4 %<CR>
