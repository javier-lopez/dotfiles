" paster.vim - send text to a web "pastebin".

" Copyright (c) 2009, Eugene Ciurana (pr3d4t0r)
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"     * Redistributions of source code must retain the above copyright
"       notice, this list of conditions, the URL http://eugeneciurana.com/paster.vim,
"       and the following disclaimer.
"     * Redistributions in binary form must reproduce the above copyright
"       notice, this list of conditions, the URL http://eugeneciurana.com/paster.vim,
"       and the following disclaimer in the documentation and/or other materials
"       provided with the distribution.
"     * Neither the name Eugene Ciurana, nor pr3d4t0r, nor the
"       names of its contributors may be used to endorse or promote products
"       derived from this software without specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY EUGENE CIURANA ''AS IS'' AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL EUGENE CIURANA BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"
"
" CONTRIBUTOR           EMAIL                         IRC /NICK
" ----------            -----                         ---------
" Eugene Ciurana        http://ciurana.eu/contact     pr3d4t0r
" Andrew Lombardi       http://www.mysticcoders.com   kinabalu
" Matt Wozniski         mjw@drexel.edu                godlygeek
" Will Gray             graywh@gmail.com              graywh
"
" Special thanks to stepnem, iamjay_, jerbear, and other denizens of the
" #vim channel (irc://irc.freenode.net/#vim)
"
" Version history:
" ----------------
" 20090425              1.1  Will Gray provided the configuration
"                            for using pastey.net with paster.vim
"
"                            Separated the configuration portion from
"                            the main script in paster-config.vim (EC)


" *** Begin Configuration ***
" 20090425 - EC - The configuration file is now in $HOME/.vim/plugin/paster-config.vim
" Both this script and the configuration file must be installed for this to work.
" *** End Configuration ***


" Exit early if curl isn't available.

if !executable(g:PASTER_COMMAND)
  finish
endif


" *** Utility functions ***

let s:reservedCharacters = [ '$', '&', '+', ',', '/', ':', ';', '=', '?', '@' ]
let s:unsafeCharacters   = [ '"', '<', '>', '#', '%', '{', '}', '|', '\', '^', '~', '[', ']', '`' ]


function! s:CharEncodeURL(aSymbol)
  let nSymbol = char2nr(a:aSymbol)

  " Non-printable characters first:
  if nSymbol <= 0x20 || nSymbol > 0x7f
    return printf("%%%02X", nSymbol)
  endif

  " Characters with special meaning to URL processors:
  if index(s:reservedCharacters, a:aSymbol) > -1 || index(s:unsafeCharacters, a:aSymbol) > -1
    return printf("%%%02X", nSymbol)
  endif

  return a:aSymbol
endfunction


function! s:StringEncodeURL(text)
  let allChars = split(a:text, '\zs')
  let retVal   = ""

  for cSymbol in allChars
    let retVal .= s:CharEncodeURL(cSymbol)
  endfor

  return retVal
endfunction


function! s:BuildCacheFrom(textAsList)
  " Experimental - this may not remain here for long.
  let fileName = tempname()

  call writefile(a:textAsList, fileName)

  return fileName
endfunction


function! s:ResolveTextFormat()
  return has_key(g:PASTER_SYNTAX_OPTIONS, &filetype)
           \ ? g:PASTER_SYNTAX_OPTIONS[&filetype]
           \ : g:PASTER_SYNTAX_OPTIONS['default']
endfunction


" For OS X users:

function! s:Paste2Clipboard(locator)
  if executable("pbcopy") && !has("gui_running")  " OS X
    call system("pbcopy", a:locator)
  endif

  if has("gui_running")
    let @+ = a:locator
  endif
endfunction


function! s:ExecutePaste(text)
  let command  = g:PASTER_COMMAND
  let command .= " ".g:PASTER_CONTROL
  let command .= " ".g:PASTER_FIXED_ARGUMENTS
  let command .= " ".g:PASTER_PAYLOAD
  let command .= " ".substitute(g:PASTER_NICK, "nickID", g:nickID, "g")
  let command .= " ".substitute(g:PASTER_FORMAT, "textFormat", s:ResolveTextFormat(), "g")
  let command .= " ".g:PASTER_URI

  let output   = split(system(command, g:PASTER_TEXT_AREA.'='.a:text), '\n')
  
  redraw

  for line in output
    let nPtr = match(line, g:PASTER_RESPONSE_FLAG)

    if nPtr != -1
      let location = g:Paster_ParseLocationFrom(line)
      echomsg location

      let clipboardURL = split(location, " ")
      call s:Paste2Clipboard(clipboardURL[0x01])

      return
    endif
  endfor

  echohl ErrorMsg
  echomsg "Paste failed!"
  echohl None
endfunction


" *** Main script function ***

function! Pastebin() range
  if (!exists('g:nickID'))
    let g:nickID = inputdialog("Enter your /nick or ID for this posting: ", "Anonymous")
  endif

  call s:ExecutePaste(s:StringEncodeURL(join(getline(a:firstline, a:lastline), "\n")))
endfunction


" Command to call the function:

com! -range=% -nargs=0 Pastebin :<line1>,<line2>call Pastebin()

