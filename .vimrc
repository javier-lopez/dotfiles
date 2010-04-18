"-------------------------------------------------------------------------------
"           Last review            Wed 18 Nov 2009 09:54:53 PM CST
"-------------------------------------------------------------------------------
"
"Plugins used:
"
" [*]matchit.vim [*]crefvim.vim NERD_tree.vim [+]snipMate.vim, breakpts.vim
" [+]taglist.vim [+]debugger.vim [*]php.vim [*]acp.vim [+]pastebin.vim autoclose.vim
" [+]browser.vim dbext.vim LargeFile.vim [*]manpageviewPlugin.vim [+]Matrix.vim
" [+]nextCS.vim [+]tetris.vim vcscommand.vim [+]VimRegEx.vim vsutil.vim qbuf.vim
" surround.vim repeat.vim [+]findmate.vim [*]IndexedSearch.vim [+]php-doc.vim
" [*]SearchComplete.vim [+]vimbuddy.vim Decho.vim genutils.vim project.vim
" lusty-explorer.vim NERD_commenter.vim tasklist.vim showmarks.vim, rails.vim
" [+]DirDiff.vim, fuf.vim, srcexpl.vim, align.vim, CSApprox.vim, cecutil.vim,
" cmdline-complete.vim, checksyntax.vim, fugitive.vim, refactor.vim
" [+]FindInNERDTree.vim, Drawit.vim, [*]echofunc.vim, omnicppcomplete.vim
" netrwPlugin.vim
"
"[+] Modified versions                   => git://github.com/chilicuil/dot-f.git
"[*] TODO 18-11-2009 21:19

"===============================================================================
"==================================== Load guards ==============================
"===============================================================================
"Comment it to enable it, I know it's weird

"let loaded_matchit          = 1
let loaded_crefvim           = 1
"let loaded_nerd_tree        = 1
"let loaded_snips            = 1
let loaded_breakpts          = 1
"let loaded_taglist_mod      = 1
"let loaded_debugger         = 1
"let loaded_acp              = 1
"let loader_pastebin         = 1
let loaded_AutoClose         = 1
"let loaded_browser          = 1
"let loaded_dbext            = 1
"let loaded_LargeFile        = 1
"let loaded_manpageviewPlugin = 1
"let loaded_Matrix           = 1
"let loaded_nextCS           = 1
"let loaded_tetris           = 1
"let loaded_VCSCommand       = 1
let loaded_vimRegEx          = 1
let VSUTIL                   = 1
"let qb_loaded               = 1
"let loaded_surround         = 1
"let loaded_repeat           = 1
"let loaded_findMate         = 1
"let indexed_search_plugin   = 1
let loader_php_doc           = 1
let loaded_search_complete   = 1
"let loaded_vimbuddy         = 1
let loaded_Decho             = 1
let loaded_genutils          = 1
let loaded_project           = 1
let loaded_lustyexplorer     = 1
"let loaded_nerd_comments    = 1
"let loaded_tasklist         = 1
let loaded_showmarks         = 1
let loaded_rails             = 1
"let loaded_DirDiff          = 1
"let loaded_fuf              = 1
let loaded_srcexpl           = 1
"let loaded_AlignMapsPlugin  = 1
"let loaded_AlignPlugin      = 1
"let CSApprox_loaded         = 1
"let loaded_cecutil          = 1
"let loaded_cmdline_complete = 1
let checksyntax              = 1
"let loaded_fugitive         = 1
"let loaded_FindInNERDTree   = 1
"let loaded_DrawItPlugin     = 1
"let loaded_echofunc         = 1
"let loaded_netrwPlugin      = 1


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
"================================ Custom functions =============================
"===============================================================================

command! WordMode       call Word_mode()
command! DevMode        call Dev_mode()
command! DefaultMode    call Default_mode()

"TODO 17-11-2009 13:10 => Add a map for this, find a way to make it work with differents langs
function! AddCscope() "Add a session only if doesn't exist a previous one
    try
        if !(cscope_connection())
            silent !cscope -R -b -q
            cs add cscope.out
        endif
    catch /E563:/
        return
    endtry
endfunction

