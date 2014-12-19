"-------------------------------------------------------------------------------
"           Last review            Fri 19 Dec 2014 12:31:54 AM CST
"-------------------------------------------------------------------------------

"===============================================================================
"============================== General settings ===============================
"===============================================================================

if v:version < 700
    echoerr "This vimrc file use features than are only available on vim 7.0 or greater"
    finish
endif

if has ('gui_running')
    set background=dark
    set gfn=Inconsolata\ Medium\ 10
    "set gfn=Monaco\ 9
    "set gfn=Monospace\ 9
    colorscheme hemisu
else
    set background=dark
    colorscheme hemisu
endif

set nocompatible       "breaks compatibility with vi, required
set modelines=0        "http://www.guninski.com/vim1.html
set noexrc             "don't use local version of .(g)vimrc, .exrc
set lazyredraw         "do not redraw the screen while macros are running. It
                       "improves performance
set ttyfast            "indicates a fast terminal connection
set history=100        "record last 100 commands, press 'q:' to see a new
                       "window (normal mode) with the full history
set t_Co=256           "set 256 colors. Make sure your console supports it.
                       "gnome-terminal, konsole and urxvt work well
set report=0           "report any changes
set nobackup           "git btw!
set nowritebackup      "bye .swp madness
set noswapfile
set tabpagemax=200     "max open tabs at the same time
set autowrite
set autoread           "watch file changes by other programs
set encoding=utf-8     "utf is able to represent any character
set fileencoding=utf-8
set ruler              "show the cursor position all the time
set noerrorbells       "disable annoying beeps
"set visualbell        "this one too
set wildmenu           "enhance command completion
set wildignore=*/.svn/*,CVS,*/.git,*/.hg/*,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp
set hidden            "allow open other file without saving current file
set autochdir         "change to the current directory
set winminheight=1    "never let a window to be less than 1px height
set winminwidth=1
set scrolloff=3       "show enough context
set sidescrolloff=2
set hlsearch          "highlight search
set incsearch         "search as you type
set ignorecase        "ignore case when searching
set showcmd           "show the command being typed
set softtabstop=4     "vim sees 4 spaces as a tab
set shiftwidth=4
set showfulltag       "when autocompleting show as much as possible
set expandtab         "tabs mutate into spaces, if you wanna insert "real"
                      "tabs use Ctrl-v <tab> instance
set splitright        "split vertically to the right.
set splitbelow        "split horizontally below.
"set cursorline        "highlight the screen line of the cursor, slow!
set nostartofline     "keep the cursor on the same column
set nofsync           "improves performance, let OS decide when to flush disk
set showmatch         "when closing a block, show matching bracket.
"set matchtime=5       "how many tenths of a second to blink
set diffopt+=iwhite   "ignore whitespace in diff mode
set cscopetag         "use both cscope and ctag for 'ctrl-]'
set csto=0            "gives preference to cscope over ctag
set pastetoggle=<C-p> "pastetoggle, sane indentation on pastes
"set mousehide        "hide the mouse while typying
"set mouse=nv         "set the mouse to work in console mode
set foldenable!       "disable folding by default
set foldmethod=syntax
"set foldmarker={,}
"set clipboard=unnamed
set clipboard=unnamedplus      "yanks go to clipboard, "+p to recover
set viminfo='100,<100,s10,h    "remember just a little
set backspace=indent,eol,start "backspace deletes as in other editors

"Print to html
let html_use_css       = 1
let html_dynamic_folds = 1

syntax on
filetype plugin indent on                 "enable filetype-specific plugins
setlocal omnifunc=syntaxcomplete#Complete "Omni-completion <C-x><C-o>

"===============================================================================
"==================================== Autoloads ================================
"===============================================================================

if has("autocmd")
    "Go back to the position the cursor was on the last time this file was edited
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \|execute("normal '\"")|endif
    autocmd VimEnter * nohls "turn off any existing search
    "browse documentation with <Enter>/<BS>
    autocmd filetype help :nnoremap <buffer><CR> <c-]>
    autocmd filetype help :nnoremap <buffer><BS> <c-T>
endif

"====== Status Line ======
"mostly taken from http://github.com/ciaranm/dotfiles-ciaranm/raw/master/vimrc
set laststatus=2                             "always show statusline
set statusline=                              "init definition
set statusline+=%2*%-2n                      "buffer number
set statusline+=%h%1*%m%r%w%0*               "flags
set statusline+=%*\ %-.50F\                  "file name (full)
"if filereadable(expand("~/.vim/bundle/vim-cutils/plugin/cutils.vim"))
    "set statusline+=%-7{cutils#VCSInfo()}   "branch info
"endif
set statusline+=\[%{strlen(&ft)?&ft:'none'}, "filetype
set statusline+=%{&encoding},                "encoding
set statusline+=%{&fileformat}]              "file format
if filereadable(expand("~/.vim/bundle/vimbuddy.vim/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}          "cui o@o!
endif
"set statusline+=\ %{synIDattr(synID(line('.'),col('.'),1),'name')}
set statusline+=%=                           "right align
set statusline+=%2*%-8{strftime('%H:%M')}    "time
if filereadable(expand("~/.vim/bundle/vim-cutils/plugin/cutils.vim"))
    set statusline+=%-7{cutils#FileSize()}   "file size
endif
"set statusline+=%2*%-3b,0x%-8B\             "current char
"set statusline+=0x%-4B\                     "current char
"set statusline+=%-14.(%l,%c%V%)\ %<%P       "offset
set statusline+=%-8.(%l,%c%V%)\ %P           "offset

"===============================================================================
"================================== Mappings ===================================
"===============================================================================

"=== Ctrl Mappings===
"windows
noremap  <c-k> <c-w>k
noremap  <c-j> <c-w>j
noremap  <c-l> <c-w>l
noremap  <c-h> <c-w>h
inoremap <c-k> <Esc><c-w>k
inoremap <c-j> <Esc><c-w>j
inoremap <c-l> <Esc><c-w>l
inoremap <c-h> <Esc><c-w>h

"tabs
map <c-n> :tabn<CR>
map <c-p> :tabp<CR>
map <c-w> :tabclose <CR>

"exit
map <c-x> :confirm qall<CR>

"=== Leader Mappings(,)==
let mapleader = ","

"m'ake
map <silent> <leader>m :make<CR>

"toggle numbering
map <silent> <leader>1 :set number!<CR>

"reload ~/.vimrc
map <leader>r :source $MYVIMRC<CR>

"resize windows
noremap <silent><Leader>< :vertical resize -1<CR>
noremap <silent><Leader>> :vertical resize +1<CR>
noremap <silent><Leader>+ :resize +1<CR>
noremap <silent><Leader>- :resize -1<CR>

"clear highlighted searches
nmap <silent> <leader>/   :nohlsearch<CR>

"=== Tab Mappings ===
map <Tab>c :cc<CR>
map <Tab>n :cnext<CR>
map <Tab>p :cprevious<CR>
"move between buffers
map <Tab><Space> :bnext<CR>

"=== Misc Mappings===
"let's switch these
map      ; :
nnoremap ' `
nnoremap ` '

"<Esc> isn't really confortable, be carefull when pasting stuff
inoremap jj <Esc>

"insert spaces in normal mode
noremap <Space> i <Esc>

"use <BackSpace> for deleting visual selections
xnoremap <BS> d
snoremap <BS> <BS>i

"edit at the end of the word
map e ea

"make Y consistent with D and C
nnoremap Y y$

"automatically jump to end of text you pasted
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

"quit and save faster
noremap zz :q!<CR>
noremap ss :w<CR>
noremap SS :%!sudo tee > /dev/null %<CR>
"ZZ :wq!

"overwrite these annoying commands
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
"cabbr W w
cabbr Q q
cabbr Q q
cabbr wQ wq
cabbr WQ wq
cabbr Wq wq
noremap <HOME> ^
noremap <END> $

"this will work only in the gui version, most terminals are unable
"to determinate differences between <home> and <m-home>
noremap <M-HOME> gg
noremap <M-END> G

"===============================================================================
"=================================== Plugins ===================================
"===============================================================================

if !isdirectory(expand("~/.vim/bundle/vundle/.git/"))
    echon "Setting up vundle, this may take a while, wanna continue? (y/n): "
    if nr2char(getchar()) ==? 'y'
        "shadow cloning was never accepted
        "!git clone --depth=1 https://github.com/chilicuil/vundle-legacy.git ~/.vim/bundle/vundle
        !git clone --depth=1 https://github.com/chilicuil/vundle.git ~/.vim/bundle/vundle
    endif
endif

if isdirectory(expand("~/.vim/bundle/vundle/"))
    set runtimepath+=~/.vim/bundle/vundle/
    call vundle#rc()

    "====github====
    Bundle 'chilicuil/vundle'
    "TODO 18-12-2014 03:30 >> add lazy loading
    Bundle 'edsono/vim-matchit'
    Bundle 'scrooloose/nerdtree'   , { 'on': 'NERDTreeToggle' }
        let g:NERDTreeWinPos       = 'right'
        let g:NERDTreeWinSize      = 25
        let g:NERDTreeMouseMode    = 3
        map <silent> <leader>n     :NERDTreeToggle<CR>
    Bundle 'msanders/snipmate.vim' , { 'on': 'insert' }
        let g:snips_author         = "Javier Lopez"
        let g:snips_authorEmail    = "m@javier.io"
        let g:snippets_dir         = "~/.vim/extra-snippets/"
    Bundle 'majutsushi/tagbar'     , { 'on': 'TagbarToggle' }
        let g:tagbar_left          = 1
        let g:tagbar_width         = 25
        map <silent> <leader>l     :TagbarToggle<CR>
    Bundle 'mhinz/vim-hugefile'
    Bundle 'henrik/vim-indexed-search'
    Bundle 'tomtom/tcomment_vim'   , { 'on': '<Plug>TComment_<c-_><c-_>' }
        map <leader>c<space>       <Plug>TComment_<c-_><c-_>
        map <leader>cs             <Plug>TComment_<c-_><c-_>
    Bundle 'kien/ctrlp.vim'             , { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU', 'CtrlPMixed'] }
        "let g:ctrlp_cache_dir          = $HOME.'/.cache/ctrlp'
        let g:ctrlp_use_caching         = 1
        let g:ctrlp_clear_cache_on_exit = 0
        let g:ctrlp_working_path        = 0
        let g:ctrlp_user_command        = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
        "let g:ctrlp_user_command       = 'find %s -type f'
        let g:ctrlp_map                 = '<leader>f'
        map <leader>f                  :CtrlP<CR>
    Bundle 'Lokaltog/vim-easymotion'   , { 'on': ['<Plug>(easymotion-prefix)'] }
        "let g:EasyMotion_leader_key     = '<leader><leader>'
        map <leader><leader>            <Plug>(easymotion-prefix)
        let g:EasyMotion_keys           = 'asdfghjklqwertyuiopzxcvbnm'
    Bundle 'Shougo/neocomplcache'                          , { 'on': 'insert' }
        let g:neocomplcache_enable_at_startup              = 1
        let g:neocomplcache_max_list                       = 10
        let g:neocomplcache_max_menu_width                 = 10
        let g:neocomplcache_auto_completion_start_length   = 4
        let g:neocomplcache_manual_completion_start_length = 4
        let g:neocomplcache_enable_auto_select             = 1
        let g:neocomplcache_enable_auto_delimiter          = 1
        let g:neocomplcache_disable_auto_complete          = 0
        let g:neocomplcache_enable_wildcard                = 1
        let g:neocomplcache_enable_caching_message         = 1
    Bundle 'mhinz/vim-signify'
        let g:signify_vcs_list        = [ 'git' ]
        let g:signify_sign_add        = '+'
        let g:signify_sign_change     = '~'
        let g:signify_sign_delete     = '-'
    Bundle 'chilicuil/QuickBuf'      , { 'on': ['<Plug>QuickBuf'] }
        map <F2> <Plug>QuickBuf
        "let g:qb_hotkey = "<F2>"
    Bundle 'chilicuil/nextCS'        , { 'on': ['<Plug>NextCS', '<Plug>PreviousCS'] }
        map <F12> <Plug>NextCS
        map <F11> <Plug>PreviousCS
    Bundle 'chilicuil/vimbuddy.vim'
    Bundle 'chilicuil/TaskList.vim'  , { 'on': '<Plug>TaskList' }
        let g:Tlist_WinWidth         = 25
        let g:Tlist_Show_One_File    = 1
        let Tlist_Enable_Fold_Column = 0
        map <Leader>t <Plug>TaskList
    Bundle 'chilicuil/securemodelines'
        "let g:secure_modelines_verbose=1
    Bundle 'chilicuil/gnupg.vim'
    Bundle 'chilicuil/vim-markdown'
    Bundle 'chilicuil/vim-sprunge'   , { 'on': ['<Plug>Sprunge'] }
        map <leader>s                <Plug>Sprunge
    Bundle 'chilicuil/file-line'
    Bundle 'chilicuil/x-modes' , { 'on': ['<Plug>XDefaultMode', '<Plug>XDevelopmentMode', '<Plug>XWriteMode', '<Plug>XPresentationMode'] }
        map <silent> <leader>D <Plug>XDefaultMode
        map <silent> <leader>d <Plug>XDevelopmentMode
        map <silent> <leader>w <Plug>XWriteMode
        map <silent> <leader>p <Plug>XPresentationMode
    Bundle 'chilicuil/vim-cutils'
        let g:cutils_map_longlines        = '<Leader>cul'
        let g:cutils_map_whitespacehunter = '<Leader>v'
        let g:cutils_map_appendmodeline   = '<Leader>ml'

    "===vim-scripts===, not hosted in github for some obscure reason
    Bundle 'surround.vim' , { 'on': 'insert' }
        " ds" / cs"' / ysiw'
    "TODO 18-12-2014 03:30 >> add lazy loading
    Bundle 'repeat.vim'
    "Bundle 'hexHighlight.vim'

    "===experimental===
    Bundle 'junegunn/vim-easy-align' , { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
        command! -nargs=* -range -bang Align
        \ <line1>,<line2>call easy_align#align('<bang>' == '!', 0, '', <q-args>)
        vmap . <Plug>(EasyAlignRepeat)
        nmap <Leader>a <Plug>(EasyAlign)
    Bundle 'ntpeters/vim-better-whitespace'
    Bundle 'chilicuil/goyo.vim' , { 'on': '<Plug>Goyo' }
        map <leader>y <Plug>Goyo
        "let g:goyo_width         = 160
        "let g:goyo_margin_top    = 5
        "let g:goyo_margin_bottom = 5
        "function! g:goyo_before()
            "colorscheme jellybeans
        "endfunction

        "function! g:goyo_after()
            "colorscheme hemisu
        "endfunction
        "let g:goyo_callbacks = [function('g:goyo_before'), function('g:goyo_after')]

    command! -nargs=+ Grep execute 'silent grep -rni --exclude-dir={.git,.svn,.bzr,.hg,.pc,CVS} --binary-files=without-match . -e <args>' | copen | execute 'silent /<args>'
    " shift-control-* Greps for the word under the cursor
    nmap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>

    "===discarted===
    "Bundle 'chilicuil/taglist.vim'         "tagbar looks better
    "Bundle 'FindMate'                      "ctrlp.vim ftw!
    "Bundle 'vim-scripts/AutoComplPop'      "neocomplcache is better
        "let g:acp_behaviorKeywordLength    = 4
        "let g:acp_mappingDriven            = 1
        "let g:acp_completeOption           = '.,w,b,t,k,i,d'
        "let g:acp_completeoptPreview       = 1
        ""let g:acp_behaviorSnipmateLength   = 2
        "let g:acp_behaviorPythonOmniLength = -1
    "Bundle 'Lokaltog/vim-powerline'        "still prefer my own powerline =)
        "let g:Powerline_cache_enabled = 1
        "let g:Powerline_symbols = 'compatible' "compatible, unicode, fancy
        "let g:Powerline_theme = 'default' "default, skwp
        "let g:Powerline_stl_path_style = 'short' "relative, filename, short, full
        "call Pl#Theme#InsertSegment('charcode', 'after', 'filetype')
        "call Pl#Theme#ReplaceSegment('scrollpercent', 'fileinfo')
    "Bundle 'tpope/vim-fugitive'            "too slow
    "Bundle 'godlygeek/csapprox'            "pretty but slow
    "Bundle 'mattn/webapi-vim'              "sprunge ftw!
    "Bundle 'mattn/gist-vim'                "sprunge ftw!
    "Bundle 'goldfeld/vim-seek'             "easymotion.vim ftw!
    "Bundle 'akiomik/git-gutter-vim'        "doesn't work
    "Bundle 'airblade/vim-gitgutter'        "doesn't work
    "Bundle 'luxflux/vim-git-inline-diff'   "too slow
    "Bundle 'terryma/vim-multiple-cursors'  "nice idea but too slow
    "Bundle 'scrooloose/nerdcommenter'      "wasn't able to configure it with lazy loading
        "let g:NERDCustomDelimiters      = {'mkd': { 'left': '<!--', 'right': '-->'}}
endif

"===============================================================================
"==================================Extra-notes==================================
"===============================================================================

" ==Movement==
" "Ctrl-f" scrolls forward one screen
" "Ctrl-b" scrolls backward one screen
" "Ctrl-d" scrolls backward half screen
" "Ctrl-u" scrolls backward half screen
" "z-<CR>" moves current line to top of screen and scroll
" "z-." moves current line to center of screen and scroll
" "z--" moves current line to bottom of screen and scroll
" "H" moves to the top line on the screen
" "M" moves to the middle line on the screen
" "L" moves to the last line on the screen
" "(" moves to the beginning of the current sentence
" ")" moves to the beginning of the next sentence
" "{" moves to the beginning of the current paragraph
" "}" moves to the beginning of the next paragraph
" "[[" moves to the beginning of the current section
" "]]" moves to the beginning of the next section
" "w" moves the cursor forward one word
" "b" moves backward to the start of the previous word.
" "e" moves to the next end of a word
" "ge" moves to the previous end of a word.
" "gg" puts the cursor in the first line.
" "G" puts the cursor in the last line
" "'0" returns to the last mark
" "Ctrl-w f" goes to the file under the cursor
" "Ctrl-]" jumps to the function's definition :tags
" "Ctrl-T" jumps back

" ==Text objects==
" "daw" deletes word under cursor, see :h text-objects, (c)hange & (y)ank
" "caw" changes word under cursor  ======================================
" "yaw" copies word under cursor   ======================================
" "das" deletes sentence
" "dap" deletes paragraph
" "da{" deletes {} block
" "di{" deletes text inside {}
" "da[" deletes [] block
" "di[" deletes text inside []
" "da<" deletes <> block
" "di<" deletes text inside <>
" "da"" deletes "" block
" "di"" deletes text inside ""
" "dat" deletes tag block (html, xml)
" "dit" deletes text inside tag words
" ":%d" deletes all the lines in a file

" ==Search & reemplace==
" ":%s/\s\+$//" removes all whitespaces at the end of every line
" ":%s/old/new/gc" it'll confirm each replacement before it's made
" ":g/old/s//new/gc" same to the above sentence
" ":g/\(old\) \(stuff\)/s//\2 \1/gc" changes "old stuff" to "stuff old"
" ":%s/\(old\) \(stuff\)/\2 \1/gc" same to the above sentence
" ":1,10s/.*/(&)/" surrounds each line from 1 to 10 with parenthesis
" "%s/yes, doctor/\uyes, \udoctor/gc" changes 'yes doctor' to 'Yes, Doctor'
" ":%s/\([:.]\)  */\1  /g" replaces one or more spaces following a period
"                          or a colon with two spaces
" ":g/^[ tab]*$/d" deletes all blank lines, plus any lines that contain
"                  only whitespace
" ":%s/.*/\U&/"
" ":%s/./\U&/g" changes every letter in a file to uppercase
" ":windo %s/old/new/g" replaces 'old' with 'new' in all windows
" ":bufdo set nonumber" set nonumber option in all buffers
" ":g/^/move 0" reverses the order of lines in a file
" ":g!/^[[:digit:]]/move $" for any line that doesn't begin with a number,
"                           moves the line to the end of the file
" "&" repeats the last substitution
" ":%&g" repeats the last substitution globally
" "/\<thi" matches all the words who start with "thi" like 'things'
" "/ing\>" matches all the words who end with "ing", like 'using'
" ":vimgrep /\%1l/ **/filename" find all files given a name at any depth
"                               in the current directory or below
" ":copen" open the list generated by vimgrep
" "f<character>" searches for the character
" ";" goes to the next match
" "," goes to the previous match
" "F<character>" searches to the left.
" "d/key-word" deletes from the cursor to the key-word, it also
"              works with ?
" "[I" finds global identifiers in included files

" ==Edit==
" "J" joins two lines together
" "." repeats the last change on --insert-- mode
" "~" changes case of the character under the cursor
" "gqG" gives format to the whole file
" "]s" moves to next misspelled word after the cursor
" ":e!" goes to the latest saved file version
" "g Ctrl-g" counts the words in the whole file
" "+p    " paste text from system clipboard
" "+yy   " copy from vim to the system clipboard
" "+dd   " cut from vim to the sysyem clipboard

" ==Misc stuff==
" "K" goes to the man page of the word under the cursor
" "Ctrl-w r" rotates windows
" "Ctrl-w x" rotates windows and cursor focus at the same time
" "Ctrl-w T" moves the current window to a new tab
" "Ctrl-w H | J | K | L" moves the current window to the left,
"                        bottom, top and right of the screen
" "vim + file" opens file at last line
" "find . | vim -" you can take the output of any command and
"                  send it into a vim session
" ":sball" opens all buffers in new windows
" ":ped file" open in a help window a second file
" ":help 42"
" ":help quotes"
" ":help holy-grail"
" "zo" Open a folder
" "zO" Open a folder recursively
" "zc" Close a folder
" "zC" Close a folder recursively
" ":map" List maps
" ":registers" Show what is in each register
" "set all" show all the options
" "q/" gives the search history window
" "q:" gives the comand history window
" ":%! nl -ba" numbers all lines in a file
" ":%! cat -n %" same as above
" Vim can be suspended like any other program with Ctrl-z and
" be restarted with --fg--
