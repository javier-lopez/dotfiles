"-------------------------------------------------------------------------------
"           Last review            Sat 15 Mar 2014 12:54:38 AM CST
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
    "set gfn=Monaco\ 9
    "set gfn=Monospace\ 9
    set gfn=Inconsolata\ Medium\ 10
    colorscheme hemisu
else
    set background=dark
    colorscheme hemisu
endif

set modelines=0        "http://www.guninski.com/vim1.html
set nocompatible       "breaks compatibility with vi, required
set noexrc             "don't use local version of .(g)vimrc, .exrc
set lazyredraw         "do not redraw the screen while macros are running. It
                       "improves performance
set ttyfast            "indicates a fast terminal connection
set history=100        "record last 100 commands, press 'q:' to see a new
                       "window (normal mode) with the full history
set t_Co=256           "set 256 colors. Make sure your console supports it.
                       "gnome-terminal and konsole work well
set report=0           "report any changes
set nowritebackup      "bye .swp madness
set nobackup           "turn backup off
set noswapfile
set tabpagemax=200     "max open tabs at the same time
set autowrite
set autoread           "watch for file changes by other programs
set encoding=utf-8     "utf is able to represent any character
set fileencoding=utf-8
set ruler              "show the cursor position all the time
set noerrorbells       "disable annoying beeps
"set visualbell        "this one too
set wildmenu           "enhance command completion
set wildignore=*/.svn/*,CVS,*/.git,*/.hg/*,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp
set hidden             "allow open other file without saving current file
set autochdir          "change to the current directory
set winminheight=1     "never let a window to be less than 1px height
set winminwidth=1
set scrolloff=3        "show enough context
set sidescrolloff=2
set hlsearch           "highlight search
set incsearch          "incremental search, search as you type
set showfulltag        "show as much as possible
set ignorecase         "ignore case when searching
set showcmd            "show the command you're typing
set softtabstop=4      "vim sees 4 spaces as a tab
set shiftwidth=4       "indentation
set expandtab          "tabs mutate into spaces, if you wanna insert "real"
                       "tabs use Ctrl-v <tab> instance
set splitright         "split vertically to the right.
set splitbelow         "split horizontally below.
"set cursorline         "highlight the screen line of the cursor, slow!
set nostartofline
set nofsync            "improves performance, let OS decide when to flush disk
set showmatch          "when closing a block, show matching bracket.
"set matchtime=5        "how many tenths of a second to blink
                       "matching brackets for"
set diffopt+=iwhite    "ignore whitespace in diff mode
set cscopetag          "use both cscope and ctag for 'ctrl-]'
set csto=0             "gives preference to cscope over ctag
"set cscopeverbose
set pastetoggle=<C-p>  "pastetoggle (sane indentation on pastes)
                       "press <Ctrl>-<p> when you are going to paste several
                       "lines of text so they don't "be indented.
"set mousehide         "hide the mouse while typying
"set mouse=nv          "set the mouse to work in console mode

set foldenable!         "disable folding by default
set foldmethod=syntax
"set foldmarker={,}

"set clipboard=unnamed
set clipboard=unnamedplus      "yanks go on clipboard instead, "+p to make recover the x11 clipboard
                               "use xsel hacks if your vim version has no "clipboad-x11 support

set backspace=indent,eol,start "make backspace works like in other editors.
set viminfo='100,<100,s10,h    "remember not as much as possible

"Print to html
let html_use_css       = 1
let html_dynamic_folds = 1

"<leader>
let mapleader          = ","

syntax on
filetype plugin indent on                 "enable filetype-specific plugins
setlocal omnifunc=syntaxcomplete#Complete "Omni-completion <C-x><C-o>

"===============================================================================
"================================ Autoloads by events ==========================
"===============================================================================

if has("autocmd")
    "Go back to the position the cursor was on the last time this file was edited
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \|execute("normal '\"")|endif

    autocmd VimEnter * nohls "turn off any existing search

    "browse documentation with <Enter>/<BS>
    "http://vim.wikia.com/wiki/Mapping_to_quickly_browse_help
    autocmd filetype help :nnoremap <buffer><CR> <c-]>
    autocmd filetype help :nnoremap <buffer><BS> <c-T>
endif

"====== Status Line ======
"Nice statusline taken mostly from
"http://github.com/ciaranm/dotfiles-ciaranm/raw/master/vimrc
set laststatus=2                                         "always show statusline
set statusline=
set statusline+=%2*%-2n                                  "buffer number
set statusline+=%h%1*%m%r%w%0*                           "flags
set statusline+=%*\ %-.50F\                              "file name (full)
"if filereadable(expand("~/.vim/bundle/vim-cutils/plugin/cutils.vim"))
    "set statusline+=%-7{cutils#VCSInfo()}                "branch info
"endif
set statusline+=\[%{strlen(&ft)?&ft:'none'},             "filetype
set statusline+=%{&encoding},                            "encoding
set statusline+=%{&fileformat}]                          "file format
if filereadable(expand("~/.vim/bundle/vimbuddy.vim/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}                      "vim buddy
endif
"set statusline+=\ %{synIDattr(synID(line('.'),col('.'),1),'name')}
set statusline+=%=                                       "right align
set statusline+=%2*%-8{strftime('%H:%M')}                "time
if filereadable(expand("~/.vim/bundle/vim-cutils/plugin/cutils.vim"))
    set statusline+=%-7{cutils#FileSize()}               "file size
endif
"set statusline+=%2*%-3b,0x%-8B\                          "current char
"set statusline+=0x%-4B\                                  "current char
"set statusline+=%-14.(%l,%c%V%)\ %<%P                    "offset
set statusline+=%-8.(%l,%c%V%)\ %P                       "offset

"===============================================================================
"================================== Mappings ===================================
"===============================================================================

"=== Ctrl Mappings===
"map work on --normal--, --visual-- and --operator-- modes look at :help map-modes

"move between split windows
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-l> <c-w>l
noremap <c-h> <c-w>h

inoremap <c-k> <Esc><c-w>k
inoremap <c-j> <Esc><c-w>j
inoremap <c-l> <Esc><c-w>l
inoremap <c-h> <Esc><c-w>h

"tabs manage
map <c-n> :tabn<CR>
map <c-p> :tabp<CR>

map <c-w> :tabclose <CR>

"source $VIMRUNTIME/ftplugin/man.vim
"nnoremap K :Man <C-R><C-W><CR>

"exit keyboard shortcut
map <c-x> :confirm qall<CR>

"=== Leader Mappings(,)==

"m'ak'e
map <silent> <leader>mk :make<CR>

map <silent> <leader>m :set number!<CR>

"reload ~/.vimrc
map <leader>r :source $MYVIMRC<CR>

"resize windows
noremap <silent><Leader>< :vertical resize -1<CR>
noremap <silent><Leader>> :vertical resize +1<CR>
noremap <silent><Leader>+ :resize +1<CR>
noremap <silent><Leader>- :resize -1<CR>

"clear highlighted searches
nmap <silent> <leader>/ :nohlsearch<CR>

"=== Tab Mappings ===
map <Tab>c :cc<CR>
map <Tab>n :cnext<CR>
map <Tab>p :cprevious<CR>

"=== Misc Mappings===
map ; :

"let's switch these
nnoremap ' `
nnoremap ` '

"I dont wanna go far away just to press <Esc>, take care when pasting stuff
inoremap jj <Esc>

"insert a space in normal mode
noremap <Space> i <Esc>

"use <BackSpace> for deleting visual selections
xnoremap <BS> d
snoremap <BS> <BS>i

"Most of the time, the only reason you want to move to the end
"of a word is to add text
map e ea
"make Y consistent with D and C
nnoremap Y y$

"automatically jumpt to end of text you pasted
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

"don't clobber registers when doing character deletes
"nnoremap x "_x
"nnoremap X "_X
"nnoremap s "_s

"quit and save faster
noremap zz :q!<CR>
noremap ss :w<CR>
noremap SS :%!sudo tee > /dev/null %<CR>

"also check this one, It's set by default
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

"this will work only on the gui version, most terminal are unable to
"determinate the difference between <home> and <m-home>

noremap <M-HOME> gg
noremap <M-END> G

"nnoremap <CR> G
"nnoremap <BS> gg

"move between buffers
map <Tab><Space> :bnext<CR>

"===============================================================================
"================================ Plugins config  ==============================
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
    Bundle 'scrooloose/nerdtree'     , { 'on': 'NERDTreeToggle' }
        let g:NERDTreeWinPos         = 'right'
        let g:NERDTreeWinSize        = 25
        let g:NERDTreeMouseMode      = 3
    Bundle 'msanders/snipmate.vim'   , { 'on': 'insert' }
        let g:snips_author           = "Javier Lopez"
        let g:snips_authorEmail      = "m@javier.io"
        let g:snippets_dir           = "~/.vim/extra-snippets/"
    Bundle 'majutsushi/tagbar'       , { 'on': 'TagbarToggle' }
        let g:tagbar_left            = 1
        let g:tagbar_width           = 25
    Bundle 'chilicuil/QuickBuf'      , { 'on': ['<Plug>QuickBuf'] }
        map <F2> <Plug>QuickBuf
        "let g:qb_hotkey = "<F2>"
    Bundle 'mhinz/vim-hugefile'
    Bundle 'henrik/vim-indexed-search'
    Bundle 'chilicuil/nextCS'        , { 'on': ['<Plug>NextCS', '<Plug>PreviousCS'] }
        map <F12> <Plug>NextCS
        map <F11> <Plug>PreviousCS
    Bundle 'chilicuil/vimbuddy.vim'
    "TODO 18-12-2014 03:30 >> add lazy loading
    Bundle 'scrooloose/nerdcommenter'
        let g:NERDCustomDelimiters   = {'mkd': { 'left': '<!--', 'right': '-->'}}
    Bundle 'chilicuil/TaskList.vim'  , { 'on': '<Plug>TaskList' }
        let g:Tlist_WinWidth         = 25
        let g:Tlist_Show_One_File    = 1
        let Tlist_Enable_Fold_Column = 0
        map <Leader>t <Plug>TaskList
    "Bundle 'vim-scripts/DrawIt'
        "map <leader>di :DIstart <CR>
        "map <leader>ds :DIstop <CR>
    Bundle 'chilicuil/securemodelines'
        "let g:secure_modelines_verbose=1
    Bundle 'kien/ctrlp.vim'            , { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU', 'CtrlPMixed'] }
        "let g:ctrlp_cache_dir          = $HOME.'/.cache/ctrlp'
        let g:ctrlp_use_caching         = 1
        let g:ctrlp_clear_cache_on_exit = 0
        let g:ctrlp_working_path        = 0
        let g:ctrlp_user_command        = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
        "let g:ctrlp_user_command       = 'find %s -type f'
        "let g:ctrlp_map                 = '<leader>f'
        map <leader>f                  :CtrlP<CR>
    Bundle 'Lokaltog/vim-easymotion'   , { 'on': ['<Plug>(easymotion-prefix)'] }
        "let g:EasyMotion_leader_key     = '<leader><leader>'
        map <leader><leader>            <Plug>(easymotion-prefix)
        let g:EasyMotion_keys           = 'asdfghjklqwertyuiopzxcvbnm'
    Bundle 'chilicuil/vim-markdown'
    Bundle 'chilicuil/vim-sprunge'      , { 'on': ['<Plug>Sprunge'] }
        map <leader>s                   <Plug>Sprunge
    Bundle 'Shougo/neocomplcache'       , { 'on': 'insert' }
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
    Bundle 'chilicuil/file-line'
    Bundle 'mhinz/vim-signify'
        let g:signify_vcs_list               = [ 'git' ]
        let g:signify_sign_add               = '+'
        let g:signify_sign_change            = '~'
        let g:signify_sign_delete            = '-'
        let g:signify_sign_delete_first_line = '‾'
    "TODO 18-12-2014 03:30 >> add lazy loading
    Bundle 'chilicuil/x-modes'
        let g:x_modes_map_default      = '<Leader>D'
        let g:x_modes_map_development  = '<Leader>d'
        let g:x_modes_map_write        = '<Leader>w'
        let g:x_modes_map_presentation = '<Leader>p'
        map <silent> <Leader>n           :call xmodes#FileManagerToggle()<CR>
        map <silent> <Leader>l           :call xmodes#FunctionBrowserToggle()<CR>
    Bundle 'chilicuil/vim-cutils'
        let g:cutils_map_longlines        = '<Leader>cul'
        let g:cutils_map_whitespacehunter = '<Leader>v'
        let g:cutils_map_appendmodeline   = '<Leader>ml'

    "===vim-scripts===, not hosted in github for some obscure reason
    Bundle 'surround.vim' , { 'on': 'insert' }
        " ds" / cs"' / ysiw'
    "TODO 18-12-2014 03:30 >> add lazy loading
    Bundle 'repeat.vim'
    "TODO 18-12-2014 03:30 >> separate functions on autoload
    Bundle 'gnupg.vim'
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
    "Bundle 'chilicuil/conque'
    "Bundle 'chilicuil/taglist.vim'         "tagbar looks better
    "Bundle 'FindMate'                      "ctrlp.vim ftw!
    "Bundle 'vim-scripts/AutoComplPop'      "good for some time but finally deprecated
        "let g:acp_behaviorKeywordLength    = 4
        "let g:acp_mappingDriven            = 1
        "let g:acp_completeOption           = '.,w,b,t,k,i,d'
        "let g:acp_completeoptPreview       = 1
        ""let g:acp_behaviorSnipmateLength   = 2
        "let g:acp_behaviorPythonOmniLength = -1
    "Bundle 'Lokaltog/vim-powerline'        "I prefer my own powerline =)
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
" "(" moves to beginning of current sentence
" ")" moves to beginning of next sentence
" "{" moves to beginning of current paragraph
" "}" moves to beginning of next paragraph
" "[[" moves to beginning of current section
" "]]" moves to beginning of next section
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
" ":w !sudo tee %" you can use sudo inside vim
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