" vimtip #1354
function! Google_for_snippet()
    let s:browser         = "firefox" "or whatever browser you prefer
    "TODO 17-11-2009 13:10 => Open it in a quickfix window
    let s:wordUnderCursor = expand("<cword>")

    if &ft == "cpp" || &ft == "c" || &ft == "ruby" || &ft == "php"
        let s:url = "http://www.google.com/codesearch?q="
                    \.s:wordUnderCursor."+lang:".&ft
    elseif  &ft == "html" || &ft == "css" || &ft == "perl"
        let s:url = "http://www.google.com/codesearch?q="
                    \.s:wordUnderCursor."+lang:".&ft
    elseif &ft == "java" || &ft == "sh" || &ft == "tex"
        let s:url = "http://www.google.com/codesearch?q="
                    \.s:wordUnderCursor."+lang:".&ft
    elseif &ft == "vim" || &ft == "python" || &ft =="javascript"
        let s:url = "http://www.google.com/codesearch?q="
                    \.s:wordUnderCursor
    else
        echohl WarningMsg| echo "Filetype unknown" |echohl None
        return
    endif

    let s:cmd = "silent !" . s:browser . " " . s:url. " 2> /dev/null &"
    execute  s:cmd
    redraw!
endfunction

function! Nerd_tree() "need it to force close it, when changing between my
                      "custom modes (dev, spell, def)
    if exists ("s:nerd_tree")
        NERDTreeClose
        wincmd p      "forces to return the focus to the window who call it
        unlet s:nerd_tree
    else
        NERDTreeToggle
        wincmd p      "forces to return the focus to the window who call it
        let s:nerd_tree = 1
    endif
endfunction

function! Tag_list()
    if exists ("s:tag_list")
        TlistClose
        unlet s:tag_list
    else
        TlistToggle
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

function! <SID>FixMiniBufExplorerTitle()
    if "-MiniBufExplorer-" == bufname("%")
        setlocal statusline=%2*%-3.3n%0*
        setlocal statusline+=\[Buffers\]
        setlocal statusline+=%=%2*\ %<%P
    endif
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
        "TODO 17-11-2009 13:11 => unset fillchars and listchars
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

"TODO 17-11-2009 13:11 => functions for  php, c, perl, python, etc
function! SetProperties(_language)

    if (a:_language == "c")
        set syntax  =c
        set makeprg =make\ %:r

        "r'un
        map <Leader>mr :!./%:r<CR>
        "compile & run (make a'll)
        map <Leader>ma :w<CR>:make && ./%:r<CR>
        "TODO 17-11-2009 13:11 => debug shortcut

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

    elseif (a:_language == "perl")
        "TODO 17-11-2009 13:11 => Use compiler when available
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
    endif
endfunction

" Found in a dot.org file, rip
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

function! Word_mode()
    if exists ("s:Word_mode")
        call Word_mode_off()
        unlet s:Word_mode
    else
        call Word_mode_on()
        let s:Word_mode = 1
    endif
endfunction

function! Spell(_language) "TODO 17-11-2009 13:12 => make _language optional
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

function! Word_mode_on()
    set linebreak
    set nonumber
    set textwidth=76
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

    "subract/add 1 from the number or alphabetic character before
    "or after the cursor.
    noremap - <c-x>
    noremap + <c-a>

    "Specific configuration for things that take a long time to finish.
    if &ft =="cpp" || &ft =="c"
        "autocreate the cscope database and add it to
        "the current session when we change to :dev mode
        call AddCscope()
    endif

    if &ft =="php" || &ft =="html"
        "silent !find . -iname '*.php' -o -iname '*.html' > cscope.files\
        "|cscope -R -b -q|rm cscope.files
        "call AddCscope()
    endif

    "TODO 17-11-2009 13:12 => specific filetype options, i.e.
    "if &ft == "filetype"
    "useful plugins, options, keyboard shortcuts, etc.
    "endif

    "'b'uild the database of cscope 'r'ecursively and for all subdirectories.
    map <Tab>b <esc>:w<CR>:call AddCscope()<CR>

    if !exists("s:nerd_tree")
        call Nerd_tree()          "It allows you to explore your filesystem
    endif

    if !exists("s:tag_list")
        call Tag_list()           "Open one window with tags of current files
    endif

    "<TAB> on insert mode is set to use the incredible snipMate plugin
    "http://www.vim.org/scripts/script.php?script_id=2540

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

    set nocursorline
    set nonumber
    set nolinebreak
    unmap +
    unmap -

    if &ft == "cpp" || &ft=="c"
        cs kill -1
    endif

    if &ft =="php" || &ft =="html"
    endif

    unmap <Tab>b
    redraw!
endfunction

