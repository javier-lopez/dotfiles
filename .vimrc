"===============================================================================
"================================== Bootstrap ==================================
"===============================================================================

if !isdirectory(expand("~/.vim/bundle/vundle/.git/"))
    if !executable('git')
        echo "Couldn't find vundle nor `git`, skipping initialization ..."
        finish
    endif

    "this will be the case when vimrc is specified manually (-Nu|-u)
    if $MYVIMRC == ""
        function! GetMYVIMRC()
            if has('unix')
                let l:vim_argv   = split(system('tr "\0" " " </proc/' . getpid() . '/cmdline'))
                for l:arg in l:vim_argv
                    if exists("l:user_vimrc_found")
                        let l:user_vimrc = l:arg
                        break
                    endif
                    if (l:arg == '-Nu' || l:arg == '-NU' || l:arg == '-u' || l:arg == '-U')
                        let l:user_vimrc_found = 1
                    endif
                endfor
                return exists('l:user_vimrc') ? l:user_vimrc : ''
            endif
        endf
        let $MYVIMRC = GetMYVIMRC()
    endif

    if has("gui_running")
        "!git clone --depth=1 https://github.com/javier-lopez/vundle-legacy.git ~/.vim/bundle/vundle
        silent !git clone --depth=1 https://github.com/javier-lopez/vundle.git ~/.vim/bundle/vundle
        if isdirectory(expand("~/.vim/bundle/vundle/.git/"))
            echon "Run :BundleInstall to finish the installation"
        endif
    else
        echon "Setting up vundle, this may take a while, wanna continue? (y/n): "
        if nr2char(getchar()) ==? 'y'
            "!git clone --depth=1 https://github.com/javier-lopez/vundle-legacy.git ~/.vim/bundle/vundle
            silent !git clone --depth=1 https://github.com/javier-lopez/vundle.git ~/.vim/bundle/vundle
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
    Bundle 'javier-lopez/my-sensible.vim'
    Bundle 'javier-lopez/my-autoloads.vim'
    Bundle 'javier-lopez/my-statusline.vim'
    Bundle 'javier-lopez/my-mappings.vim'
        let mapleader = ","

    "=================================
    "====== Sourced on startup =======
    "=================================
    Bundle 'javier-lopez/vundle'          "plugin manager (custom revision, vundle + vim-plug)
    Bundle 'javier-lopez/securemodelines' "disable insecure vim options
    Bundle 'javier-lopez/file-line'       "jump to line on startup, eg: $ vim file:23
    Bundle 'javier-lopez/vimbuddy.vim'    "o@o/
    Bundle 'javier-lopez/gnupg.vim'       "pgp viewer, run from autoload
    Bundle 'javier-lopez/cutils.vim'      "random helpers
        "cutils#VCSInfo
        "cutils#FileSize
        "cutils#CUSkel, create own plugin?
        "cutils#CUSetProperties
        let g:cutils_map_longlines      = '<leader>cul'
        let g:cutils_map_appendmodeline = '<leader>am'
    Bundle 'javier-lopez/colors.vim' "favorite color schemes
        if isdirectory(expand("~/.vim/bundle/colors.vim/"))
            set background=dark
            silent! colorscheme hemisu
            if has ('gui_running')
                set gfn=Inconsolata\ Medium\ 10
                "set gfn=Monaco\ 9
                "set gfn=Monospace\ 9
            endif
        endif
    Bundle 'mhinz/vim-hugefile'   "huge files optimizer, disable expansive vim features
    Bundle 'mhinz/vim-signify'    "git|svn|etc modification viewer
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
        let g:syntastic_ignore_files             = ['\mVagrantfile$']
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
    Bundle 'google/vim-searchindex'         , { 'on': 'delay 3' } "count and index search results
    Bundle 'pbrisbin/vim-mkdir'             , { 'on': 'delay 3' } "create missing directories on saving

    "=================================
    "==== Lazy loading on action =====
    "=================================
    "colorscheme manager
    Bundle 'javier-lopez/nextCS.vim'   , { 'on': ['<Plug>NextCS', '<Plug>PreviousCS'] }
        map <F12> <Plug>NextCS
        map <F11> <Plug>PreviousCS
    "write/dev/presentation modes
    Bundle 'javier-lopez/x-modes.vim'  , { 'on': [ '<Plug>XDevelopmentMode', '<Plug>XWriteMode', '<Plug>XPresentationMode', 'XWriteMode'] }
        map <silent> <leader>D <Plug>XDefaultMode
        map <silent> <leader>d <Plug>XDevelopmentMode
        map <silent> <leader>w <Plug>XWriteMode
        map <silent> <leader>p <Plug>XPresentationMode
    "snippet support
    Bundle 'javier-lopez/snipmate.vim' , { 'on': 'insert' }
        let g:snips_author             = "Javier Lopez"
        let g:snips_authorEmail        = "m@javier.io"
        let g:snippets_dir             = "~/.vim/bundle/snippets.vim/snipmate/"
        let g:snipmate_default_choice  = 1
    Bundle 'javier-lopez/snippets.vim' , { 'on': 'insert' }

    "autocompletion
    Bundle 'Shougo/neocomplcache'      , { 'on': 'insert' }
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
    "undo navigation bar
    Bundle 'mbbill/undotree' , { 'on': 'UndotreeToggle' }
        map <leader>u :UndotreeToggle<cr>

    "modern buffer manager
    "Bundle 'zefei/vim-wintabs'

   "file viewer
    Bundle 'scrooloose/nerdtree'       , { 'on': ['NERDTreeToggle', '<Plug>NERDTreeTabsToggle']}
        let g:NERDTreeWinPos           = 'right'
        let g:NERDTreeWinSize          = 25
        let g:NERDTreeMouseMode        = 3
        let g:NERDTreeMinimalUI        = 1
        let g:NERDTreeDirArrows        = 1
        "let g:NERDTreeMapOpenSplit    = "-"
        "let g:NERDTreeMapOpenVSplit   = "|"
        "map <silent> <leader>n  :NERDTreeToggle<cr>
        "https://stackoverflow.com/questions/11227721/make-nerdtree-open-a-file-where-the-cursor-was-last
        "set hidden
    "toggle comments
    Bundle 'jistr/vim-nerdtree-tabs'   ", { 'on': '<Plug>NERDTreeTabsToggle' }
        map <silent> <leader>n  <Plug>NERDTreeTabsToggle<cr>
    Bundle 'scrooloose/nerdcommenter'  , {'on': ['<Plug>NERDCommenterToggle', '<Plug>NERDCommenterSexy'] }
        map <leader>c<space> <Plug>NERDCommenterToggle
        map <leader>cs       <Plug>NERDCommenterSexy
        let g:NERDCustomDelimiters  = {'mkd':    {'left':'<!--', 'right':'-->'},
                                      \'jinja2': {'left':'{# ',  'right':' #}'},
                                      \}
    "pastebin client
    Bundle 'javier-lopez/sprunge.vim'  , { 'on': ['<Plug>Sprunge'] }
        map <leader>s <Plug>Sprunge
        let g:sprunge_flush_left = 1
    "checksum generator
    Bundle 'javier-lopez/checksum.vim' , { 'on': ['<Plug>Checksum'] }
        map <leader>c <Plug>Checksum

    "fuzzy file|buffer|etc finder
    Bundle 'kien/ctrlp.vim'      , { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMixed'] }
    "Bundle 'ctrlpvim/ctrlp.vim' , { 'on': ['CtrlP', 'CtrlPBuffer', 'CtrlPMixed'] } "active fork
        "let g:ctrlp_cache_dir          = $HOME.'/.cache/ctrlp'
        let g:ctrlp_use_caching         = 1
        let g:ctrlp_clear_cache_on_exit = 0
        let g:ctrlp_working_path        = 0
        let g:ctrlp_match_window        = 'bottom,order:ttb,min:1,max:10,results:100'
        let g:ctrlp_extensions          = ['smarttabs']
        let g:ctrlp_map                 = '<leader>f'
        map <leader>f                   :CtrlP<CR>
        map <leader>b                   :CtrlPBuffer<CR>
        if has('python')
            let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
        endif
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

    "class/function/var browser
    Bundle 'majutsushi/tagbar' , { 'on': 'TagbarToggle', 'do': 'wget --no-check-certificate https://raw.githubusercontent.com/javier-lopez/learn/master/python/tools/mkd2ctags && chmod +x mkd2ctags' }
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
        map <silent> <leader>l :TagbarToggle<cr>
    "grep|ag search integration
    Bundle 'mileszs/ack.vim' , { 'on': ['Ack'] }
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

    "mv at the speed of light
    Bundle 'Lokaltog/vim-easymotion'  , { 'on': ['<Plug>(easymotion-prefix)'] }
        "let g:EasyMotion_leader_key  = '<leader><leader>'
        map <leader><leader>          <Plug>(easymotion-prefix)
        let g:EasyMotion_keys         = 'asdfghjklqwertyuiopzxcvbnm'
    "align columns on characters
    Bundle 'junegunn/vim-easy-align'  , { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
        "command! -nargs=* -range -bang Align
        "\ <line1>,<line2>call easy_align#align('<bang>' == '!', 0, '', <q-args>)
        command! -nargs=* -range -bang Align <line1>,<line2>EasyAlign
        vmap . <Plug>(EasyAlignRepeat)
        nmap <leader>a <Plug>(EasyAlign)
    "tmux like zoom panel
    Bundle 'szw/vim-maximizer', { 'on': ['MaximizerToggle'] }
        let g:maximizer_set_default_mapping = 0
        map <Leader>z :MaximizerToggle<CR>

    "zen write mode
    Bundle 'junegunn/goyo.vim'        , { 'on': 'Goyo' }
    "hyperfocus
    Bundle 'junegunn/limelight.vim'   , { 'on': 'Limelight' }
        autocmd! User GoyoEnter Limelight
        autocmd! User GoyoLeave Limelight!

    "=================================
    "========== Experimental =========
    "=================================
    Bundle 'javier-lopez/relative-number.vim'
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
    Bundle 'dkarter/bullets.vim', { 'on': 'delay' } "helps creating lists
    "Bundle 'KabbAmine/lazyList.vim', { 'on': 'delay' } "helps creating lists
        "let g:lazylist_maps = [ 'gl', { 'l': '', '1': '%1% ', '-': '- ', '*': '* ' } ]
    Bundle 'junegunn/vader.vim'  , { 'on': ['Vader'], 'for': 'vader' } "vim tdd
    Bundle 'Olical/vim-enmasse'  , { 'on': ['EnMasse'] } "edit quicklist results, grep/ag
    Bundle 'wting/gitsessions.vim'  , { 'on': ['GitSessionSave', 'GitSessionDelete'] }
        command! -nargs=* SessionSave   GitSessionSave
        command! -nargs=* SessionDelete GitSessionDelete
        let g:closetag_filenames = "*.html,*.xhtml,*.phtml"
    Bundle 'alvan/vim-closetag'    , { 'on': 'insert' } "autoclose xml|html tags
    Bundle 'javier-lopez/vlide.vim', { 'on': [ 'Vlide', 'VlideReferenceSlide' ] }
    "Bundle 'jaxbot/semantic-highlight.vim'
    "Bundle 'Two-Finger/hardmode' "use vim the right way
        "let g:hardmode = 1
        "nnoremap <Leader>H <Esc>:call ToggleHardMode()<CR>
    "Bundle 'cohama/lexima.vim'  , { 'on': 'delay 3' } "autocomplete pairs, <Enter> smash with Shougo/neocomplcache
    "Bundle 'vim-scripts/DrawIt'
    "Bundle 'gyim/vim-boxdraw'
    Bundle 'mattn/emmet-vim'
        "let g:user_emmet_leader_key = '<C-h>'  "[h]tml
        "let g:user_emmet_leader_key = '<C-e>' "[e]mmet
        let g:user_emmet_install_global = 0
        let g:user_emmet_expandabbr_key = '<C-y>e'
        let g:user_emmet_expandword_key = '<C-y>E'
        autocmd FileType html,css EmmetInstall
    Bundle 'javier-lopez/math.vim', { 'on': ['VimSum'] }

    "=================================
    "============ Discarted ==========
    "=================================
    "Bundle 'javier-lopez/taglist.vim'      "tagbar looks better
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
    "Bundle 'edsono/vim-matchit' , { 'on': 'delay 3' } "added to vanilla vim
    "Bundle 'valloric/MatchTagAlways' "complex alternative, requires +python
endif
