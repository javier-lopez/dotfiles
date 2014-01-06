"-------------------------------------------------------------------------------
"           Last review            Sat 04 Jan 2014 02:03:58 AM CST
"-------------------------------------------------------------------------------
"
"===============================================================================
"============================== General settings ===============================
"===============================================================================

"TODO 04-01-2014 03:02 >> create plugins for as many functions as possible

if v:version < 700
    echoerr "This vimrc file use features than are only available on vim 7.0 or greater"
    finish
endif

if has ('gui_running')
    set background=dark
    "set gfn=Monaco
    "set gfn=Inconsolata\ Medium\ 10
    colorscheme ir_black
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
set showmatch          "when closing a block, show the matching bracket.
"set matchtime=5        "how many tenths of a second to blink
                       "matching brackets for"
set diffopt+=iwhite    "ignore whitespace in diff mode
set cscopetag          "use both cscope and ctag for 'ctrl-]'
set csto=0             "gives preference to cscope over ctag
"set cscopeverbose
set pastetoggle=<F5>   "pastetoggle (sane indentation on pastes)
                       "just press F5 when you are going to paste several lines
                       "of text so they don't "be indented.
"set mousehide         "hide the mouse while typying
"set mouse=nv          "set the mouse to work in console mode
"set clipboard=unnamed
set clipboard=unnamedplus      "yanks go on clipboard instead, "+p to make recover the x11 clipboard
                               "use xsel hacks if your vim version has no "clipboad-x11 support

set backspace=indent,eol,start "make backspace works like in other editors.
set viminfo='100,<100,s10,h    "remember not as much as possible

"Folding
set foldenable!                "off by default
set foldmethod=syntax
"set foldmarker={,}

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

    "turn off any existing search
    autocmd VimEnter * nohls

    "quickly browse: http://vim.wikia.com/wiki/Mapping_to_quickly_browse_help
    autocmd filetype help :nnoremap <buffer><CR> <c-]>
    autocmd filetype help :nnoremap <buffer><BS> <c-T>

    "behaviour per lang:
    autocmd BufNewFile,BufEnter *.php,*.php3,*.php4  call SetProperties("php")
    autocmd BufNewFile,BufEnter *.php5,*.inc,*schema call SetProperties("php")
    autocmd BufNewFile,BufEnter *.engine,*.ctp       call SetProperties("php")
    autocmd BufNewFile,BufEnter *.html,*.xml         call SetProperties("html")
    autocmd BufNewFile,BufEnter *.c,*.h              call SetProperties("c")
    autocmd BufNewFile,BufEnter *.pl,*.pm,*.t,*ptml  call SetProperties("perl")
    autocmd BufNewFile,BufEnter *[mM]akefile,*.mk    call SetProperties("make")
    autocmd BufNewFile,BufEnter *.java               call SetProperties("java")
    autocmd BufNewFile,BufEnter *.sh,*.bash          call SetProperties("bash")
    autocmd BufNewFile,BufEnter *.{md,mdown,mkd}     call SetProperties("markdown")
    autocmd BufNewFile,BufEnter *.{mkdn,markdown}    call SetProperties("markdown")
    autocmd BufNewFile,BufEnter *.{mdwn,todo,notes}  call SetProperties("markdown")

    "skeletons:
    autocmd BufNewFile *.rb,*.ruby,*.eruby           call Skel("ruby")
    autocmd BufNewFile *.sh,*.bash                   call Skel("sh")
    autocmd BufNewFile *.tex                         call Skel("tex")
    autocmd BufNewFile *.py,*.python                 call Skel("python")
    autocmd BufNewFile *.html                        call Skel("html")
    autocmd BufNewFile *.pl,*.perl                   call Skel("perl")
    autocmd BufNewFile *.php,*.php3,*.php4,*.php5    call Skel("php")
    autocmd BufNewFile *schema,*.inc,*.engine,*.ctp  call Skel("php")
    autocmd BufNewFile *.c                           call Skel("c")
