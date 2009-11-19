"Name: findMate
"Author: Manuel  Aguilar y Victor Guardiola
"Version: 0.1
"Description: Este plugin es buscador de archivos en todo un arbol de
"dirctorios
"
"suggested options:
"   g:FindMate_TotalResults = > Total number of results displayed
"   g:FindMate_verbose = > Flag option to confirm dialogs
"   * Search at first in the locate db (it's faster)
"   * Use vimgrep to search on windows systems
"   * Improve input parser, so it can select ranges, and lists (using commas
"   or any other simbol instance white spaces)

if &cp || exists("g:loaded_findMate")
 finish
endif

let s:old_cpo = &cpo
set cpo&vim

function! FindMate_vimgrep(_name)
    try
        silent execute g:FindMate_TotalResults. "vimgrep /\\%1l/j **/" .a:_name. "*"
    catch /E480:/
        let l:_name = substitute(a:_name, "*", " ", "g")
        echo "Your search -" .l:_name. "- did not match any documents"
        return
    endtry
    copen
endfunction

function! FindMate_locate(_name)
    let l:list = system("locate -e -b -i -n ".g:FindMate_TotalResults. " '*".a:_name.
                \"*' | perl -ne 'print \"$.\\t$_\"'")
    let l:num = strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        return [l:list, -1]
    else
        return [l:list, l:num]
    endif
endfunction

function! FindMate_find(_name)
    let l:list = system("find . -iname '*".a:_name."*' -not -name \"*.class\" -and 
                \-not -name \"*.swp\" -and -not -name \".*\" |head -"
                \.g:FindMate_TotalResults."| perl -ne 'print \"$.\\t$_\"'")
    let l:num = strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        return [l:list, -1]
    else
        return [l:list, l:num]
    endif
endfunction

function! FindMate(name)
    if (!exists('g:FindMate_TotalResults'))
        let g:FindMate_TotalResults = 15
    endif

    if (!exists('g:FindMate_verbose'))
        let g:FindMate_verbose = 0
    endif

    if g:FindMate_verbose
        echo "Searching '" .a:name. "':"
    endif

    let l:_name = substitute(a:name, "\\s", "*", "g")
    let s:running_windows = has("win16") || has("win32") || has("win64")

    if s:running_windows "This was the only way I could figure out to make it work :S
        call FindMate_vimgrep(_name)
        return
    else
        let l:list = FindMate_locate(_name)
        if (l:list[1] == -1)
            if g:FindMate_verbose
                echo "Your search -" .a:name. "- did not match any documents"
                let answer = input("\n\nWould you like to try using \"find\"
                            \(it could take extra-time)? (y/n): ", "y")
                if answer == "y"
                    redraw!
                    echo "Seaching '" .a:name. "' (this will be the last try):"
                    let l:list=FindMate_find(_name)
                    if (l:list[1] == -1) 
                        echo "Your search -" .a:name. "- did not match any documents"
                        return
                    endif
                else
                    return
                endif
            else
                let l:list = FindMate_find(_name)
                if (l:list[1] == -1) 
                    echo "Your search -" .a:name. "- did not match any documents"
                    return
                endif
            endif
        endif
    endif

    if (l:list[1] > 1)
        echo l:list[0]
        let l:input = input("Which ones (<enter>=nothing)? ")

        if strlen(l:input) == 0
            return
        endif

        "I think it could be great if we could use ranges (e.g. 1-5)
        "and commas (e.g. 1,2,5,7)
        let items = split(l:input, ' ', 1)

        for item in items
            if strlen(substitute(l:item, "[0-9]", "", "g"))>0
                echo "Not a number"
                return
            endif

            if l:item<1 || l:item>l:list[1]
                echo "Out of range"
                return
            endif

            let l:line = matchstr("\n".l:list[0], "\n".l:item."\t[^\n]*")
            "remove the number at start of the string
            let l:line = substitute(l:line, "^[^\t]*\t", "", "")
            "replaces white spaces with '\ '
            let l:line = substitute(l:line, "\\s", "\\\\ ", "g")
            "let l:line=substitute(l:line, '\s', '\\ ', "g")

            execute ":sp ".l:line
        endfor
    else
        let l:line = substitute(l:list[0], "^[^\t]*\t", "", "")
        let l:line = substitute(l:line, "\\s", "\\\\ ", "g")
        execute ":sp ".l:line
    endif
endfunction

command! -nargs=1 FindMate :call FindMate("<args>")
map ,, :FindMate 
let &cpo = s:old_cpo
unlet s:old_cpo