function! Default_mode()
    if exists ("s:Dev_mode")
        call Dev_mode()
    endif
    if exists ("s:Word_mode")
        call Word_mode()
    endif

    if exists ("s:nerd_tree")
        call Nerd_tree()
    endif

    if exists ("s:tag_list")
        call Tag_list()
    endif
endfunction

"===============================================================================
"============================== General settings ===============================
"===============================================================================

if v:version < 700
    echo "This vimrc file use features than are only available on vim 7.0 or\
                \ greater versions"
endif

if has ('gui_running')
    set background=dark    "i like dark colors
    "colorscheme wombat     "http://files.werx.dk/wombat.vim
    colorscheme ir_black
else
    set background=dark    "i like dark colors
    colorscheme ir_black   "my favorite theme, it's a customized version
    "http://blog.infinitered.com/entries/show/6
    "http://pastebin.com/ff366c16
    if &term == "linux"
        let g:CSApprox_loaded = 1
        if &lines > 47
            set lines=47
        endif
    endif
endif

"disable features due to security concerns
set modelines=0        "http://www.guninski.com/vim1.html
set nocompatible       "breaks compatibility with vi, it must be enable at the
"start to not overwrite other flags
syntax on
set noexrc             "don't use local version of .(g)vimrc, .exrc
"set mouse=nv           "set the mouse to work in console mode
set mousehide          "hide the mouse while typying
set lazyredraw         "do not redraw the screen while macros are running. It
"improves performance
set ttyfast            "indicates a fast terminal connection
set history=1000       "record last 1000 commands, press 'q:' to see a new
"window (normal mode) with the full history
set t_Co=256           "set 256 colors. Make sure your console supports it.
"gnome-terminal and konsole work well
set report=0           "report any changes
set tabpagemax=100     "max open tabs at the same time
set autoread           "watch for file changes by other programs
set encoding=utf-8     "utf is able to represent any character
set ruler              "show the cursor position all the time
set noerrorbells       "disable annoying beeps
"set visualbell        "this one too
set wildmenu           "enhance command completion
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,
            \*.swp,*.jpg,*.png,*.xpm,*.gif
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
set cursorline         "highlight the screen line of the cursor
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
"just press F5 when you are going to
"paste several lines of text so they won't
"be indented.


set backspace=indent,eol,start     "make backspace works like in other editors.
filetype plugin indent on          "enable filetype-specific plugins

"remember as much as possible
set viminfo='1000,<1000,s100,h

"====== Status Line ======

"Nice statusline taken mostly from
"http://github.com/ciaranm/dotfiles-ciaranm/raw/master/vimrc