endif

"====== Status Line ======
"Nice statusline taken mostly from
"http://github.com/ciaranm/dotfiles-ciaranm/raw/master/vimrc
set laststatus=2                                         "always show statusline
set statusline=
set statusline+=%2*%-2n                                  "buffer number
set statusline+=%*\ %-.50F\                              "file name (full)
"set statusline+=%{VCSInfo()}                             "branch info
set statusline+=%h%1*%m%r%w%0*                           "flags
set statusline+=\[%{strlen(&ft)?&ft:'none'},             "filetype
set statusline+=%{&encoding},                            "encoding
set statusline+=%{&fileformat}]                          "file format
if filereadable(expand("~/.vim/bundle/vimbuddy.vim/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}                      "vim buddy
endif
"set statusline+=\ %{synIDattr(synID(line('.'),col('.'),1),'name')}
set statusline+=%=                                       "right align
set statusline+=%2*%-8{strftime('%H:%M')}                "time
set statusline+=%-7{FileSize()}                          "file size
"set statusline+=%2*%-3b,0x%-8B\                          "current char
"set statusline+=0x%-4B\                                  "current char
"set statusline+=%-14.(%l,%c%V%)\ %<%P                    "offset
set statusline+=%-8.(%l,%c%V%)\ %P                       "offset

"===============================================================================
"================================ Plugins config  ==============================
"===============================================================================

if !isdirectory(expand(expand("~/.vim/bundle/vundle/.git/")))
    echon "Setting up vundle, this may take a while, wanna continue? (y/n): "
    if nr2char(getchar()) ==? 'y'
        "!git clone --dept=1 https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        "while upstream vundle doesn't merge shadow cloning, use own vundle version
        !git clone --dept=1 https://github.com/chilicuil/vundle.git ~/.vim/bundle/vundle
    endif
endif

if isdirectory(expand(expand("~/.vim/bundle/vundle/")))
    set runtimepath+=~/.vim/bundle/vundle/
    call vundle#rc()

    "====github====
    Bundle 'chilicuil/vundle'
    Bundle 'edsono/vim-matchit'
    "Bundle 'vim-scripts/CRefVim'
        "map <Leader>crn <Plug>CRV_CRefVimNormal
        "map <Leader>caw <Plug>CRV_CRefVimAsk
        "map <Leader>cvi <Plug>CRV_CRefVimInvoke
    Bundle 'scrooloose/nerdtree'
        let g:NERDTreeWinPos         = 'right'
        let g:NERDTreeWinSize        = 25
        let g:NERDTreeMouseMode      = 3
    Bundle 'msanders/snipmate.vim'
        let g:snips_author           = "Javier Lopez"
        let g:snips_authorEmail      = "m@javier.io"
        let g:snippets_dir           = "~/.vim/extra-snippets/"
    Bundle 'majutsushi/tagbar'
        let g:tagbar_left            = 1
        let g:tagbar_width           = 25
    Bundle 'vim-scripts/LargeFile'
    "Bundle 'vim-scripts/matrix.vim--Yang'
        "map <leader>x :Matrix<CR>
    Bundle 'chilicuil/nextCS'
    "Bundle 'chilicuil/TeTrIs.vim'
        "nmap <Leader>te :cal <SID>Main()<CR>
    Bundle 'chilicuil/vimbuddy.vim'
    Bundle 'scrooloose/nerdcommenter'
        let g:NERDCustomDelimiters   = {'mkd': { 'left': '<!--', 'right': '-->'}}
    Bundle 'vim-scripts/TaskList.vim'
        let g:Tlist_WinWidth         = 25
        let g:Tlist_Show_One_File    = 1
        let Tlist_Enable_Fold_Column = 0
        "TODO 07-09-2011 11:30 => make it toggle (open/close)
        map <Leader>t <Plug>TaskList
    "Bundle 'vim-scripts/DrawIt'
        "map <leader>di :DIstart <CR>
        "map <leader>ds :DIstop <CR>
    Bundle 'chilicuil/securemodelines'
        "let g:secure_modelines_verbose=1
    "Bundle 'scrooloose/syntastic'
        "set statusline+=\ %#warningmsg#
        "set statusline+=%{SyntasticStatuslineFlag()}
        "use this option to tell syntastic to automatically open a list when a buffer
        "has errors (:Errors)
        "let g:syntastic_auto_loc_list=1
        "use this option to tell syntastic to use the |:sign| interface to mark errors
        "let g:syntastic_enable_signs=1
        "use this option if you only care about syntax errors, not warnings
        "let g:syntastic_quiet_warnings=1
        "use this option to disable syntax checking on selected filetypes
        "let g:syntastic_disabled_filetypes = ['ruby', 'php']
        "TODO 07-09-2011 11:32 => make it toogle (open/close), check nerdtree out
        "let g:syntastic_ignore_files=['learn/sh']
        "let g:syntastic_ignore_files=['chilicuil.github.com']
        "map <silent><leader>e :Errors<CR>
    Bundle 'kien/ctrlp.vim'
        let g:ctrlp_map                                    = '<leader>f'
        let g:ctrlp_use_caching                            = 1
        let g:ctrlp_clear_cache_on_exit                    = 0
        "let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
        "let g:ctrlp_user_command = 'find %s -type f'
    Bundle 'Lokaltog/vim-easymotion'
        let g:EasyMotion_leader_key                        = '<leader><leader>'
    Bundle 'chilicuil/vim-markdown'
    Bundle 'chilicuil/vim-sprunge'
    Bundle 'Shougo/neocomplcache'
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
    "Bundle 'mattn/zencoding-vim'
        "let g:user_zen_leader_key = '<c-y>'
        "let g:use_zen_complete_tag = 1
    Bundle 'bogado/file-line'

    "===vim-scripts===, not hosted in github for some obscure reason
    Bundle 'QuickBuf'
        let g:qb_hotkey = "<F2>"
    Bundle 'surround.vim'
        " ds" / cs"' / ysiw'
    Bundle 'repeat.vim'
    Bundle 'IndexedSearch'
    Bundle 'gnupg.vim'

    "===experimental===
    Bundle 'mhinz/vim-signify'
        let g:signify_vcs_list               = [ 'git' ]
        let g:signify_sign_add               = '+'
        let g:signify_sign_change            = '~'
        let g:signify_sign_delete            = '-'
        let g:signify_sign_delete_first_line = '‾'
        hi SignifyLineAdd guifg=#7c7c7c guibg=#000000 gui=NONE
        hi SignifyLineChange guifg=#7c7c7c guibg=#000000 gui=NONE
        hi SignifyLineDelete guifg=#7c7c7c guibg=#000000 gui=NONE
        hi SignifySignAdd guifg=#65b042 ctermfg=78
        hi SignifySignChange guifg=#3387cc ctermfg=105
        hi SignifySignDelete guifg=#ff0000 ctermfg=202
    Bundle '2072/PHP-Indenting-for-VIm'
    Bundle 'junegunn/vim-easy-align'
        command! -nargs=* -range -bang Align
        \ <line1>,<line2>call easy_align#align('<bang>' == '!', 0, '', <q-args>)
        vmap . <Plug>(EasyAlignRepeat)
        nmap <Leader>a <Plug>(EasyAlign)
    "Bundle 'xolox/vim-easytags'
        "let g:easytags_file                    = '~/.ctags/tags'
        "let g:easytags_always_enabled         = 1
        "let g:easytags_on_cursorhold          = 0 "disable the automatic refresh
        "let g:easytags_autorecurse            = 1 "take care with this option!!!
        "let g:easytags_include_members        = 1 "struct/classes for c++, java, etc
        "let g:easytags_suppress_ctags_warning = 1
        "set tags=./.tags;,~/ctags/tags

    "===discarted===
    "Bundle 'chilicuil/taglist.vim'         "tagbar looks better
    "Bundle 'FindMate'                      "ctrlp.vim ftw!
    "Bundle 'tomtom/viki_vim'               "what's this anyway?
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
    "Bundle 'jistr/vim-nerdtree-tabs'       "nerdtree is faster without it
    "Bundle 'dahu/Insertlessly'             "what's this anyway?
    "Bundle 'Townk/vim-autoclose'           "what's this anyway?
    "Bundle 'tpope/vim-fugitive'            "too slow
    "Bundle 'godlygeek/csapprox'            "pretty but too slow
    "Bundle 'mattn/webapi-vim'              "sprunge ftw!
    "Bundle 'mattn/gist-vim'                "sprunge ftw!
    "Bundle 'gmarik/github-search.vim'      "what's this anyway?
    "Bundle 'goldfeld/vim-seek'             "easymotion.vim ftw!
    "Bundle 'gregsexton/gitv'               "what's this anyway?
    "Bundle 'akiomik/git-gutter-vim'        "doesn't work
    "Bundle 'luxflux/vim-git-inline-diff'   "too slow
    "Bundle 'airblade/vim-gitgutter'        "doesn't work
    "Bundle 'terryma/vim-multiple-cursors'  "nice idea but too slow
endif

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

" VIM-Shell
" Ctrl_W e opens up a vimshell in a horizontally split window
" Ctrl_W E opens up a vimshell in a vertically split window
"nmap <C-W>e :new \| vimshell bash<CR>
"nmap <C-W>E :vnew \| vimshell bash<CR>

"tabs manage
map <c-n> :tabn <CR>
map <c-p> :tabp <CR>
"Ctrl+Pageup & Ctrl+Pagedown should do the same

map <c-w> :tabclose <CR>

"for some unknown reason if I set this. it executes :confirm qall when
" I write '*/' on --insert-- mode where '*' is a wildcard
"map! <c-x> <esc>:confirm qall<CR>

"source $VIMRUNTIME/ftplugin/man.vim
"nnoremap K :Man <C-R><C-W><CR>

"exit keyboard shortcut
map <c-x> :confirm qall<CR>

"=== Leader Mappings(,)==

"m'ak'e
map <silent> <leader>mk :make<CR>

"trailer map
map <silent> <leader>v :call Trailer()<CR>

"keyboard shortcuts to close/open the two main plugins
map <silent> <leader>n :call Nerd_tree()<CR>
map <silent> <leader>l :call Tag_list()<CR>

map <silent> <leader>m :set number!<CR>

map <silent> <leader>w :WordMode<CR>
map <silent> <leader>d :DevMode<CR>
map <silent> <leader>p :PresentationMode<CR>
map <silent> <leader>f :DefaultMode<CR>

"update ~/.vimrc
map <leader>s :source $MYVIMRC<CR>

"resize windows
noremap <silent><Leader>< :vertical resize -1<CR>
noremap <silent><Leader>> :vertical resize +1<CR>
noremap <silent><Leader>+ :resize +1<CR>
noremap <silent><Leader>- :resize -1<CR>

"clear highlighted searches
nmap <silent> <leader>/ :nohlsearch<CR>

"Select everything
"noremap <Leader>gg ggVG

nnoremap <silent><Leader>ml :call AppendModeline()<CR>

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

"move between buffers
map <Tab><Space> :bnext<CR>

"Basically you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

"===============================================================================
"================================ Custom functions =============================
"===============================================================================

"TODO 18-12-2013 00:17 >> create plugin
command! DevMode            call Dev_mode()
command! WordMode           call Word_mode()
command! DevMode            call Dev_mode()
command! PresentationMode   call Presentation_mode()
command! DefaultMode        call Default_mode()
command! -nargs=? LongLines call LongLines('<args>')

"got-ravings.blogspot.mx/2009/07/vim-pr0n-combating-long-lines.html
function! LongLines(width)
    let targetWidth = a:width != '' ? a:width : 80
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: LongLines [natural number]"
    endif
endfunction

function! Nerd_tree() "need it to force close it, when changing between my
                      "custom modes (dev, spell, def)
    if exists ("s:nerd_tree")
        "NERDTreeTabsClose
        NERDTreeClose
        wincmd p      "forces to return the focus to the window who call it
        unlet s:nerd_tree
    else
        "NERDTreeTabsToggle
        NERDTreeToggle
        wincmd p      "forces to return the focus to the window who call it
        let s:nerd_tree = 1
    endif
endfunction

function! Tag_list()
    if exists ("s:tag_list")
        TagbarClose
        unlet s:tag_list
    else
        TagbarToggle
        let s:tag_list = 1
    endif
endfunction

"TODO 17-11-2009 13:11 => Add support to other VCS, current: git, svn
function! VCSInfo()
    let g:vcs_cache = {}
    let l:path = getcwd()
    if ! has_key(g:vcs_cache, l:path)
        if (isdirectory(l:path . "/.git"))
            let g:vcs_cache[l:path] = "["
                        \. substitute(readfile(l:path
                        \. "/.git/HEAD", "", 1)[0],
                        \ "^.*/", "", "") . "]"
        elseif (isdirectory(l:path . "/.svn"))
            let l:vcs_status = readfile(l:path . "/.svn/entries", "", 5)
            let g:vcs_cache[l:path] = "["
                        \. substitute(l:vcs_status[4], "^.*/", "", "")
                        \. ":r" . l:vcs_status[3]
                        \. "]"
        else
            let g:vcs_cache[l:path] = ""
        endif
    endif
    return g:vcs_cache[l:path]
endfunction

"http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    elseif bytes < 1024
        return bytes . "b"
    elseif bytes < 1048576
        return(bytes / 1024) . "Kb"
    else
        return(bytes / 1048576) . "Mb"
    endif
endfunction

function! Trailer()
    if exists ("s:trailer")
        set nolist
        echo "[Trailer off]"
        unlet s:trailer
    else
        if has("gui_running")
            set list listchars=tab:▷⋅,trail:·,extends:…,nbsp:‗
        else
            " xterm + terminus hates these
            set list listchars=tab:▷⋅,trail:·,extends:>,nbsp:_
        endif
        set fillchars=fold:-
        echo "[Trailer on]"
        let s:trailer = 1
    endif
endfunction

" From an idea by Michael Naumann
" http://amix.dk/blog/viewEntry/19334
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern   = escape(@", '\\/.*$^~[]')
    let l:pattern   = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"

    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
" Taken from http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
  let save_cursor = getpos('.')
  let append = ' vim: set ts='.&tabstop.' sw='.&shiftwidth.' tw='.&textwidth.' ft='.&filetype.' : '
  $put =substitute(&commentstring, '%s', append, '')
  call setpos('.', save_cursor)
  redraw!
  echo "Added modeline :)"
endfunction

function! SetProperties(_language)
    if (a:_language == "c")
        set syntax  =c
        set makeprg =LANGUAGE=en\ CFLAGS='-g\ -Wall'\ make\ %:r

        "TODO 07-11-2011 03:06 => work on this maps (run, make, etc)
        "r'un
        map <Leader>mr :!./%:r<CR>
        "compile & run (make a'll)
        map <Leader>ma :w<CR>:make && ./%:r<CR>

    elseif (a:_language == "java")
        set syntax   =java
        set makeprg =javac\ %

        "r'un
        map <Leader>mr :!java %:r<CR>
        "compile & run (a'll)
        map <Leader>ma  :w<CR>:make && java %:r<CR>
        "debug without arguments
        map <Leader>md  :w<CR>:make && jdb %:r<CR>
        "debug with arguments
        map <Leader>mda :w<CR>:make && jdb %:r<SPACE>

        let java_highlight_all       = 1
        let java_highlight_functions = "style"
        let java_allow_cpp_keywords  = 1

    elseif (a:_language == "php")
        set syntax              =php
        "requires php-cli
        set makeprg             =php\ -l\ %
        set errorformat         =%m\ in\ %f\ on\ line\ %l

        let php_sql_query       = 1
        let php_baselib         = 1
        let php_htmlInStrings   = 1
        let php_folding         = 1
        "don't show variables in freaking php
        "let tlist_php_settings = 'php;c:class;d:constant;f:function'
        "
    elseif (a:_language == "html")
        set syntax              =html
        set softtabstop=2      "vim sees 4 spaces as a tab
        set shiftwidth=2       "indentation
        "requires php-cli
        "set makeprg             =php\ -l\ %
        "set errorformat         =%m\ in\ %f\ on\ line\ %l

    elseif (a:_language == "perl")
        set syntax       =perl
        set makeprg      =$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
        set errorformat  =%f:%l:%m

        nnoremap <silent><Leader>> :%!perltidy -q<CR>
        vnoremap <silent><Leader>> :!perltidy -q<CR>

        let perl_extended_vars           = 1
        let perl_include_pod             = 1
        let perl_fold                    = 1
        let perl_fold_blocks             = 1
        let perl_want_scope_in_variables = 1

        "r'un
        map <Leader>mr :!perl ./%<CR>
        "run with arguments
        map <Leader>mra :!perl ./%<SPACE>

    elseif (a:_language == "python")
        set filetype=python
        set syntax=python
        set foldmethod=indent
        setlocal noexpandtab

    elseif (a:_language == "make")
        set syntax     =make
        set foldmethod =indent
        setlocal noexpandtab

    elseif (a:_language == "bash")
        set syntax  =sh
        set makeprg =chmod\ +x\ %

        "r'un
        map <Leader>mr :!./%<CR>
        "run with arguments
        map <Leader>mra :!./%<SPACE>
        "compile & run (a'll)
        map <Leader>ma :w<CR>:make && ./%<CR>

    elseif (a:_language == "markdown")
        set filetype=mkd
    endif
endfunction

" Found in a dot.org file
function! Skel(_language)
    let l:skeleton_file = expand("~/.vim/skeletons/skeleton.". a:_language)
    if filereadable(l:skeleton_file)
        execute "silent! 0read " . l:skeleton_file
        " Delete last line:
        normal! G
        normal! dd
        normal! gg
        call search("++HERE++")
        normal! xxxxxxxx
        " (crude, but it works)
        " To automatically switch to insert mode, uncomment the following line:
        " startinsert
    endif
endfunction

function! Spell(_language)
    if (a:_language == "en_us")
        let g:acp_completeOption = '.,w,b,t,k,kspell,i,d'
        set spell spelllang=en_us
    elseif (a:_language == "es_mx")
        let g:acp_completeOption = '.,w,b,t,k,i,d'
        set spell spelllang=es_mx
    elseif (a:_language == "none")
        let g:acp_completeOption = '.,w,t,k,i,d'
        set nospell
    endif
endfunction

function! Word_mode()
    if exists ("s:Word_mode")
        call Word_mode_off()
        unlet s:Word_mode
    else
        call Word_mode_on()
        let s:Word_mode = 1
    endif
endfunction

function! Word_mode_on()
    set linebreak
    set nonumber
    set textwidth=80
    call Spell("en_us")

    noremap <F3> :call Spell("es_mx")<CR>
    noremap <F4> :call Spell("en_us")<CR>
    inoremap <F3> <Esc>:call Spell("es_mx")<CR>a
    inoremap <F4> <Esc>:call Spell("en_us")<CR>a

    redraw!
endfunction

function! Word_mode_off()
    set nolinebreak
    unmap <F4>
    unmap <F3>
    iunmap <F4>
    iunmap <F3>
    call Spell("none")
    redraw!
endfu

function! Dev_mode()
    if exists ("s:Dev_mode")
        call Dev_mode_off()
        unlet s:Dev_mode
    else
        call Dev_mode_on()
        let s:Dev_mode = 1
    endif
endfunction

function! Dev_mode_on()
    set number         "show the number of the lines on the left of the screen
    set linebreak      "wrap at word
    "set patchmode=.orig       "keeps filename.orig while editing

    "Specific configuration for things that take a long time to finish.
    "TODO 07-11-2011 03:09 => wrap to another function, maybe the same SetProperties
    if &ft =="cpp" || &ft =="c"
        "stuff
    endif

    if !exists("s:nerd_tree")
        call Nerd_tree()          "It allows you to explore your filesystem
    endif

    if !exists("s:tag_list")
        call Tag_list()           "Open one window with tags of current files
    endif

    redraw!
endfunction

function! Dev_mode_off()
    "Plugins
    if exists ("s:nerd_tree")
        call Nerd_tree()
    endif

    if exists ("s:tag_list")
        call Tag_list()
    endif

    "set nocursorline
    set nonumber
    set nolinebreak

    if &ft == "cpp" || &ft=="c"
        "SetProperties("none")?
        "cs kill -1
    endif

    if &ft =="php" || &ft =="html"
    endif

    "unmap <Tab>b
    redraw!
endfunction

function! Presentation_mode()
    if exists ("s:Presentation_mode")
        call Presentation_mode_off()
        unlet s:Presentation_mode
    else
        call Presentation_mode_on()
        let s:Presentation_mode = 1
    endif
endfunction

function! Presentation_mode_on()
    "this .vimrc config was created firstly by Vroom-0.23
    set nocursorline         "highlight the screen line of the cursor

    map <SPACE> :n<CR>:<CR>
    map <BACKSPACE> :N<CR>:<CR>
    map RR  :!vroom -run %<CR>
    map VV :!vroom -vroom<CR>
    map OO :!open <cWORD><CR><CR>
    map EE :e <cWORD><CR>
    map !! G:!open <cWORD><CR><CR>
    map ?? :e .help<CR>
    let g:old_statusline=&statusline

    set statusline=
    set statusline+=%2*%-.50f\                               "file name (!full)
    set statusline+=%*\ \ \ Press\ \<Space\>\ or\ \<Backspace\>\ to\ continue
    set statusline+=%h%1*%m%r%w%0*                           "flags
    set statusline+=%=                                       "right align
    set statusline+=%2*%-8{strftime('%H:%M')}                "time

    redraw!
endf

function! Presentation_mode_off()
    set cursorline         "highlight the screen line of the cursor
    unmap <SPACE>
    noremap <SPACE> i <Esc>
    unmap <BACKSPACE>
    unmap RR
    unmap VV
    unmap OO
    unmap EE
    unmap !!
    unmap ??
    let &statusline=g:old_statusline
    redraw!
endf

function! Default_mode()
    if exists ("s:Word_mode")
        call Word_mode()
    endif
    if exists ("s:Dev_mode")
        call Dev_mode()
    endif
    if exists ("s:Presentation_mode")
        call Presentation_mode()
    endif

    if exists ("s:nerd_tree")
        call Nerd_tree()
    endif

    if exists ("s:tag_list")
        call Tag_list()
    endif
endfunction

"===============================================================================
"=============================== Experimental stuff ============================
"===============================================================================

"function! UpdateTags()
    "call writefile(getline(1, '$'), '.tmp.cc', 'b')
    "call system('grep -v "	'.expand('%').'	" tags > tags2 && mv -f tags2
    "tags')
    "let tags = system('ctags --c++-kinds=+p --fields=+iaS --extra=+q -f
    "- .tmp.cc | sed "s/\t\.tmp\.cc\t/\t'.expand('%').'\t/" >> tags')
    "return ';'
"endfunction
"inoremap <expr> ; UpdateTags()

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
