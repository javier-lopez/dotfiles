"Name: findMate
"Author: Manuel  Aguilar y Victor Guardiola
"Version: 0.1
"Description: Este plugin es buscador de archivos en todo un arbol de
"dirctorios
"
"Maintainer: chilicuil.vim@gmail.com
"TODO (if you add some of these plese let me know):
"   * Improve input parser, so it can select ranges, and lists (using commas
"     or any other simbol instance white spaces)
"   * Add an option to show a preview of the files
"   * Add the option to move beetween files found with the j,k keys

"Global variables
"   g:FindMate_totalResults => Total number of results displayed
"   g:FindMate_verbose      => Flag option to confirm dialogs
"   g:FindMate_firstSearch  => First program to make the search (locate by default)
"=======================================================================

"Load guard
if &cp || exists("g:loaded_findMate")
    finish
endif

let g:loaded_findMate = 1
let s:old_cpo         = &cpo
set cpo&vim
"=======================================================================

"Default behavior
if (!exists('g:FindMate_totalResults'))
    let g:FindMate_totalResults = 15
endif

if (!exists('g:FindMate_verbose'))
    let g:FindMate_verbose = 1
endif

if (!exists('g:FindMate_firstSearch'))
    let g:FindMate_firstSearch = 'locate'
endif
"=======================================================================

function! s:FindMate_vimgrep(_name)
    try
        silent execute g:FindMate_totalResults. "vimgrep /\\%1l/j **/" .a:_name. "*"
    catch /E480:/
        let l:_name = substitute(a:_name, "*", " ", "g")
        echo "Your search -" .l:_name. "- did not match any documents"
        return
    endtry
    copen
endfunction

function! s:FindMate_locate(_name)
    let l:list = system("locate -e -b -i -n ".g:FindMate_totalResults. " '*".a:_name.
                \"*' | perl -ne 'print \"$.\\t$_\"'")
    let l:num = strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        return [l:list, -1]
    else
        return [l:list, l:num]
    endif
endfunction

function! s:FindMate_find(_name)
    let l:list = system("find . -iname '*".a:_name."*' -not -name \"*.class\" -and 
                \-not -name \"*.swp\" -and -not -name \".*\" |head -"
                \.g:FindMate_totalResults."| perl -ne 'print \"$.\\t$_\"'")
    let l:num = strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        return [l:list, -1]
    else
        return [l:list, l:num]
    endif
endfunction

function! s:FindMate_show(_list)
    "Araxia recommendation
    if (!type(a:_list) == type([]))
        return
    endif
    
    if (a:_list[1] > 1)
        echo a:_list[0]
        let l:input = input("Which ones (<enter>=nothing)? ")

        if strlen(l:input) == 0
            return
        endif

        "I think it could be great if we could use ranges (e.g. 1-5)
        "and commas (e.g. 1,2,5,7)
        let items = split(l:input, ' ', 1)

        "TODO: Ask again
        for item in items
            if strlen(substitute(l:item, "[0-9]", "", "g"))>0
                echo "Not a number"
                return
            endif

            if l:item<1 || l:item>a:_list[1]
                echo "Out of range"
                return
            endif

            let l:line = matchstr("\n".a:_list[0], "\n".l:item."\t[^\n]*")
            "remove the number at start of the string
            let l:line = substitute(l:line, "^[^\t]*\t", "", "")
            "replaces white spaces with '\ '
            let l:line = substitute(l:line, "\\s", "\\\\ ", "g")
            "let l:line=substitute(l:line, '\s', '\\ ', "g")

            execute ":sp ".l:line
        endfor
    else
        let l:line = substitute(a:_list[0], "^[^\t]*\t", "", "")
        let l:line = substitute(l:line, "\\s", "\\\\ ", "g")
        execute ":sp ".l:line
    endif
endfunction

function! FindMate(name)

    let l:_name = substitute(a:name, "\\s", "*", "g")
    let s:running_windows = has("win16") || has("win32") || has("win64")

    if s:running_windows "This was the only way I could figure out to make it work :S
        call s:FindMate_vimgrep(_name)
        return
    endif

    if (g:FindMate_firstSearch == 'locate')
        let l:list = s:FindMate_locate(_name)
        if (l:list[1] == -1)
            if g:FindMate_verbose
                echo "Your search -" .a:name. "- did not match any documents"
                let answer = input("\n\nWould you like to try using \"find\"
                            \(this may take some minutes)? (y/n): ", "y")
                if answer == "y"
                    redraw!
                    echo "Seaching '" .a:name. "'"
                    let l:list = s:FindMate_find(_name)
                    if (l:list[1] == -1) 
                        echo "Your search -" .a:name. "- did not match any documents"
                        return
                    endif
                endif
            else
                "let l:list = FindMate_find(_name)
                "if (l:list[1] == -1) 
                "echo "Your search -" .a:name. "- did not match any documents"
                "return
                "endif

                "I think most people wouldn't like the script executes find 
                "without been notified, anyway I'll leave it here if someone wants
                "it.
                return
            endif
        endif
        call s:FindMate_show(l:list)
        return
    else 
        let l:list = s:FindMate_find(_name)
        if (l:list[1] == -1) 
            if g:FindMate_verbose
                echo "Your search -" .a:name. "- did not match any documents"
                let answer = input("\n\nWould you like to try using \"locate\"
                            \(this will search in the whole system)? (y/n): ", "y")
                if answer == "y"
                    redraw!
                    let l:list = s:FindMate_find(_name)
                    if (l:list[1] == -1) 
                        echo "Your search -" .a:name. "- did not match any documents"
                        return
                    endif
                endif
            endif
        endif
    endif
    call s:FindMate_show(l:list)
    return
endfunction

command! -nargs=1 FindMate :call FindMate("<args>")

if !hasmapto('<Plug>FindMate')
    map <unique> ,, <Plug>FindMate
endif
noremap <unique><script> <Plug>FindMate :FindMate 

let &cpo = s:old_cpo
unlet s:old_cpo
