" Vim plugin of vim script utilities
" Language:    vim script
" Maintainer:  Dave Silvia <dsilvia@mchsi.com>
" Date:        8/8/2004
"
" Version 1.4
" Date:        10/4/2004
"  Added:
"   -  g:VSUTIL, g:VSUTILMAJ, g:VSUTILMIN
" Version 1.3
" Date:        9/24/2004
"  Modified:
"   -  IsStrLit() now returns 1 for single
"      quotes and 2 for double quotes
"  New:
"   -  Added ExpandDosEnvVar()
"
" Version 1.2
" Date:        9/18/2004
"   New:
"    -  Added Substrmatch()
"    -  Added RelativePath()
"
" Version 1.1
"   New:
"    -  Added sorting from eval.txt example
"    -  Added Uniq()

let g:VSUTIL=1
let g:VSUTILMAJ=1
let g:VSUTILMIN=4

" turn off C in cpoptions to allow continuation lines
let s:saveCPO=&cpoptions
set cpoptions-=C

function! IsVimNmr(var)
	let l:omega=matchend(a:var,'^\%[0x]\d*')
	return ((match(a:var,'\%[0x]\d*$') <= l:omega) && (l:omega == strlen(a:var)))
endfunction

function! IsVimIdent(var)
	if match(a:var,'^\h\w*') != -1
		return 1
	endif
	return 0
endfunction

" returns 1 if valid and exists, -1 if valid and doesn't exist, 0 if not valid
function! IsVimVar(var)
	if IsVimIdent(a:var)
		if exists(a:var)
			return 1
		else
			return -1
		endif
	endif
	return 0
endfunction

function! IsStrLit(var)
	let sglQuote=match(a:var,"^'") != -1 && match(a:var,"'$") != -1
	let dblQuote=match(a:var,'^"') != -1 && match(a:var,'"$') != -1
	return sglQuote ? 1 : dblQuote ? 2 : 0
endfunction

" returns 1 if valid and exists, -1 if valid and doesn't exist, 0 if not valid
function! IsArrayDecl(decl)
	if match(a:decl,'^\(b\|w\|g\):\h\w*:\(\d*:\)*$') == 0
		if exists(a:decl)
			return 1
		else
			return -1
		endif
	endif
	return 0
endfunction

function! RGB2Hex(RGBNum)
	let hexdigitstr='0123456789abcdef'
	let hexStr=''
	let decNum=a:RGBNum
	while decNum > 15
		let divNum=decNum/16
		let hexStr=hexStr.strpart(hexdigitstr,divNum,1)
		let subNum=divNum*16
		let decNum=decNum-subNum
	endwhile
	let hexStr=hexStr.strpart(hexdigitstr,decNum,1)
	if strlen(hexStr) < 2
		let hexStr=hexStr.'0'
	endif
	return hexStr
endfunction

function! IsStrListTok(list,...)
	if a:0
		let s:isStrListTokDelim=a:1
	elseif exists("b:strListTokDelim")
		let s:isStrListTokDelim=b:strListTokDelim
	elseif exists("s:strListTokDelim")
		let s:isStrListTokDelim=s:strListTokDelim
	elseif exists("g:strListTokDelim")
		let s:isStrListTokDelim=g:strListTokDelim
	else
		let s:isStrListTokDelim="\<NL>\\+".'\|,\+'
	endif
	return match(a:list,s:isStrListTokDelim) != -1
endfunction

function! StrListTok(list,retList,...)
	let thisList=a:retList.'StrListTokCurList'
	let thisDelim=a:retList.'StrListTokCurDelim'
	if a:list != ''
		if a:0
			let {thisDelim}=a:1
		elseif exists("b:strListTokDelim")
			let {thisDelim}=b:strListTokDelim
		elseif exists("s:strListTokDelim")
			let {thisDelim}=s:strListTokDelim
		elseif exists("g:strListTokDelim")
			let {thisDelim}=g:strListTokDelim
		else
			let {thisDelim}="\<NL>\\+".'\|,\+'
		endif
		let tmp=a:list
		let tmp=substitute(tmp,'^\('.{thisDelim}.'\)','','')
		let tmp=substitute(tmp,'\('.{thisDelim}.'\)$','','')
		let {thisList}=tmp
	else
		if !exists(thisList)
			if exists(thisDelim)
				unlet {thisDelim}
			endif
			return ''
		endif
	endif
	let theMatch=match({thisList},{thisDelim})
	let theMatchEnd=matchend({thisList},{thisDelim})
	if theMatch != -1
		let tok=strpart({thisList},0,theMatch)
		let {thisList}=strpart({thisList},theMatchEnd)
		let {a:retList}={thisList}
	else
		let tok={thisList}
		let {a:retList}=''
		unlet {thisList} {thisDelim}
	endif
	return tok
