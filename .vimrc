"===============================================================================
"================================== Bootstrap ==================================
"===============================================================================

if !isdirectory(expand("~/.vim/bundle/vundle/.git/"))
    if has("gui_running")
        "!git clone --depth=1 https://github.com/chilicuil/vundle-legacy.git ~/.vim/bundle/vundle
        silent !git clone --depth=1 https://github.com/chilicuil/vundle.git ~/.vim/bundle/vundle
        if isdirectory(expand("~/.vim/bundle/vundle/.git/"))
            echon "Run :BundleInstall to finish the installation"
        endif
    else
        echon "Setting up vundle, this may take a while, wanna continue? (y/n): "
        if nr2char(getchar()) ==? 'y'
            "!git clone --depth=1 https://github.com/chilicuil/vundle-legacy.git ~/.vim/bundle/vundle
            silent !git clone --depth=1 https://github.com/chilicuil/vundle.git ~/.vim/bundle/vundle
            silent !printf "Installing vundle plugins ..."
            silent !vim -es -u "${MYVIMRC}" -c "BundleInstall" -c qa
        endif
    endif
endif

"===============================================================================
"=================================== Plugins ===================================
"===============================================================================

if isdirectory(expand("~/.vim/bundle/vundle/"))
    set runtimepath+=~/.vim/bundle/vundle/
    call vundle#rc()

    "=================================
    "=== Personal general settings ===
    "=================================
    Bundle 'chilicuil/my-vim-sensible'
    Bundle 'chilicuil/my-vim-autoloads'
    Bundle 'chilicuil/my-vim-statusline'
    Bundle 'chilicuil/my-vim-mappings'
        let mapleader = ","

    "=================================
    "====== Sourced on startup =======
    "=================================
    Bundle 'chilicuil/vundle'          "plugin manager (custom revision, vundle + vim-plug)
    Bundle 'chilicuil/securemodelines' "disable insecure vim options
    Bundle 'chilicuil/file-line'       "jump to line on startup, eg: $ vim file:23
    Bundle 'chilicuil/vimbuddy.vim'    "o@o/
    Bundle 'chilicuil/gnupg.vim'       "pgp viewer, run from autoload
    Bundle 'chilicuil/vim-cutils'      "random helpers
        "cutils#VCSInfo
        "cutils#FileSize
        "cutils#CUSkel, create own plugin?
        "cutils#CUSetProperties
        let g:cutils_map_longlines      = '<leader>cul'
        let g:cutils_map_appendmodeline = '<leader>am'
    Bundle 'chilicuil/vim-colors' "colorschemes collection
        if isdirectory(expand("~/.vim/bundle/vim-colors/"))
            set background=dark
            silent! colorscheme hemisu
            if has ('gui_running')
                set gfn=Inconsolata\ Medium\ 10
                "set gfn=Monaco\ 9
                "set gfn=Monospace\ 9
            endif
        endif
    Bundle 'mhinz/vim-hugefile'  "huge files optimizer, disable expansive vim features
    Bundle 'mhinz/vim-signify'   "git|svn|etc modification viewer
        let g:signify_vcs_list    = [ 'git' ]
        let g:signify_sign_add    = '+'
        let g:signify_sign_change = '~'
        let g:signify_sign_delete = '-'
        "let g:secure_modelines_verbose=1

    "=================================
    "===== Lazy loading on time ======
    "=================================
    Bundle 'scrooloose/syntastic' , { 'on': 'delay' } "syntax checker, default to 'delay 10'
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list            = 1
        let g:syntastic_check_on_open            = 1
        let g:syntastic_check_on_wq              = 0
        let g:syntastic_python_python_exec       = "python2"
        let g:syntastic_html_tidy_exec           = "tidy"
        let g:syntastic_auto_jump                = 2
        "let g:syntastic_error_symbol            = "E!"
        "let g:syntastic_warning_symbol          = "W"
    Bundle 'tpope/vim-repeat'               , { 'on': 'delay' } "repeat|. support for plugins
    Bundle 'ntpeters/vim-better-whitespace' , { 'on': 'delay' } "whitespace heater
        set list
        set listchars=tab:▷⋅,trail:⋅,nbsp:⋅
    Bundle 'tpope/vim-surround'             , { 'on': 'delay' } "text :h objects on steroids
        " ds"   => delete surrounding quotes
        " cs"'  => replace surrounding quotes with single quotes
        " ysiw' => wrap word in surrounding single quotes
    Bundle 'paradigm/TextObjectify'         , { 'on': 'delay 3' } "define additional text :h objects
    Bundle 'edsono/vim-matchit'             , { 'on': 'delay 3' } "match pairs {,(,',etc
    "Bundle 'valloric/MatchTagAlways' "complex alternative, requires +python
    Bundle 'henrik/vim-indexed-search'      , { 'on': 'delay 3' } "count and index search results
    Bundle 'pbrisbin/vim-mkdir'             , { 'on': 'delay 3' } "create missing directories on saving

    "=================================
    "==== Lazy loading on action =====
    "=================================
    Bundle 'chilicuil/vim-sprunge'     , { 'on': ['<Plug>Sprunge'] }  "pastebin client
        map <leader>s <Plug>Sprunge
        let g:sprunge_flush_left = 1
    "colorscheme manager
    Bundle 'chilicuil/nextCS'          , { 'on': ['<Plug>NextCS', '<Plug>PreviousCS'] }
        map <F12> <Plug>NextCS
        map <F11> <Plug>PreviousCS
    Bundle 'chilicuil/vim-checksum'    , { 'on': ['<Plug>Checksum'] } "checksum generator
        map <leader>c <Plug>Checksum
    Bundle 'chilicuil/x-modes'         , { 'on': [ '<Plug>XDevelopmentMode', '<Plug>XWriteMode', 'XWriteMode', '<Plug>XPresentationMode'] }
        map <silent> <leader>D <Plug>XDefaultMode
        map <silent> <leader>d <Plug>XDevelopmentMode
        map <silent> <leader>w <Plug>XWriteMode
        map <silent> <leader>p <Plug>XPresentationMode

    Bundle 'scrooloose/nerdtree'       , { 'on': 'NERDTreeToggle' } "file viewer
        let g:NERDTreeWinPos           = 'right'
        let g:NERDTreeWinSize          = 25
        let g:NERDTreeMouseMode        = 3
        "let g:NERDTreeMapOpenSplit    = "-"
        "let g:NERDTreeMapOpenVSplit   = "|"
        map <silent> <leader>n  :NERDTreeToggle<cr>
    Bundle 'scrooloose/nerdcommenter'  , {'on': ['<Plug>NERDCommenterToggle', '<Plug>NERDCommenterSexy'] }
       map <leader>c<space> <Plug>NERDCommenterToggle
       map <leader>cs       <Plug>NERDCommenterSexy
       let g:NERDCustomDelimiters  = {'mkd': { 'left': '<!--', 'right': '-->'}}

    "class/function/var browser
    Bundle 'majutsushi/tagbar' , { 'on': 'TagbarToggle', 'do': 'wget --no-check-certificate https://raw.githubusercontent.com/chilicuil/learn/master/python/tools/mkd2ctags && chmod +x mkd2ctags' }
        let g:tagbar_left      = 1
        let g:tagbar_width     = 25
        let g:tagbar_type_mkd  = {
            \ 'ctagstype': 'markdown',
            \ 'ctagsbin' : '~/.vim/bundle/tagbar/mkd2ctags',
            \ 'ctagsargs' : '-f - --sort=yes',
            \ 'kinds' : [
                \ 's:sections',
                \ 'l:links',
                \ 'i:images'
            \ ],
            \ 'sort': 0
        \ }
        map <silent> <leader>l    :TagbarToggle<cr>

    Bundle 'mbbill/undotree'           , { 'on': 'UndotreeToggle' } "undo navigation bar
        map <leader>u :UndotreeToggle<cr>
    Bundle 'mileszs/ack.vim'           , { 'on': ['Ack'] } "grep|ag search integration
        "let g:ackpreview = 1
        let g:ackhighlight = 1
        let g:ack_mappings = { "O": "<CR>zz", "o": "<CR>zz:ccl<CR>", "p": "<CR>zz<C-W>p", "i": "<C-W><CR><C-W>x<C-W>p", }
        command! -nargs=* Grep Ack! <q-args>
        nmap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>
        if executable("ag")
            let g:ackprg = "ag --vimgrep"
        else
            let g:ackprg = "grep -rni --exclude-dir={.git,.svn,.bzr,.hg,.pc,CVS} --binary-files=without-match . -e"
        endif
    Bundle 'Lokaltog/vim-easymotion'  , { 'on': ['<Plug>(easymotion-prefix)'] }
        "let g:EasyMotion_leader_key  = '<leader><leader>'
        map <leader><leader>          <Plug>(easymotion-prefix)
        let g:EasyMotion_keys         = 'asdfghjklqwertyuiopzxcvbnm'

    Bundle 'junegunn/goyo.vim'         , { 'on': 'Goyo' } "zen write mode
    Bundle 'junegunn/limelight.vim'    , { 'on': 'Limelight' } "hyperfocus
        autocmd! User GoyoEnter Limelight
        autocmd! User GoyoLeave Limelight!
    "align columns on characters
    Bundle 'junegunn/vim-easy-align' , { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
        "command! -nargs=* -range -bang Align
        "\ <line1>,<line2>call easy_align#align('<bang>' == '!', 0, '', <q-args>)
        command! -nargs=* -range -bang Align <line1>,<line2>EasyAlign
        vmap . <Plug>(EasyAlignRepeat)
        nmap <leader>a <Plug>(EasyAlign)

    "fuzzy file|buffer|etc finder
    Bundle 'kien/ctrlp.vim'      , { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMixed'] }
    "Bundle 'ctrlpvim/ctrlp.vim' , { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMixed'] } "active fork
        "let g:ctrlp_cache_dir          = $HOME.'/.cache/ctrlp'
        let g:ctrlp_use_caching         = 1
        let g:ctrlp_clear_cache_on_exit = 0
        let g:ctrlp_working_path        = 0
        let g:ctrlp_match_window        = 'bottom,order:ttb,min:1,max:10,results:100'
        let g:ctrlp_extensions          = ['smarttabs']
        " let g:ctrlp_map               = '<leader>f'
        map <leader>f                   :CtrlP<cr>
        map <leader>b                   :CtrlPBuffer<cr>
        if has('python') | let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' } | endif
        if executable("ag")
            let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup
            \ --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store
            \ --ignore *.pyc --ignore *.mp3 --ignore *.png --ignore *.jpg -g ""'
        endif
    Bundle 'DavidEGx/ctrlp-smarttabs' , { 'on': ['CtrlPSmartTabs'] }
        let g:ctrlp_smarttabs_reverse        = 0
        let g:ctrlp_smarttabs_modify_tabline = 0
        map <leader>t :call vundle#load('ctrlp.vim')<cr>:CtrlPSmartTabs<cr>
    Bundle 'FelikZ/ctrlp-py-matcher'  , { 'on': 'delay 5' }

    Bundle 'chilicuil/snipmate.vim' , { 'on': 'insert' } "snippet support
        let g:snips_author            = "Javier Lopez"
        let g:snips_authorEmail       = "m@javier.io"
        let g:snippets_dir            = "~/.vim/bundle/vim-snippets/snipmate/"
        let g:snipmate_default_choice = 1
    Bundle 'chilicuil/vim-snippets' , { 'on': 'insert' } "snippet definitions

    Bundle 'Shougo/neocomplcache'   , { 'on': 'insert' } "autocompletion
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

    Bundle 'delimitMate.vim'        , { 'on': 'insert' } "autocomplete pairs
        autocmd FileType html let b:delimitMate_matchpairs = "(:),[:],{:}"

    "=================================
    "========== Experimental =========
    "=================================
    Bundle 'chilicuil/vim-relative-number'
        map <Leader>N <Plug>RelativeNumberToggle
    "better syntax support
    Bundle 'sheerun/vim-polyglot' , { 'do': 'cd syntax; cp markdown.vim mkd.vim' }
    Bundle 'junegunn/vim-peekaboo' "preview registers
    Bundle 'gastonsimone/vim-dokumentary' "documentation viewer (K in normal mode)
    Bundle 'ap/vim-css-color'      "colorize #hex, rgb tags
    Bundle 'szw/vim-g'
        let g:vim_g_open_command  = "xdg-open"
        "let g:vim_g_open_command = "google-chrome"
        "let g:vim_g_query_url    = "http://google.com/search?q="
        "let g:vim_g_command      = "Google"
        "let g:vim_g_f_command    = "Googlef"
    Bundle 'KabbAmine/lazyList.vim', { 'on': 'delay' } "helps creating lists
        let g:lazylist_maps = [ 'gl', { 'l': '', '1': '%1% ', '-': '- ', '*': '* ' } ]
    Bundle 'junegunn/vader.vim'  , { 'on': ['Vader'] }   "vim tdd
    Bundle 'Olical/vim-enmasse'  , { 'on': ['EnMasse'] } "edit quicklist results, grep/ag
    Bundle 'wting/gitsessions.vim'  , { 'on': ['GitSessionSave', 'GitSessionDelete'] }
        command! -nargs=* SessionSave   GitSessionSave
        command! -nargs=* SessionDelete GitSessionDelete
        let g:closetag_filenames = "*.html,*.xhtml,*.phtml"
    Bundle 'alvan/vim-closetag'  , { 'on': 'insert' }    "autoclose xml|html tags
    "Bundle 'Two-Finger/hardmode' "use vim the right way
        "let g:hardmode = 1
        "nnoremap <Leader>H <Esc>:call ToggleHardMode()<CR>

    "=================================
    "============ Discarted ==========
    "=================================
    "Bundle 'chilicuil/taglist.vim'         "tagbar looks better
    "Bundle 'FindMate'                      "ctrlp.vim ftw!
    "Bundle 'vim-scripts/AutoComplPop'      "neocomplcache is better
        "let g:acp_behaviorKeywordLength    = 4
        "let g:acp_mappingDriven            = 1
        "let g:acp_completeOption           = '.,w,b,t,k,i,d'
        "let g:acp_completeoptPreview       = 1
        "let g:acp_behaviorSnipmateLength   = 2
        "let g:acp_behaviorPythonOmniLength = -1
    "Bundle 'Lokaltog/vim-powerline'        "prefer my own powerline =)
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
    "Bundle 'tomtom/tcomment_vim' , { 'on': '<Plug>TComment_<c-_><c-_>' }
    "    map <leader>c<space> <Plug>TComment_<c-_><c-_>
    "    map <leader>cs       <Plug>TComment_<c-_><c-_>
    "    let g:tcommentOptions = {'whitespace': 'no'} "nerdcommenter ftw!
    "Bundle 'lilydjwg/colorizer' "way slower than 'ap/vim-css-color'
    "Bundle 'wellle/tmux-complete.vim' , { 'on': 'insert' } "too slow
endif
