" File          : pastebin.vim
" Author        : chilicuil.vim@gmail.com
" Description   : Upload files/text to pastebin.com
" Last Modified : March 18, 2010

"Load guard
if &cp || exists("g:loaded_pastebin")
    finish
endif

let g:loaded_pastebin = 0.0.1
let s:old_cpo         = &cpo
set cpo&vim
"=======================================================================

let s:language_mapping = {       'abel':       'text',
                                \'ada':        'ada',
                                \'ant':        'text',
                                \'apache':     'apache',
                                \'asm':        'asm',
                                \'nasm':       'asm',
                                \'asp':        'asp',
                                \'baan':       'text',
                                \'basic':      'vb',
                                \'batch':      'winbatch',
                                \'debsources': 'apt_sources',
                                \'c':          'c',
                                \'css':        'css',
                                \'cpp':        'cpp',
                                \'ch':         'text',
                                \'chill':      'text',
                                \'changelog':  'text',
                                \'cobol':      'cobol',
                                \'coldfusion': 'cfm',
                                \'cfm':        'cfm',
                                \'csh':        'text',
                                \'cynlib':     'text',
                                \'cweb':       'text',
                                \'d':          'd',
                                \'none':       'text',
                                \'desktop':    'text',
                                \'diff':       'diff',
                                \'dircolors':  'text',
                                \'docbk':      'text',
                                \'docbkxml':   'text',
                                \'docbksgml':  'text',
                                \'dosbatch':   'winbatch',
                                \'doxygen':    'text',
                                \'dtd':        'text',
                                \'eiffel':     'eiffel',
                                \'erlang':     'erlang',
                                \'flexwiki':   'text',
                                \'form':       'text',
                                \'fortran':    'fortran',
                                \'fvwm':       'text',
                                \'gsp':        'text',
                                \'groff':      'text',
                                \'haskell':    'haskell',
                                \'lhaskell':   'haskell',
                                \'html':       'html4strict',
                                \'htmlos':     'html4strict',
                                \'ia64':       'text',
                                \'inform':     'text',
                                \'idl':        'idl',
                                \'java':       'java',
                                \'javascript': 'javascript',
                                \'lace':       'text',
                                \'lex':        'text',
                                \'lisp':       'lisp',
                                \'lite':       'text',
                                \'lpc':        'text',
                                \'lua':        'lua',
                                \'mail':       'email',
                                \'make':       'make',
                                \'maple':      'text',
                                \'mma':        'text',
                                \'moo':        'text',
                                \'mysql':      'mysql',
                                \'ncf':        'text',
                                \'nroff':      'text',
                                \'ocaml':      'ocaml',
                                \'papp':       'text',
                                \'pascal':     'pascal',
                                \'perl':       'perl',
                                \'php':        'php',
                                \'php3':       'php',
                                \'plaintex':   'text',
                                \'ppwiz':      'text',
                                \'phtml':      'text',
                                \'postscr':    'text',
                                \'ptcap':      'text',
                                \'progress':   'progress',
                                \'w':          'progress',
                                \'python':     'python',
                                \'quake':      'text',
                                \'readline':   'text',
                                \'rexx':       'text',
                                \'ruby':       'ruby',
                                \'scheme':     'scheme',
                                \'sdl':        'sdlbasic',
                                \'sed':        'text',
                                \'sgml':       'text',
                                \'sh':         'bash',
                                \'spup':       'text',
                                \'sql':        'sql',
                                \'tcsh':       'text',
                                \'tex':        'latex',
                                \'tf':         'text',
                                \'vim':        'vim',
                                \'xf86conf':   'text',
                                \'xml':        'xml',
                                \'xpm':        'text',
                                \'vb':         'vb' }
"==============================================================

function! Pastebin() range
    "The Pastebin() function was taken mostly from:
    "   http://www.vim.org/scripts/script.php?script_id=2602
    "
    "According to http://pastebin.com/api.php the parameters needed are:
    "
    "   paste_code(string)
    "       -this is simply the text that you paste on pastebin
    "   paste_format(string)
    "       -for adding syntax highlighting
    "   paste_expire_date(string: N, 10M, 1H, 1D, 1M)
    "       -for adding expiration date. N = Never, 10M = 10 Minutes,
    "        1H = 1 Hour, 1D = 1 Day, 1M = 1 Month
    "   paste_subdomain(string)
    "       -for using a certain subdomain
    "   paste_name(string)
    "       -for adding a title or name to your paste

    "Get the code to pastebin
    let s:paste_code = join(getline(a:firstline, a:lastline), "\n")

    "Get the format
    if has_key(s:language_mapping, &filetype)
        let s:paste_format = s:language_mapping[&filetype]
    else
        let s:paste_format = s:language_mapping['none']
    endif

    "Get the subdomain
    if (!exists('g:pasteBinURI'))
        let g:pasteBinURI = inputdialog("Enter your subdomain (or press enter): ", "")
    endif

    "I had to do this to keep compatibility with the last pastebin plugin I used
    let s:paste_subdomain = g:pasteBinURI

    "Get the author
    if (!exists('g:nickID'))
        let g:nickID = input("Enter your nick or ID for this posting: ", "Anonymous")
    endif
    let s:paste_name = g:nickID

    "Get the expire time
    if (!exists('g:timePasted'))
        let g:timePasted = input("How long should your post be retained? (d)ay/(m)onth/(f)orever: ", "d")
    endif
    let s:paste_expire_date = g:timePasted

    if (s:paste_expire_date == "d")
        let s:paste_expire_date = "1D"
    elseif (s:paste_expire_date == "m")
        let s:paste_expire_date = "1M"
    elseif (s:paste_expire_date == "f")
        let s:paste_expire_date = "N"
    else
        let s:paste_expire_date = "1D"
    endif

    redraw!

    if (s:paste_subdomain == "")
        echon "Posting on http://pastebin.com as " .s:paste_name
    else
        echon "Posting on http://" . s:paste_subdomain . ".pastebin.com as " .s:paste_name
    endif

    "echo "curl -0s -d '"
                "\."paste_code="         .s:paste_code
                "\."&paste_format="       .s:paste_format
                "\."&paste_expire_date=" .s:paste_expire_date
                "\."&paste_subdomain="   .s:paste_subdomain
                "\."&paste_name="        .s:paste_name
                "\."&submit=submit'"     ." http://pastebin.com/api_public.php"

    "The custom server at pastebin.com (TorrentFly.org Custom Httpd)
    "doesn't recognize the 100-continue Expect request-header field
    "That's why I was forced to use the 1.0 Http version (-0)
    let URL = system("curl -0s -d '"
                \."paste_code="          .s:paste_code
                \."&paste_format="       .s:paste_format
                \."&paste_expire_date=" .s:paste_expire_date
                \."&paste_subdomain="   .s:paste_subdomain
                \."&paste_name="        .s:paste_name
                \."&submit=submit'"     ." http://pastebin.com/api_public.php")

    "let s:Asda=system('sleep 10s')
    redraw!
    echo URL

    if executable("xclip")
        let s:foo = system("echo '" .URL. "'|xclip")
    endif
endfunction

command! -range=% -nargs=0 Pastebin :<line1>,<line2>call Pastebin()

if !hasmapto('<Plug>Pastebin')
    map <unique> ,p[ <Plug>Pastebin
endif
noremap <unique><script> <Plug>Pastebin :Pastebin<CR>
"====================================

let &cpo = s:old_cpo
unlet s:old_cpo