endfunction

function! QualifiedPath(fileName)
	if !exists("b:QPATH")
		let b:QPATH='^\(\~\|\h:\|\\\|/\)'
	endif
	return !match(a:fileName,b:QPATH)
endfunction

function! FileParts(passedFile,full,path,file,name,ext)
	if a:file != '' | let {a:file}='' | endif
	if a:name != '' | let {a:name}='' | endif
	if a:ext != '' | let {a:ext}='' | endif
	if a:passedFile == '%' || a:passedFile == ''
		if a:full != '' | let {a:full}=expand("%:p") | endif
		if a:path != '' | let {a:path}=expand("%:p:h") | endif
		if a:file != '' | let {a:file}=expand("%:t") | endif
		if a:name != '' | let {a:name}=expand("%:t:r") | endif
		if a:ext != '' | let {a:ext}=".".expand("%:e") | endif
		return
	endif
	let fullname=expand(a:passedFile)
	if fullname == a:passedFile && !QualifiedPath(a:passedFile)
		if glob(expand("%:p:h").'/'.fullname) != ''
			if a:path != '' | let {a:path}=expand("%:p:h") | endif
			if a:full != '' | let {a:full}=expand({a:path}.'/'.fullname) | endif
		endif
	else
		if a:path != '' | let {a:path}=fnamemodify(fullname,":p:h") | endif
		if a:full != '' | let {a:full}=fullname | endif
	endif
	if glob(fullname) == ''
		if a:full != '' | let {a:full}='' | endif
		if a:path != '' | let {a:path}='' | endif
		return
	endif
	if a:file != '' | let {a:file}=fnamemodify(fullname,":t") | endif
	if a:name != '' | let {a:name}=fnamemodify(fullname,":t:r") | endif
	if a:ext != '' | let {a:ext}=fnamemodify(fullname,":e") | endif
	if a:ext != '' && {a:ext} != ''
		let {a:ext}=".".{a:ext}
	endif
endfunction


" Creates name variable for parent script
" execute outside of any functions in the parent script at load time
command! -nargs=0 SUDEBUGMSG let b:thisScript=expand("<sfile>:p:t")

" Toggles DEBUGMSG on and off
command! -nargs=0 TGLDEBUGMSG
	\ if !exists("b:DODEBUGMSG") | let b:DODEBUGMSG=1 | else | unlet b:DODEBUGMSG | endif

" Syntax: DEBUGMSG msg[,lvl]
"  where: msg is a single string
"         lvl is 0 for normal
"                1 for warning
"                > 1 for error
"                not specified is 0
" echomsg
" format: <script>::<function(s)>: <message>
"           in black for normal
"           red for warning
"           reverse red for error
command! -nargs=1 DEBUGMSG
\	if exists("b:DODEBUGMSG") |
\		call s:DebugMsg(b:thisScript,expand("<sfile>"),<args>) |
\	endif

function! s:DebugMsg(script,func,msg,...)
	if a:0
		if a:1 == 1
			echohl Warningmsg
		elseif a:1 > 1
			echohl Errormsg
		endif
	endif
	echomsg a:script."::".a:func.": ".a:msg
	echohl None
endfunction

function! Pause(args,...)
	echohl Comment
	if a:0
		execute 'echohl '.a:1 
	endif
	echo a:args
	echohl Cursor
	echo "          Press a key to continue"
	echohl None
	call getchar()
endfunction