set laststatus=2                                         "always show statusline
set statusline=
set statusline+=%2*%-2n                                  "buffer number
set statusline+=%*\ %F\                                  "file name (full)
set statusline+=%{VCSInfo()}                             "branch info
set statusline+=%h%1*%m%r%w%0*                           "flags
set statusline+=\[%{strlen(&ft)?&ft:'none'},             "filetype
set statusline+=%{&encoding},                            "encoding
set statusline+=%{&fileformat}]                          "file format
if filereadable(expand("~/.vim/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}                      "vim buddy
endif
set statusline+=%=                                       "right align
set statusline+=%2*%-8{strftime('%H:%M')}                "time
set statusline+=%-7{FileSize()}                          "file size
"set statusline+=%2*%-3b,0x%-8B\                          "current char
set statusline+=0x%-4B\                                  "current char
"set statusline+=%-14.(%l,%c%V%)\ %<%P                    "offset
set statusline+=%-8.(%l,%c%V%)\ %P                       "offset

" special statusbar for special windows
if has("autocmd")
    au FileType qf
                \ if &buftype == "quickfix" |
                \     setlocal statusline=%2*%-3.3n%0* |
                \     setlocal statusline+=\ \[Compiler\ Messages\] |
                \     setlocal statusline+=%=%2*\ %<%P |
                \ endif
endif

"TODO 17-11-2009 13:12 => php documentation
"set runtimepath+=/home/chilicuil/.vim/doc/php

"folder options
set foldenable!                                           "off by default
set foldmethod=syntax
"set foldmarker={,}

setlocal omnifunc=syntaxcomplete#Complete "Omni-completion <C-x><C-o>

"===============================================================================
"================================ Plugins config  ==============================
"===============================================================================

"autocomplpop.vim plugin
let g:acp_behaviorKeywordLength    = 4
let g:acp_mappingDriven            = 1
let g:acp_completeOption           = '.,w,b,t,k,i,d'
let g:acp_completeoptPreview       = 1
let g:acp_behaviorSnipmateLength   = 2
let g:acp_behaviorPythonOmniLength = -1

"pastebin plugin (modified)
"let g:pasteBinURI = 'chilicuil' "Actually now it's a subdomain
let g:nickID      = 'chilicuil'

"10M for 10 min, 1H for an hour, 1D for a day, 1M for a month, and N for forever
"let g:timePasted = 'N'

"enable autoinstall of scripts w/o markup see :help GLVS
let g:GetLatestVimScripts_allowautoinstall=1

"Snippet directories
let g:snips_author      = "chilicuil"
let g:snips_authorEmail = "chilicuil@users.sourceforge.net"
let g:snippets_dir      = "~/.vim/snippets/, ~/.vim/extra-snippets/"

" qbuf.vim
let g:qb_hotkey = "<F2>"

"PA_translator.vim
"let g:PA_translator_to_lang = 'es' 
"let g:PA_translator_received_in_encoding = 'iso-8859-1'
"let g:PA_translator_received_in_encoding = 'utf8'
"for some unkown reason it doesn't work with utf-8 :S

"dbext.vim
let g:dbext_default_history_file = '~/.vim/plugin/dbext_history'
let g:dbext_default_history_size = 1000
"let g:dbext_default_profile     = 'mysql_test1'
let g:dbext_default_profile_mysql_test1 = 'type=MYSQL:user=chilicuil:
            \passwd=just4fun:dbname=test1:host=localhost:port=3306'
let g:dbext_default_profile_mysql_test0 = 'type=MYSQL:user=chilicuil:
            \passwd=just4fun:dbname=test0:host=localhost:port=3306'
let g:dbext_default_profile_mysql_cursophp2 = 'type=MYSQL:user=chilicuil:
            \passwd=just4fun:dbname=cursophp2:host=localhost:port=3306'
let g:dbext_default_profile_mysql_cursophp = 'type=MYSQL:user=chilicuil:
            \passwd=just4fun:dbname=cursophp:host=localhost:port=3306'

let g:NERDTreeWinPos    = "right"
let g:NERDTreeWinSize   = 25
let g:NERDTreeMouseMode = 3

"let g:Tlist_Use_Right_Window = 1
let g:Tlist_WinWidth          = 25
let g:Tlist_Show_One_File     = 1
let Tlist_Enable_Fold_Column  = 0

"===============================================================================
"================================ Autoloads by events ==========================
"===============================================================================

" Go back to the position the cursor was on the last time this file was edited
if has("autocmd")
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \|execute("normal `\"")|endif
endif

"Language specific settings
"TODO 17-11-2009 13:12 => Add languages
if has("autocmd")
    autocmd BufNewFile,BufEnter *.php,*.php3,*.php4  call SetProperties("php")
    autocmd BufNewFile,BufEnter *.php5,*html,*.inc   call SetProperties("php")
    autocmd BufNewFile,BufEnter *schema,*.engine     call SetProperties("php")
    autocmd BufNewFile,BufEnter *.ctp,*.thtml        call SetProperties("php")
    autocmd BufNewFile,BufEnter *.c,*.h              call SetProperties("c")
    autocmd BufNewFile,BufEnter *.pl,*.pm,*.t,*ptml  call SetProperties("perl")
    autocmd BufNewFile,BufEnter *[mM]akefile,*.mk    call SetProperties("make")
    autocmd BufNewFile,BufEnter *.java               call SetProperties("java")
    autocmd BufNewFile,BufEnter *.sh,*.bash          call SetProperties("bash")

    "Skeletons :
    autocmd BufNewFile *.rb,*.ruby,*.eruby           call Skel("ruby")
    autocmd BufNewFile *.sh,*.bash                   call Skel("bash")
    autocmd BufNewFile *.tex                         call Skel("tex")
    autocmd BufNewFile *.py,*.python                 call Skel("python")
    autocmd BufNewFile *.html                        call Skel("html")
    autocmd BufNewFile *.pl,*.perl                   call Skel("perl")
    autocmd BufNewFile *.php,*.php3,*.php4,*.php5    call Skel("php")
    autocmd BufNewFile *schema,*.inc,*.engine,*.ctp  call Skel("php")

    " turn off any existing search
    autocmd VimEnter * nohls
endif
"===============================================================================
"================================== Mappings ===================================
"===============================================================================

"=== Ctrl Mappings===
"move between split windows
"map work on --normal--, --visual-- and --operator-- modes
"look at :help map-modes for more info
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
nmap <C-W>e :new \| vimshell bash<CR>
nmap <C-W>E :vnew \| vimshell bash<CR>

"resize windows
noremap <c-left> <c-w><
noremap <c-right> <c-w>>
noremap <c-down> <c-w>-
noremap <c-up> <c-w>+

"tabs manage
map <c-n> :tabn <CR>
map <c-p> :tabp <CR>
"Ctrl+Pageup & Ctrl+Pagedown should do the same

map <c-e> :tabclose <CR>

"c'ompile
map <Leader>mc  :make <CR> 

"for some unknown reason if I set this. it executes :confirm qall when
" I write '*/' on --insert-- mode where '*' is a wildcard
"map! <c-x> <esc>:confirm qall<CR>

"exit keyboard shortcut
map <c-x> :confirm qall<CR>

"=== Leader Mappings===
let mapleader = ","

"matrix screensaver, matrix.vim plugin
map <Leader>M :Matrix<CR>

"online doc search
map <silent> <Leader>g :call Google_for_snippet()<CR>

"Trailer map
map <silent> <Leader>v :call Trailer()<CR>

"keyboard shortcuts to close/open the two main plugins
map <silent> <Leader>n :call Nerd_tree()<CR>
map <silent> <Leader>l :call Tag_list()<CR>

map <silent> <Leader>d :DevMode<CR>
map <silent> <Leader>w :WordMode<CR>
map <silent> <Leader>f :DefaultMode<CR>

"Folding
map <silent> <Leader>{ :set foldenable!<CR>
noremap <silent> <Leader>[ za

"update ~/.vimrc
map <Leader>u :source $MYVIMRC<CR>

"VCSCommand
nmap <Leader>va <Plug>VCSAdd
nmap <Leader>vn <Plug>VCSAnnotate
nmap <Leader>vc <Plug>VCSCommit
nmap <Leader>vd <Plug>VCSDiff
nmap <Leader>vg <Plug>VCSGotoOriginal
nmap <Leader>vG <Plug>VCSGotoOriginal!
nmap <Leader>vl <Plug>VCSLog
nmap <Leader>vL <Plug>VCSLock
nmap <Leader>vr <Plug>VCSReview
nmap <Leader>vs <Plug>VCSStatus
nmap <Leader>vu <Plug>VCSUpdate
nmap <Leader>vU <Plug>VCSUnlock
nmap <Leader>vv <Plug>VCSVimDiff#

"cscope
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls

nmap <Leader>fs :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>fg :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>fc :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ft :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>fe :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ff :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>fi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <Leader>fd :scs find d <C-R>=expand("<cword>")<CR><CR>

"nmap <Leader>p  :Pastebin<CR>

"Select everything
"noremap <Leader>gg ggVG

"Opens in a quickfix window your TODO list
"map <Leader>t

"crefvim.vim
"map <Leader>crn <Plug>CRV_CRefVimNormal
"map <Leader>caw <Plug>CRV_CRefVimAsk
"map <Leader>cvi <Plug>CRV_CRefVimInvoke

nnoremap <silent><Leader>g :call FindInNERDTree()<CR>

"=== Tab Mappings ===
map <Tab>c :cc<CR>
map <Tab>n :cnext<CR>
map <Tab>p :cprevious<CR>

"=== Misc Mappings===
map ; :

"you don't wanna go far away just to press <Esc>, take care when pasting stuff
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

"noremap <M-a> ggVG

"quit and save faster
noremap zz :q!<CR>
noremap ss :w<CR>
noremap SS :%!sudo tee > /dev/null %<CR>

"also check this one, It's set by default
"ZZ :wq!

"overwrite these annoying commands
cabbr W w
cabbr Q q
cabbr wQ wq
cabbr WQ wq
cabbr Wq wq

noremap <HOME> ^
noremap <END> $

"this will work only on the gui version, most terminal are unable to
"determinate the difference between <home> and <m-home>, thanks to scroolose 
"for the tip
noremap <M-HOME> gg
noremap <M-END> G

"move between buffers
map <Tab><Space> :bnext <CR>

"insert a newline in normal mode, it has some problems with vimgrep
"use r<Enter> instance
"noremap <CR> i<CR><Esc>
"noremap <CR> o<Esc>

"Basically you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

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