command! -nargs=1 Gwin call s:gotoWin(<args>)
function! s:gotoWin(nr)
	if a:nr < 1 || winwidth(a:nr) == -1
		" non- existent
		return
	endif
	execute a:nr.'wincmd w'
endfunction

" Got this from eval.txt examples.  Pretty handy.

"Sorting lines (by Robert Webb) ~

"Here is a Vim script to sort lines.  Highlight the lines in Vim and type
":Sort".  This doesn't call any external programs so it'll work on any
"platform.  The function Sort() actually takes the name of a comparison
"function as its argument, like qsort() does in C.  So you could supply it
"with different comparison functions in order to sort according to date etc.
">
" Function for use with Sort(), to compare two strings.
function! Strcmp(str1, str2)
	if a:str1 < a:str2
		return -1
	elseif a:str1 > a:str2
		return 1
	else
		return 0
	endif
endfunction

" Sort lines.  SortR() is called recursively.
function! SortR(start, end, ...)
	if a:0
		let Comparator=a:1
	else
		let Comparator='Strcmp'
	endif
	if a:start >= a:end
		return
	endif
	let partition = a:start - 1
	let middle = partition
	let partStr = getline((a:start + a:end) / 2)
	let i = a:start
	while i <= a:end
		let str = getline(i)
		exec "let result = " . Comparator . "(str, partStr)"
		if result <= 0
			" Need to put it before the partition.  Swap lines i and partition.
			let partition = partition + 1
			if (result == 0)
				let middle = partition
			endif
			if (i != partition)
				let str2 = getline(partition)
				call setline(i, str2)
				call setline(partition, str)
			endif
		endif
		let i = i + 1
	endwhile

	" Now we have a pointer to the "middle" element, as far as partitioning
	" goes, which could be anywhere before the partition.  Make sure it is at
	" the end of the partition.
	if middle != partition
		let str = getline(middle)
		let str2 = getline(partition)
		call setline(middle, str2)
		call setline(partition, str)
	endif
	call SortR(a:start, partition - 1, Comparator)
	call SortR(partition + 1, a:end, Comparator)
endfunc

" To Sort a range of lines, pass the range to Sort() along with the name of a
" function that will compare two lines.
function! Sort(...) range
	if a:0
		let Comparator=a:1
	else
		let Comparator='Strcmp'
	endif
	call SortR(a:firstline, a:lastline, Comparator)
endfunc

" :Sort takes a range of lines and sorts them.
command! -nargs=0 -range Sort <line1>,<line2>call Sort("Strcmp")

function! Uniq(sline,eline)
	let eline=a:eline
	if eline > line('$')
		let eline=line('$')
	endif
	let cline=a:sline
	if cline < 1
		let cline=1
	endif
	if cline >= eline
		echoerr "Uniq(".a:sline.",".a:eline."): resolves to Uniq(".cline.",".eline.")"
		echoerr "First line must resolve to less than second"
		return
	endif
	execute "normal ".cline."G"
	while cline < eline
		if getline(cline) == getline(cline+1)
			normal dd
			let eline=eline-1
		else
			normal j
		endif
		let cline=line('.')
	endwhile
endfunction

" Find longest occurrence of str2 in str1
" Return results in offset and len.  If offset is -1, no match
" 2 optional arguments are starting offsets for str1 & str2
function! Substrmatch(str1,str2,offset,len,...)
	if a:0
		let str1Start=a:1
		if a:0 > 1
			let str2Start=a:2
		else
			let str2Start=0
		endif
	else
		let str1Start=0
		let str2Start=0
	endif
	let str1=strpart(a:str1,str1Start)
	let str1len=strlen(str1)
	let str2=strpart(a:str2,str2Start)
	let str2len=strlen(str2)
	let sublen=1
	let substr2=strpart(str2,0,sublen)
	let suboffset=stridx(str1,substr2)
	let lastoffset=-1
	while suboffset != -1 && sublen <= str1len && sublen <= str2len
		let sublen=sublen+1
		let substr2=strpart(str2,0,sublen)
		let lastoffset=suboffset
		let suboffset=stridx(str1,substr2)
	endwhile
	let {a:offset}=lastoffset+str1Start
	let {a:len}=sublen-1
endfunction

" Call with 2 arguments.
"   path1  path relative to
"   path2  path of file to be converted to relative
" E.G.:
"   let relPath=RelativePath('/foo/bar/baz','/foo/blah/whimsey')
" relPath is now '../../blah/whimsey'
" Also:
"   let relPath=RelativePath('/foo/bar/baz/hello.c','/foo/blah/whimsey')
" relPath is now '../../blah/whimsey'
function! RelativePath(path1,path2)
	if a:path1 == '.'
		let path1=getcwd()
	elseif a:path1 == '%'
		let path1=expand("%:p:h")
	else
		let path1=a:path1
	endif
	let path1=glob(path1)
	let path2=glob(a:path2)
	if path1 == '' || path2 == ''
		return ''
	endif
	let path1=fnamemodify(path1,":p")
	while !isdirectory(path1)
		let path1=fnamemodify(path1,":h")
	endwhile
	let path2=fnamemodify(path2,":p")
	let theTail=fnamemodify(path2,":t")
	if theTail == ''
		return ''
	endif
	let theHead=fnamemodify(path2,":h")
	if theHead == path1
		return expand('./'.theTail)
	endif
	if glob('c:/') != ''
		let path1=strpart(path1,2)
		let path2=strpart(path2,2)
	endif
	call Substrmatch(path1,path2,'b:offset','b:len')
	if b:offset == -1
		return ''
	endif
	let parentDir=strpart(path1,0,b:len)
	let parentLen=strlen(parentDir)-1
	if parentDir[parentLen] != '/' && parentDir[parentLen] != '\'
		let parentDir=expand(parentDir.'/')
	endif
	let path1Len=strlen(path1)-1
	if path1[path1Len] == '/' || path1[path1Len] == '\'
		let path1=strpart(path1,0,path1Len)
	endif
	let fname=strpart(path2,b:len)
	if (strpart(fname,1) == theTail || fname == theTail)
		\ && expand(path1.'/') == parentDir
		return expand('./'.theTail)
	endif
	while expand(path1.'/') != parentDir
		if path1 == '/' || path1 == '\'
			break
		endif
		let path1=fnamemodify(path1,":h")
		let fname="../".fname
	endwhile
	return expand(fname)
endfunction

" Returns DOS environment variables of the form %VARNAME% expanded.
" Can contain any number of variables in any string.
" If quoted, quotes are returned unless optional argument is included.
" If variable is not in the environment available to Vim, $VARNAME is
" returned.
function! ExpandDosEnvVar(str,...)
	if a:0
		if IsStrLit(a:str)
			let arglen=strlen(a:str)-2
			let str=strpart(a:str,1,arglen)
		else
			let str=a:str
		endif
	else
		let str=a:str
	endif
	let envVarStrt=match(str,'%\(\w*\)%')
	while envVarStrt != -1
		let envVarEnd=matchend(str,'%\(\w*\)%')
		let str=strpart(str,0,envVarStrt).expand(substitute(strpart(str,envVarStrt,envVarEnd-envVarStrt),'%\(\w*\)%','$\1','')).strpart(str,envVarEnd)
		let envVarStrt=match(str,'%\(\w*\)%')
	endwhile
	return str
endfunction

function! PadField(just,size,str,...)
	if a:0
		let pad=a:1
	else
		let pad=' '
	endif
	let len=strlen(a:str)
	if len >= a:size
		return ''
	endif
	let just=tolower(a:just[0])
	let just=just == 'l' ? -1 : just == 'r' ? 1 : 0
	let newstr=a:str
	while len < a:size
		if just == -1
			let newstr=newstr.pad
		elseif just == 1
			let newstr=pad.newstr
		else
			let newstr=newstr.pad
			let len=len+1
			if len < a:size
				let newstr=pad.newstr
			endif
		endif
		let len=len+1
	endwhile
	return newstr
endfunction

function! MaxCmdLines()
	let svch=&ch
	execute 'silent! set ch='.&lines
	let newch=&ch
	execute 'silent! set ch='.svch
	return newch
endfunction

let &cpoptions=s:saveCPO
