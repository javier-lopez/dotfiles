" Vim plugin for Vim Regular Expression Development
" Language:    vim script
" Maintainer:  Dave Silvia <dsilvia@mchsi.com>
" Date:        9/27/2004
"
" Version 1.1
" Date:        10/12/2004
"  Fixed:
"   - Problem with UNIX type
"     systems and have a single
"     quote in the filename for
"     the usage file.  Removed
"     the single quotes.
"
" Version 1.0
" Initial Release
" Date:        10/10/2004
" Beta 7
" Date:        10/7/2004
"  New:
"   - Added 'lookaround' anchor
"     highlighting per suggestion
"     by Jon Merz
"  Fixed:
"   - Couldn't use pattern beginning
"     with double quote because of
"     comment allowance.  Now prompts.
"     pointed out by Jon Merz
"   - Only highlights one pattern in
"     top window even if it is a sub
"     pattern of another pattern in the
"     window.
"
" Beta 6
" Date:        10/4/2004
"  Possible final beta release
"
" Beta 5
" Date:        10/2/2004
" Beta 5b
" Date:        10/2/2004
"  New:
"   -  Added expanded usage message
"      in a scrollable window
" Beta 5c
" Date:        10/2/2004
"  New:
"   -  Added highlight to current
"      selected pattern in top
"      window
"

let s:thisScript=expand("<sfile>:p")
let s:myName=fnamemodify(s:thisScript,":t")

if !exists('g:VSUTIL') || g:VSUTILMAJ < 1 || g:VSUTILMIN < 4
	silent! runtime plugin/vsutil.vim
	if !exists('g:VSUTIL') || g:VSUTILMAJ < 1 || g:VSUTILMIN < 4
		echohl Errormsg
		echomsg s:myName.": Requires Version 1.4 or higher of vsutil.vim"
		echomsg "Go to http://www.vim.org/account/profile.php?user_id=5397 for link to vsutil.vim"
		echohl None
		finish
	endif
endif

if exists('g:VimrexDebug')
	command! -nargs=1 VimrexDBG :if g:VimrexDebug | call append(line('$'),<args>) | endif
else
	command! -nargs=1 VimrexDBG :
endif

function! s:doGlobals()
if !exists("g:VimrexBrowseDir")
	let RTdirs=expand(&runtimepath)
	if !exists("*StrListTok")
		runtime plugin/vsutil.vim
	endif
	let RTdir=StrListTok(RTdirs,'b:rtdirs')
	while RTdir != ''
		if glob(RTdir) != ''
			let g:VimrexBrowseDir=RTdir
			break
		endif
		let RTdir=StrListTok('','b:rtdirs')
	endwhile
	while RTdir != ''
		let RTdir=StrListTok('','b:rtdirs')
	endwhile
	unlet b:rtdirs
	unlet! RTdir RTdirs
endif
if !exists("g:VimrexFileDir")
	let g:VimrexFileDir=fnamemodify(expand("~"),":p:h")
endif
if !exists("g:VimrexFile")
	let g:VimrexFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression Specification"),":p")
endif
if !exists("g:VimrexRsltFile")
	let g:VimrexRsltFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression Result"),":p")
endif
if !exists("g:VimrexSrcFile")
	let g:VimrexSrcFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression Search Source"),":p")
endif
if !exists("g:VimrexUsageFile")
	let g:VimrexUsageFile=fnamemodify(expand(g:VimrexFileDir."/.Vim Regular Expression The Fine Manual"),":p")
endif
if !exists("g:VimrexExec")
	let g:VimrexExec="ze"
endif
if !exists("g:VimrexAnlz")
	let g:VimrexAnlz="za"
endif
if !exists("g:VimrexTop")
	let g:VimrexTop="gt"
endif
if !exists("g:VimrexBtm")
	let g:VimrexBtm="gb"
endif
if !exists("g:VimrexCtr")
	let g:VimrexCtr="gc"
endif
if !exists("g:VimrexDSrc")
	let g:VimrexDSrc="zs"
endif
if !exists("g:VimrexDRslt")
	let g:VimrexDRslt="zr"
endif
if !exists("g:VimrexCLS")
	let g:VimrexCLS="zv"
endif
if !exists("g:VimrexRdSrc")
	let g:VimrexRdSrc="zS"
endif
if !exists("g:VimrexRdRex")
	let g:VimrexRdRex="zR"
endif
if !exists("g:VimrexExit")
	let g:VimrexExit="zx"
endif
if !exists("g:VimrexQQ")
	let g:VimrexQQ='z?'
endif
if !exists("g:VimrexQC")
	let g:VimrexQC='zc'
endif
if !exists("g:VimrexQP")
	let g:VimrexQP='zp'
endif
if !exists("g:VimrexQL")
	let g:VimrexQL='zl'
endif
if !exists("g:VimrexZHV")
	let g:VimrexZHV='zhv'
endif
if !exists("g:VimrexZHS")
	let g:VimrexZHS='zhs'
endif
if !exists("g:VimrexZHU")
	let g:VimrexZHU='zhu'
endif
if !exists("g:VimrexZHR")
	let g:VimrexZHR='zhr'
endif
if !exists("g:VimrexZHA")
	let g:VimrexZHA='zha'
endif
if !exists("g:VimrexZTV")
	let g:VimrexZTV='ztv'
endif
if !exists("g:VimrexZTS")
	let g:VimrexZTS='zts'
endif
if !exists("g:VimrexZTU")
	let g:VimrexZTU='ztu'
endif
if !exists("g:VimrexZTR")
	let g:VimrexZTR='ztr'
endif
if !exists("g:VimrexZTA")
	let g:VimrexZTA='zta'
endif

if !exists("g:VimrexSrchPatLnk")
	if !exists("g:VimrexSrchPatCFG")
		let g:VimrexSrchPatCFG='black'
	endif
	if !exists("g:VimrexSrchPatCBG")
		let g:VimrexSrchPatCBG='DarkMagenta'
	endif
	if !exists("g:VimrexSrchPatGFG")
		let g:VimrexSrchPatGFG='black'
	endif
	if !exists("g:VimrexSrchPatGBG")
		let g:VimrexSrchPatGBG='DarkMagenta'
	endif
endif

if !exists("g:VimrexSrchAncLnk")
	if !exists("g:VimrexSrchAncCFG")
		let g:VimrexSrchAncCFG='DarkRed'
	endif
	if !exists("g:VimrexSrchAncCBG")
		let g:VimrexSrchAncCBG='gray'
	endif
	if !exists("g:VimrexSrchAncGFG")
		let g:VimrexSrchAncGFG='DarkRed'
	endif
	if !exists("g:VimrexSrchAncGBG")
		let g:VimrexSrchAncGBG='gray'
	endif
endif

if !exists("g:VimrexSrchTokLnk")
	if !exists("g:VimrexSrchTokCBG")
		let g:VimrexSrchTokCBG='LightCyan'
	endif
	if !exists("g:VimrexSrchTokCFG")
		let g:VimrexSrchTokCFG='black'
	endif
	if !exists("g:VimrexSrchTokGBG")
		let g:VimrexSrchTokGBG='LightCyan'
	endif
	if !exists("g:VimrexSrchTokGFG")
		let g:VimrexSrchTokGFG='black'
	endif
endif

if !exists("g:VimrexSrchCgpLnk")
	if !exists("g:VimrexSrchCgpCFG")
		let g:VimrexSrchCgpCFG='blue'
	endif
	if !exists("g:VimrexSrchCgpCBG")
		let g:VimrexSrchCgpCBG='red'
	endif
	if !exists("g:VimrexSrchCgpGFG")
		let g:VimrexSrchCgpGFG='blue'
	endif
	if !exists("g:VimrexSrchCgpGBG")
		let g:VimrexSrchCgpGBG='red'
	endif
endif

if !exists("g:VimrexSrchGrpLnk")
	if !exists("g:VimrexSrchGrpCFG")
		let g:VimrexSrchGrpCFG='red'
	endif
	if !exists("g:VimrexSrchGrpCBG")
		let g:VimrexSrchGrpCBG='blue'
	endif
	if !exists("g:VimrexSrchGrpGFG")
		let g:VimrexSrchGrpGFG='red'
	endif
	if !exists("g:VimrexSrchGrpGBG")
		let g:VimrexSrchGrpGBG='blue'
	endif
endif

if !exists("g:VimrexSrchChcLnk")
	if !exists("g:VimrexSrchChcCFG")
		let g:VimrexSrchChcCFG='black'
	endif
	if !exists("g:VimrexSrchChcCBG")
		let g:VimrexSrchChcCBG='LightBlue'
	endif
	if !exists("g:VimrexSrchChcGFG")
		let g:VimrexSrchChcGFG='black'
	endif
	if !exists("g:VimrexSrchChcGBG")
		let g:VimrexSrchChcGBG='LightBlue'
	endif
endif

if !exists("g:VimrexSrchExpLnk")
	if !exists("g:VimrexSrchExpCFG")
		let g:VimrexSrchExpCFG='black'
	endif
	if !exists("g:VimrexSrchExpCBG")
		let g:VimrexSrchExpCBG='LightGreen'
	endif
	if !exists("g:VimrexSrchExpGFG")
		let g:VimrexSrchExpGFG='black'
	endif
	if !exists("g:VimrexSrchExpGBG")
		let g:VimrexSrchExpGBG='LightGreen'
	endif
endif

if !exists("g:VimrexFilePatLnk")
	if !exists("g:VimrexFilePatCFG")
		let g:VimrexFilePatCFG='cyan'
	endif
	if !exists("g:VimrexFilePatCBG")
		let g:VimrexFilePatCBG='brown'
	endif
	if !exists("g:VimrexFilePatGFG")
		let g:VimrexFilePatGFG='cyan'
	endif
	if !exists("g:VimrexFilePatGBG")
		let g:VimrexFilePatGBG='brown'
	endif
endif
endfunction " s:doGlobals()

function! s:undoGlobals()
	unlet! g:VimrexBrowseDir g:VimrexFileDir g:VimrexFile g:VimrexRsltFile g:VimrexSrcFile g:VimrexUsageFile
	unlet! g:VimrexExec g:VimrexAnlz g:VimrexTop g:VimrexBtm g:VimrexCtr g:VimrexDSrc g:VimrexDRslt g:VimrexCLS
	unlet! g:VimrexRdSrc g:VimrexRdRex g:VimrexExit g:VimrexQQ g:VimrexQC g:VimrexQP g:VimrexQL g:VimrexZHV
	unlet! g:VimrexZHS g:VimrexZHU g:VimrexZHR g:VimrexZHA g:VimrexZTV g:VimrexZTS g:VimrexZTU g:VimrexZTR
	unlet! g:VimrexZTA g:VimrexSrchPatLnk g:VimrexSrchPatCFG g:VimrexSrchPatCBG g:VimrexSrchPatGFG
	unlet! g:VimrexSrchPatGBG g:VimrexSrchAncLnk g:VimrexSrchAncCFG g:VimrexSrchAncCBG g:VimrexSrchAncGFG
	unlet! g:VimrexSrchAncGBG g:VimrexSrchTokLnk g:VimrexSrchTokCBG g:VimrexSrchTokCFG g:VimrexSrchTokGBG
	unlet! g:VimrexSrchTokGFG g:VimrexSrchCgpLnk g:VimrexSrchCgpCFG g:VimrexSrchCgpCBG g:VimrexSrchCgpGFG
	unlet! g:VimrexSrchCgpGBG g:VimrexSrchGrpLnk g:VimrexSrchGrpCFG g:VimrexSrchGrpCBG g:VimrexSrchGrpGFG
	unlet! g:VimrexSrchGrpGBG g:VimrexSrchChcLnk g:VimrexSrchChcCFG g:VimrexSrchChcCBG g:VimrexSrchChcGFG
	unlet! g:VimrexSrchChcGBG g:VimrexSrchExpLnk g:VimrexSrchExpCFG g:VimrexSrchExpCBG g:VimrexSrchExpGFG
	unlet! g:VimrexSrchExpGBG g:VimrexFilePatLnk g:VimrexFilePatCFG g:VimrexFilePatCBG g:VimrexFilePatGFG
	unlet! g:VimrexFilePatGBG
endfunction " s:undoGlobals()

function! s:gotoWin(which)
	execute bufwinnr(a:which).'wincmd w'
endfunction

function! s:browser(which)
	if has("gui_running") && has("browse")
		let fullname=browse(0,'Read File Into '.a:which,g:VimrexBrowseDir,'')
	else
		let fname=input("File name: ")
		let fullname=glob(fname)
		if fullname == ''
			let fullname=g:VimrexBrowseDir.'/'.fname
			if glob(fullname) == ''
				echohl Errormsg
				echomsg "Cannot find ".fname
				edhohl None
			endif
		endif
	endif
	if fullname == ''
		return
	endif
	call s:saveCurrent()
	execute bufwinnr(a:which).'wincmd w'
	let lnr=line('.')
	if lnr == 1
		let ans=input("This is the buffer's first line, insert Above or Below? : ","A")
		if tolower(ans[0]) == 'a'
			let lnr=0
		endif
	endif
	execute ':'.lnr.'r '.fullname
	set nomodified
	call s:restoreCurrent()
endfunction

function! s:generate(which,type)
	if a:which == 'ALLBUTUSAGE'
		call s:saveCurrent()
		call s:generate(g:VimrexFile,a:type)
		call s:generate(g:VimrexRsltFile,a:type)
		call s:generate(g:VimrexSrcFile,a:type)
		let tmpFile=fnamemodify(expand(g:VimrexFileDir.'/.Vim Regular Expression All'),":p")
		new
		if a:type == 'HTML'
			execute 'silent! edit! '.g:VimrexFile.'.html'
			execute line('$').'r '.g:VimrexRsltFile.'.html'
			execute line('$').'r '.g:VimrexSrcFile.'.html'
			execute 'silent! :w! '.tmpFile.'.html'
		else
			execute 'silent! edit! '.g:VimrexFile.'.txt'
			execute line('$').'r '.g:VimrexRsltFile.'.txt'
			call append(line('$'),' ')
			execute line('$').'r '.g:VimrexSrcFile.'.txt'
			execute 'silent! :w! '.tmpFile.'.txt'
		endif
		bd
		call s:restoreCurrent()
		return
	endif
	let whichBufNr=bufwinnr(a:which)
	if whichBufNr == -1
		echohl Errormsg
		echomsg "No open window for ".a:which
		echohl None
		return
	endif
	call s:saveCurrent()
	execute whichBufNr.'wincmd w'
	if a:type == 'HTML'
		runtime syntax/2html.vim
		silent! :w!
		bd
	else
		silent! :w! %.txt
	endif
	call s:restoreCurrent()
endfunction

function! s:adjustWin(which,how)
	let whichBufNr=bufwinnr(a:which)
	if whichBufNr == -1
		return
	endif
	if a:how == 'p'
		execute whichBufNr.'wincmd w'
		execute 'resize '.&lines
		return
	endif
	let usageBuf=bufwinnr(g:VimrexUsageFile)
	let tot=&lines-&ch
	let winNr=1
	execute 'let winexists=winwidth('.winNr.')'
	while winexists != -1
		let winNr=winNr+1
		execute 'let winexists=winwidth('.winNr.')'
	endwhile
	let winNr=winNr-1
	let tot=tot-winNr
	if usageBuf != -1
		let tot=tot-2
		let fullWins=winNr-2
		let thisWin=2
	else
		let tot=tot-1
		let fullWins=winNr-1
		let thisWin=1
	endif
	let size=tot/fullWins
	wincmd =
	if usageBuf != -1
		1wincmd w
		resize 1
	endif
	while thisWin < winNr
		execute thisWin.'wincmd w'
		execute 'resize '.size
		let thisWin=thisWin+1
	endwhile
	execute winNr.'wincmd w'
	resize 1
endfunction

function! s:closeUsage()
	let usageBuf=bufwinnr(g:VimrexUsageFile)
	if usageBuf != -1
		execute usageBuf."wincmd w"
		close
	endif
endfunction

let s:inlegend=0

function! s:legend()
	if s:inlegend
		return
	else
		let s:inlegend=1
	endif
	call s:saveCurrent()
	let legendWinNr=bufwinnr('Legend')
	if legendWinNr == -1
		new
		edit Legend
		set noreadonly modifiable
		call append(0,"plain search  capture  non-capture  choice  expansion  lookaround  non-current")
		syntax match VimrexSearchCgp "capture"
		syntax match VimrexSearchGrp "non-capture"
		syntax match VimrexSearchChc "choice"
		syntax match VimrexSearchExp "expansion"
		syntax match VimrexSearchAnchor "lookaround"
		syntax match VimrexSearchToken "plain search"
		syntax match VimrexSearchPattern "non-current"
		normal dd
	endif
	let winNr=1
	execute 'let winExists=winheight('.winNr.') != -1'
	while winExists
		let winNr=winNr+1
		execute 'let winExists=winheight('.winNr.') != -1'
	endwhile
	let winNr=winNr-1
	if winNr == legendWinNr && winheight(legendWinNr) == 1
		let s:inlegend=0
		return
	endif
	execute legendWinNr.'wincmd w'
	wincmd J
	call s:adjustWin('Legend','c')
	set nomodified noswapfile nonumber readonly modifiable
	call s:restoreCurrent()
	let s:inlegend=0
endfunction

function! s:doGvimMenu()
	execute 'amenu <silent> &Vimrex.&Execute\ Regular\ Expression<TAB>'.g:VimrexExec.' :call <SID>execRegex()<CR>'
	execute 'amenu <silent> &Vimrex.&Analyze\ Regular\ Expression<TAB>'.g:VimrexAnlz.' :call TranslateRegex()<CR>'
	execute 'amenu <silent> &Vimrex.&Window.Goto.(&Top)\ Regular\ Expression\ Specification\ Window<TAB>'.g:VimrexTop.' :call <SID>gotoWin(g:VimrexFile)<CR>'
	execute 'amenu <silent> &Vimrex.&Window.Goto.(&Bottom)\ Regular\ Expression\ Search\ Source\ Window<TAB>'.g:VimrexBtm.' :call <SID>gotoWin(g:VimrexSrcFile)<CR>'
	execute 'amenu <silent> &Vimrex.&Window.Goto.(&Center)\ Regular\ Expression\ Result\ Window<TAB>'.g:VimrexCtr.' :call <SID>gotoWin(g:VimrexRsltFile)<CR>'
	execute 'amenu <silent> &Vimrex.&Window.&Clear.\.&Vim\ Regular\ Expression\ Specification\ Window<TAB>'.g:VimrexCLS.' :call <SID>cls(g:VimrexFile)<CR>' 
	execute 'amenu <silent> &Vimrex.&Window.&Clear.\.Vim\ Regular\ Expression\ &Result\ Window<TAB>'.g:VimrexDRslt.' :call <SID>cls(g:VimrexRsltFile)<CR>' 
	execute 'amenu <silent> &Vimrex.&Window.&Clear.\.Vim\ Regular\ Expression\ Search\ &Source\ Window<TAB>'.g:VimrexDSrc.' :call <SID>cls(g:VimrexSrcFile)<CR>' 
	if has("browse")
		execute 'amenu <silent> &Vimrex.&Window.&Read\ File\ Into.\.Vim\ Regular\ Expression\ Search\ &Source\ Window<TAB>'.g:VimrexRdSrc.' :call <SID>browser(g:VimrexSrcFile)<CR>'
		execute 'amenu <silent> &Vimrex.&Window.&Read\ File\ Into.\.Vim\ &Regular\ Expression\ Specification\ Window<TAB>'.g:VimrexRdRex.' :call <SID>browser(g:VimrexFile)<CR>'
	endif
	execute 'amenu <silent> &Vimrex.&Usage.&Open<TAB>'.g:VimrexQQ.' :call <SID>usage()<CR>'
	execute 'amenu <silent> &Vimrex.&Usage.C&lose<TAB>'.g:VimrexQL.' :call <SID>closeUsage()<CR>'
	execute 'amenu <silent> &Vimrex.&Usage.&Collapse<TAB>'.g:VimrexQC.' :call <SID>adjustWin(g:VimrexUsageFile,"c")<CR>'
	execute 'amenu <silent> &Vimrex.&Usage.Ex&pand<TAB>'.g:VimrexQP.' :call <SID>adjustWin(g:VimrexUsageFile,"p")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Regular\ Expressions<TAB>'.g:VimrexZHV.' :call <SID>generate(g:VimrexFile,"HTML")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Search\ Source<TAB>'.g:VimrexZHS.' :call <SID>generate(g:VimrexSrcFile,"HTML")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Usage<TAB>'.g:VimrexZHU.' :call <SID>generate(g:VimrexUsageFile,"HTML")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&Results<TAB>'.g:VimrexZHR.' :call <SID>generate(g:VimrexRsltFile,"HTML")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&HTML.&All\ But\ Usage<TAB>'.g:VimrexZHA.' :call <SID>generate("ALLBUTUSAGE","HTML")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Regular\ Expressions<TAB>'.g:VimrexZTV.' :call <SID>generate(g:VimrexFile,"TEXT")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Search\ Source<TAB>'.g:VimrexZTS.' :call <SID>generate(g:VimrexSrcFile,"TEXT")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Usage<TAB>'.g:VimrexZTU.' :call <SID>generate(g:VimrexUsageFile,"TEXT")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&Results<TAB>'.g:VimrexZTR.' :call <SID>generate(g:VimrexRsltFile,"TEXT")<CR>'
	execute 'amenu <silent> &Vimrex.&Generate\ File.&TEXT.&All\ But\ Usage<TAB>'.g:VimrexZTA.' :call <SID>generate("ALLBUTUSAGE","TEXT")<CR>'
	execute 'amenu <silent> &Vimrex.E&xit<TAB>'.g:VimrexExit.' :call <SID>isVimrexRunning(g:VimRexUserCalled)<CR>'
endfunction

function! s:doMap(name,val)
	let sname='s:prev'.a:name
	let siname='s:iprev'.a:name
	let gname='g:Vimrex'.a:name
	let {sname}=maparg({gname})
	let {siname}=maparg({gname},'i')
	execute 'map <silent> '.{gname}.' '.a:val.'<CR>'
	execute 'imap <silent> '.{gname}.' <Esc>'.a:val.'<CR>'
endfunction

function! s:doUnMap(name)
	let sname='s:prev'.a:name
	let siname='s:iprev'.a:name
	let gname='g:Vimrex'.a:name
	execute 'unmap '.{gname}
	execute 'iunmap '.{gname}
	if {sname} != ''
		let {sname}=substitute({sname},'|','|','g')
		execute 'map '.{gname}.' '.{sname}
	endif
	if {siname} != ''
		let {siname}=substitute({siname},'|','|','g')
		execute 'imap '.{gname}.' '.{siname}
	endif
endfunction

function! s:isVimrexRunning(file)
	if !exists("g:VimrexRunning")
		return
	endif
	if a:file != g:VimrexFile && a:file != g:VimrexRsltFile && a:file != g:VimrexSrcFile && a:file != g:VimRexUserCalled
		return
	endif
	unlet g:VimrexRunning g:VimRexUserCalled
augroup Vimrex
	autocmd!
augroup END
	if has("gui_running")
		aunmenu &Vimrex
	endif
	let winNr=bufwinnr(g:VimrexFile)
	execute winNr.'wincmd w'
	silent! :w
	execute 'bwipeout '.bufnr(g:VimrexFile)
	let winNr=bufwinnr(g:VimrexRsltFile)
	execute winNr.'wincmd w'
	set nomodified
	execute 'bwipeout '.bufnr(g:VimrexRsltFile)
	call s:delFile(g:VimrexRsltFile)
	let winNr=bufwinnr(g:VimrexSrcFile)
	execute winNr.'wincmd w'
	silent! :w
	execute 'bwipeout '.bufnr(g:VimrexSrcFile)
	let winNr=bufwinnr(g:VimrexUsageFile)
	if winNr != -1
		execute winNr.'wincmd w'
		set nomodified
		execute 'bwipeout '.bufnr(g:VimrexUsageFile)
		call s:delFile(g:VimrexUsageFile)
	endif
	let winNr=bufwinnr('Legend')
	execute winNr.'wincmd w'
	set nomodified
	execute 'bwipeout '.bufnr('Legend')
	let @/=s:pattern
	let &hlsearch=s:saveHLS
	let &ch=s:saveCH
	let &syntax=s:saveSyn
	let &cpoptions=s:saveCPO
	call s:doUnMap('DRslt')
	call s:doUnMap('DSrc')
	call s:doUnMap('CLS')
	call s:doUnMap('QQ')
	call s:doUnMap('QC')
	call s:doUnMap('QP')
	call s:doUnMap('QL')
	call s:doUnMap('ZHV')
	call s:doUnMap('ZHS')
	call s:doUnMap('ZHU')
	call s:doUnMap('ZHR')
	call s:doUnMap('ZHA')
	call s:doUnMap('ZTV')
	call s:doUnMap('ZTS')
	call s:doUnMap('ZTU')
	call s:doUnMap('ZTR')
	call s:doUnMap('ZTA')
	call s:doUnMap('Exec')
	call s:doUnMap('Anlz')
	call s:doUnMap('Top')
	call s:doUnMap('Btm')
	call s:doUnMap('Ctr')
	call s:doUnMap('RdSrc')
	call s:doUnMap('RdRex')
	call s:doUnMap('Exit')
	highlight clear VimrexSearchAnchor
	highlight clear VimrexSearchPattern
	highlight clear VimrexSearchToken
	highlight clear VimrexFilePattern
	syntax clear VimrexSearchAnchor
	syntax clear VimrexSearchPattern
	syntax clear VimrexSearchToken
	if exists("g:VimRegEx")
		call s:undoGlobals()
		:qa!
	endif
	call s:undoGlobals()
endfunction

command! -nargs=0 Vimrex call s:Vimrex()
command! -nargs=0 VimRegEx  if has("gui_running") | execute ':silent! :!gvim -c "let g:VimRegEx=1" -c Vimrex' | else | execute ':silent! :!vim -c "let g:VimRegEx=1" -c Vimrex' | endif

" Vimrex initialization function
function! s:Vimrex()
	call s:doGlobals()
augroup Vimrex
	autocmd!
	autocmd VimLeavePre,VimLeave,BufDelete * call s:isVimrexRunning(expand("<afile>"))
	autocmd WinLeave,WinEnter,BufDelete,BufWinEnter,BufWinLeave * call s:legend()
augroup END
	let s:saveSyn=&syntax
	let s:pattern=@/
	let s:saveHLS=&hlsearch
	let s:saveCH=&ch
	let s:saveCPO=&cpoptions
	let s:AanchorPat=''
	let s:BanchorPat=''
	set cpoptions-=C
	set ch=3
	set nohlsearch
	let @/=''
	let g:VimrexRunning=1
	let g:VimRexUserCalled=nr2char(21).nr2char(19).nr2char(5).nr2char(18).nr2char(3).nr2char(1).nr2char(12).nr2char(12).nr2char(5).nr2char(4)
	if getline(1) !~ '^\%$'
		new
	endif
	if has("gui_running")
		call s:doGvimMenu()
		if has("gui_win32")
			tearoff &Vimrex
		elseif has("gui_gtk")
			popup &Vimrex
		endif
	endif
	execute 'edit! '.escape(g:VimrexSrcFile,' ')
	if getline(1) =~ '^\%$'
		call s:doSampleSrc()
	endif
	setlocal nomodified noswapfile nobackup nowritebackup nonumber syntax= filetype=
	call s:delFile(g:VimrexRsltFile)
	execute 'split '.escape(g:VimrexRsltFile,' ')
	setlocal noswapfile nobackup nowritebackup nonumber syntax= filetype=
	execute 'split! '.escape(g:VimrexFile,' ')
	if getline(1) =~ '^\%$'
		call s:doSampleRegex()
	endif
	setlocal nomodified noswapfile nobackup nowritebackup nonumber syntax=vim filetype=vim
	if exists("g:VimrexSrchPatLnk")
		execute 'highlight link VimrexSearchPattern '.g:VimrexSrchPatLnk
	else
		execute 'highlight VimrexSearchPattern ctermfg='.g:VimrexSrchPatCFG.' ctermbg='.g:VimrexSrchPatCBG.' guifg='.g:VimrexSrchPatGFG.' guibg='.g:VimrexSrchPatGBG
	endif
	if exists("g:VimrexSrchAncLnk")
		execute 'highlight link VimrexSearchAnchor '.g:VimrexSrchAncLnk
	else
		execute 'highlight VimrexSearchAnchor ctermfg='.g:VimrexSrchAncCFG.' ctermbg='.g:VimrexSrchAncCBG.' guifg='.g:VimrexSrchAncGFG.' guibg='.g:VimrexSrchAncGBG
	endif
	if exists("g:VimrexSrchTokLnk")
		execute 'highlight link VimrexSearchToken '.g:VimrexSrchTokLnk
	else
		execute 'highlight VimrexSearchToken ctermfg='.g:VimrexSrchTokCFG.' ctermbg='.g:VimrexSrchTokCBG.' guifg='.g:VimrexSrchTokGFG.' guibg='.g:VimrexSrchTokGBG
	endif
	if exists("g:VimrexSrchCgpLnk")
		execute 'highlight link VimrexSearchCgp '.g:VimrexSrchCgpLnk
	else
		execute 'highlight VimrexSearchCgp ctermfg='.g:VimrexSrchCgpCFG.' ctermbg='.g:VimrexSrchCgpCBG.' guifg='.g:VimrexSrchCgpGFG.' guibg='.g:VimrexSrchCgpGBG
	endif
	if exists("g:VimrexSrchGrpLnk")
		execute 'highlight link VimrexSearchGrp '.g:VimrexSrchGrpLnk
	else
		execute 'highlight VimrexSearchGrp ctermfg='.g:VimrexSrchGrpCFG.' ctermbg='.g:VimrexSrchGrpCBG.' guifg='.g:VimrexSrchGrpGFG.' guibg='.g:VimrexSrchGrpGBG
	endif
	if exists("g:VimrexSrchChcLnk")
		execute 'highlight link VimrexSearchChc '.g:VimrexSrchChcLnk
	else
		execute 'highlight VimrexSearchChc ctermfg='.g:VimrexSrchChcCFG.' ctermbg='.g:VimrexSrchChcCBG.' guifg='.g:VimrexSrchChcGFG.' guibg='.g:VimrexSrchChcGBG
	endif
	if exists("g:VimrexSrchExpLnk")
		execute 'highlight link VimrexSearchExp '.g:VimrexSrchExpLnk
	else
		execute 'highlight VimrexSearchExp ctermfg='.g:VimrexSrchExpCFG.' ctermbg='.g:VimrexSrchExpCBG.' guifg='.g:VimrexSrchExpGFG.' guibg='.g:VimrexSrchExpGBG
	endif
	if exists("g:VimrexFilePatLnk")
		execute 'highlight link VimrexFilePattern '.g:VimrexFilePatLnk
	else
		execute 'highlight VimrexFilePattern ctermfg='.g:VimrexFilePatCFG.' ctermbg='.g:VimrexFilePatCBG.' guifg='.g:VimrexFilePatGFG.' guibg='.g:VimrexFilePatGBG
	endif
	call s:doMap('Exec',':call <SID>execRegex()')
	call s:doMap('Anlz',':call TranslateRegex()')
	call s:doMap('Top',':call <SID>gotoWin(g:VimrexFile)')
	call s:doMap('Btm',':call <SID>gotoWin(g:VimrexSrcFile)')
	call s:doMap('Ctr',':call <SID>gotoWin(g:VimrexRsltFile)')
	call s:doMap('CLS',':call <SID>cls(g:VimrexFile)')
	call s:doMap('DSrc',':call <SID>cls(g:VimrexSrcFile)')
	call s:doMap('DRslt',':call <SID>cls(g:VimrexRsltFile)')
	call s:doMap('RdSrc',':call <SID>browser(g:VimrexSrcFile)')
	call s:doMap('RdRex',':call <SID>browser(g:VimrexFile)')
	call s:doMap('QQ',':call <SID>usage()')
	call s:doMap('QC',':call <SID>adjustWin(g:VimrexUsageFile,"c")')
	call s:doMap('QP',':call <SID>adjustWin(g:VimrexUsageFile,"p")')
	call s:doMap('QL',':call <SID>closeUsage()')
	call s:doMap('ZHV',':call <SID>generate(g:VimrexFile,"HTML")')
	call s:doMap('ZHS',':call <SID>generate(g:VimrexSrcFile,"HTML")')
	call s:doMap('ZHU',':call <SID>generate(g:VimrexUsageFile,"HTML")')
	call s:doMap('ZHR',':call <SID>generate(g:VimrexUsageFile,"HTML")')
	call s:doMap('ZHA',':call <SID>generate("ALLBUTUSAGE","HTML")')
	call s:doMap('ZTV',':call <SID>generate(g:VimrexFile,"TEXT")')
	call s:doMap('ZTS',':call <SID>generate(g:VimrexSrcFile,"TEXT")')
	call s:doMap('ZTU',':call <SID>generate(g:VimrexUsageFile,"TEXT")')
	call s:doMap('ZTR',':call <SID>generate(g:VimrexUsageFile,"TEXT")')
	call s:doMap('ZTA',':call <SID>generate("ALLBUTUSAGE","TEXT")')
	call s:doMap('Exit',':call <SID>isVimrexRunning(g:VimRexUserCalled)')
endfunction

function! s:doSampleRegex()
	call append(0,s:sampleRegex1)
	let nr=2
	normal G
	normal dd
	while nr < 29
		call append('$',s:sampleRegex{nr})
		let nr=nr+1
	endwhile
endfunction

function! s:doSampleSrc()
	call append(0,s:sampleSrc1)
	let nr=2
	normal G
	normal dd
	while nr < 18
		call append('$',s:sampleSrc{nr})
		let nr=nr+1
	endwhile
endfunction

function! s:patHilite(pat,grp,...)
	let thePat=''
	if a:0
		let thePat='\%'.a:1.'l'
		if a:0 > 1
			let thePat=thePat.'\&\%'.a:2.'c'
		endif
	endif
	let thePat=thePat.'\%('.escape(a:pat[0],'\[^*$~"').'\)'
	let idx=1
	let lidx=strlen(a:pat)
	while idx < lidx
		let theGrp='\%('.escape(a:pat[idx],'\[^*$~"').'\)'
		let thePat=thePat.theGrp.'\@='.theGrp
		let idx=idx+1
	endwhile
	execute 'syntax match '.a:grp.' "'.thePat.'"'
	syntax sync fromstart
endfunction

function! s:getAnchors(pat)
	let pat=a:pat
	let s:BanchorPat=''
	let s:AanchorPat=''
	let matchPos=match(pat,'\\@\%[<][=!]')
	let anchorStr=matchstr(pat,'\\@\%[<][=!]')
	while matchPos != -1
		let idx=matchPos-1
		let found=0
		while idx >= 0 && !found
			if pat[idx] == '\*' && pat[idx-1] != '\'
				let idx=idx-1
				continue
			endif
			if pat[idx] == '}' && pat[idx-1] != '\'
				let idx=idx-1
				let tmpPat=strpart(pat,idx)
				while match(tmpPat,'\{') != 0
					let idx=idx-1
					let tmpPat=strpart(pat,idx)
				endwhile
				if match(tmpPat,'\{') == 0
					let idx=idx-1
					continue
				endif
			endif
			if pat[idx] =~ ')' && pat[idx-1] == '\'
				let idx=idx-2
				while pat[idx] != '('
					let idx=idx-1
				endwhile
				if pat[idx] =~ '(' && pat[idx-1] == '\' && pat[idx-2] != '\'
					let idx=idx-1
					let found=1
				endif
				if pat[idx] == '(' && pat[idx-1] == '%' && pat[idx-2] == '\' && pat[idx-3] != '\'
					let idx=idx-2
					let found=1
				endif
			endif
			let found=1
		endwhile
		if match(anchorStr,'<') != -1
			if s:BanchorPat == ''
				let s:BanchorPat=strpart(pat,idx,matchPos-idx)
			else
				let s:BanchorPat=s:BanchorPat."\<NL>".strpart(pat,idx,matchPos-idx)
			endif
		else
			if s:AanchorPat == ''
				let s:AanchorPat=strpart(pat,idx,matchPos-idx)
			else
				let s:AanchorPat=s:AanchorPat."\<NL>".strpart(pat,idx,matchPos-idx)
			endif
		endif
		let pat=strpart(pat,matchPos+2)
		let matchPos=match(pat,'\\@')
		let anchorStr=matchstr(pat,'\\@\%[<][=!]')
	endwhile
endfunction

let s:grp=''
let s:capgrp=''
let s:choice=''
let s:expansion=''
let s:class=''
let s:grpOpen='\\(\|\\%(\|\\%[\|[:\@!'
let s:grpClose='\\)\|]'

function! s:parsePat(pat)
	let s:grp=''
	let s:capgrp=''
	let s:choice=''
	let s:expansion=''
	let idx=0
	let lidx=strlen(a:pat)
	while idx < lidx
		let restPat=strpart(a:pat,idx)
		let firstPat=strpart(a:pat,0,idx)
		let atomIdx=0
		if match(restPat,s:grpOpen) == 0
			let opengrp=matchstr(restPat,s:grpOpen)
			let atomIdx=strlen(matchstr(restPat,s:grpOpen))
			let ingroup=1
			while ingroup && restPat[atomIdx] != ''
				let tmpPat=strpart(restPat,atomIdx)
				if match(tmpPat,s:grpOpen) == 0 && restPat[atomIdx-1] != '\'
					let atomIdx=strlen(matchstr(tmpPat,s:grpOpen))+atomIdx
					let ingroup=ingroup+1
				elseif match(tmpPat,s:grpClose) == 0 && restPat[atomIdx-1] != '\'
					if tmpPat[0] == ']'
						if restPat[atomIdx-1] == ':' && restPat[atomIdx-2] != '\'
							let atomIdx=atomIdx+1
							continue
						endif
					endif
					let closegrp=matchstr(tmpPat,s:grpClose)
					let closepos=atomIdx
					let atomIdx=strlen(matchstr(tmpPat,s:grpClose))+atomIdx
					let afterpos=atomIdx
					let ingroup=ingroup-1
				else
					let atomIdx=atomIdx+1
				endif
			endwhile
			if !ingroup
				let tmpPat=strpart(restPat,atomIdx)
				let modMatch=match(tmpPat,'\*\|\\[+?=]\|\\@\%[<][!=]\|\\{\%[-]\%[+]\d*\%[,]\d*}')
				if modMatch == 0
					let modStr=matchstr(tmpPat,'\*\|\\[+?=]\|\\@\%[<][!=]\|\\{\%[-]\%[+]\d*\%[,]\d*}')
					let atomIdx=atomIdx+strlen(modStr)
				endif
			endif
			let theGrp=strpart(restPat,0,atomIdx)
			let restPat=strpart(restPat,atomIdx)
			if firstPat != ''
				let theGrp='\%('.firstPat.'\)\@<=\%('.theGrp.'\)'
			else
				let theGrp='\%('.theGrp.'\)'
			endif
			if restPat != ''
				let theGrp=theGrp.'\%('.restPat.'\)\@='
			endif
			if opengrp == '\('
				let targetGrp='s:capgrp'
			elseif opengrp == '\%('
				let targetGrp='s:grp'
			elseif opengrp == '\%['
				let targetGrp='s:expansion'
			else
				let targetGrp='s:choice'
			endif
			let thisGrp=StrListTok({targetGrp},'g:grpList',"\<NL>")
			let found=0
			while thisGrp != ''
				if thisGrp ==# theGrp
					let found=1
					while thisGrp != ''
						let thisGrp=StrListTok('','g:grpList')
					endwhile
				endif
				let thisGrp=StrListTok('','g:grpList')
			endwhile
			unlet! g:grpList
			if !found
				let {targetGrp}={targetGrp}.theGrp."\<NL>"
			endif
		endif
		if atomIdx
			let idx=idx+atomIdx-1
		else
			let idx=idx+1
		endif
	endwhile
endfunction

let s:hit=0
let s:lline=1
let s:lpat=''
let s:rline=0

function! s:execRegex()
	let caller=winnr()
	execute bufwinnr(g:VimrexFile).'wincmd w'
	let pattern=getline('.')
	if pattern == ''
		echohl Errormsg
		echomsg "No search pattern specified"
		echohl None
		execute caller.'wincmd w'
		return
	endif
	let sameregex=(s:rline == line('.') && s:lpat ==# pattern)
	if !sameregex
		if match(pattern,'\s*"') == 0
			echohl Warningmsg
			let ans=input("This could be a comment line, execute? ","n")
			echohl None
			if tolower(ans[0]) == 'n'
				execute caller.'wincmd w'
				return
			endif
		endif
		syntax clear VimrexFilePattern
		let s:rline=line('.')
		let s:lpat=pattern
		call s:patHilite(pattern,'VimrexFilePattern',s:rline)
		let @/=pattern
		call s:parsePat(pattern)
		if match(pattern,'\\@') != -1
			call s:getAnchors(pattern)
		else
			let s:BanchorPat=''
			let s:AanchorPat=''
		endif
	endif
	execute bufwinnr(g:VimrexSrcFile).'wincmd w'
	let v:errmsg=''
	silent! normal n
	if v:errmsg != ''
		execute bufwinnr(g:VimrexRsltFile).'wincmd w'
		normal gg
		call append(line('.'),">>".pattern."<< search error: ".v:errmsg)
		setlocal nomodified
		echohl Errormsg
		echomsg ">>".pattern."<< search error: ".v:errmsg
		echohl None
		execute bufwinnr(g:VimrexSrcFile).'wincmd w'
		execute caller.'wincmd w'
		return
	endif
	syntax clear VimrexSearchAnchor
	syntax clear VimrexSearchPattern
	syntax clear VimrexSearchToken
	syntax clear VimrexSearchCgp
	syntax clear VimrexSearchGrp
	syntax clear VimrexSearchChc
	syntax clear VimrexSearchExp
	let lnum=line('.')
	let cnum=col('.')
	let sline=getline('.')
	let matchPos=cnum-1
	if cnum == 1
		if lnum == 1
			call cursor(line('$'),col('$'))
			call cursor(line('$'),col('$'))
		else
			call cursor(lnum-1,col('$'))
			call cursor(lnum-1,col('$'))
		endif
	else
		call cursor(lnum,cnum-1)
	endif
	execute "silent! normal //e\<CR>"
	let matchEnd=col('.')
	let s:hit=s:hit+1
	if lnum < s:lline
		let s:hit=1
	endif
	let s:lline=lnum
	let token=strpart(sline,matchPos,matchEnd-matchPos)
	if s:BanchorPat != ''
		let thisAnchor=StrListTok(s:BanchorPat,'b:anchors',"\<NL>")
		while thisAnchor != ''
			let matchAnchor=match(sline,thisAnchor)
			while matchAnchor != -1
				let matchAnchorEnd=matchend(sline,thisAnchor,matchAnchor)
				if matchAnchorEnd == matchPos
					let cnum=matchAnchor+1
					execute 'syntax match VimrexSearchAnchor	"\%'.lnum.'l\&\%'.cnum.'c'.escape(thisAnchor,'"').'"'
					break
				endif
				let matchAnchor=match(sline,thisAnchor,matchAnchor+1)
			endwhile
			let thisAnchor=StrListTok('','b:anchors')
		endwhile
		unlet b:anchors
	endif
	if s:AanchorPat != ''
		let thisAnchor=StrListTok(s:AanchorPat,'b:anchors',"\<NL>")
		while thisAnchor != ''
			let tokenLen=strlen(token)
			let matchAnchor=match(strpart(sline,matchPos+tokenLen),thisAnchor)
			if matchAnchor != -1
				let cnum=matchAnchor+matchPos+tokenLen+1
				if cnum == (matchEnd+1)
					execute 'syntax match VimrexSearchAnchor	"\%'.lnum.'l\&\%'.cnum.'c'.escape(thisAnchor,'"').'"'
				endif
			endif
			let thisAnchor=StrListTok('','b:anchors')
		endwhile
		unlet b:anchors
	endif
	execute 'syntax match VimrexSearchPattern	"'.escape(pattern,'"').'" contains=VimrexSearchToken'
	let cnum=matchPos+1
	execute 'syntax match VimrexSearchToken	"\%'.lnum.'l\&\%'.cnum.'c'.escape(token,'~"\[]*').'" contained contains=VimrexSearchCgp,VimrexSearchGrp,VimrexSearchChc,VimrexSearchExp'
	call s:hiliteGrp(s:capgrp,'VimrexSearchCgp',lnum,matchPos)
	call s:hiliteGrp(s:grp,'VimrexSearchGrp',lnum,matchPos)
	call s:hiliteGrp(s:choice,'VimrexSearchChc',lnum,matchPos)
	call s:hiliteGrp(s:expansion,'VimrexSearchExp',lnum,matchPos)
	syntax sync fromstart
	execute bufwinnr(g:VimrexRsltFile).'wincmd w'
	normal gg
	call append(line('.'),s:hit.": Length=".strlen(token).", at line #".lnum.", column #".cnum)
	call append(line('.'),s:hit.": Token: >>".token."<<")
	call append(line('.'),s:hit.": Found: >>".pattern."<<")
	setlocal nomodified
	execute bufwinnr(g:VimrexSrcFile).'wincmd w'
	call cursor(lnum,cnum)
	execute caller.'wincmd w'
endfunction

function! s:hiliteGrp(which,synGrp,lnum,matchPos)
	let sline=getline(a:lnum)
	let grp=StrListTok(a:which,'g:VimrexHLgrp',"\<NL>")
	while grp != ''
		let strt=0
		let grpTokStrt=match(sline,grp,strt)
		while grpTokStrt != -1
			let grpTok=matchstr(sline,grp,strt)
			if grpTok != ''
				let grpTokEnd=strlen(grpTok)+grpTokStrt
				let grpCnum=1+grpTokStrt
				execute 'syntax match '.a:synGrp.'	"\%'.a:lnum.'l\&\%'.grpCnum.'c'.escape(grpTok,'~"\[]*').'" contained'
			else
				let grpTokEnd=grpTokStrt+1
			endif
			let strt=grpTokEnd
			let grpTokStrt=match(sline,grp,strt)
		endwhile
		let grp=StrListTok('','g:VimrexHLgrp')
	endwhile
	unlet! g:VimrexHLgrp
endfunction

function! s:saveCurrent()
	let s:cWin=winnr()
	let s:cBuf=bufnr('')
	let s:clnum=line('.')
	let s:ccnum=col('.')
endfunction

function! s:restoreCurrent()
	if winnr() != s:cWin
		execute s:cWin.'wincmd w'
	endif
	execute 'b'.s:cBuf
	call cursor(s:clnum,s:ccnum)
endfunction

function! s:cls(which)
	if a:which == g:VimrexFile || a:which == g:VimrexSrcFile
		let ans=confirm("Clear ".a:which,"&Ok\n&Cancel",1)
		if ans == 0 || ans == 2
			return
		endif
	endif
	call s:saveCurrent()
	execute bufwinnr(a:which).'wincmd w'
	normal gg
	normal ma
	normal G
	silent normal d'a
	set nomodified
	call s:restoreCurrent()
	if a:which == g:VimrexFile
		let @/=''
	endif
endfunction

function! s:delFile(fname)
	let fname=glob(a:fname)
	if fname == ''
		return
	endif
	let failure=delete(fname)
	if !failure
		return
	endif
	echohl Warningmsg
	echomsg expand("<sfile>").": Could not delete <".fname.">"
	echomsg "Reason: ".v:errmsg
	echohl Cursor
	echomsg "        Press a key to continue"
	echohl None
	call getchar()
endfunction

function! TranslateRegex(...)
	let doLocal=!a:0
	if doLocal
		execute bufwinnr(g:VimrexFile).'wincmd w'
		let s:pat=getline('.')
		if s:pat == ''
			echohl Errormsg
			echomsg "No search pattern specified"
			echohl None
			return
		endif
		let sameregex=(s:rline == line('.') && s:lpat ==# s:pat)
		if !sameregex
			if match(s:pat,'\s*"') == 0
				echohl Warningmsg
				let ans=input("This could be a comment line, execute? ","n")
				echohl None
				if tolower(ans[0]) == 'n'
					return
				endif
			endif
			syntax clear VimrexFilePattern
			let s:rline=line('.')
			let s:lpat=s:pat
			call s:patHilite(s:pat,'VimrexFilePattern',s:rline)
			let @/=s:pat
			call s:parsePat(s:pat)
			if match(s:pat,'\\@') != -1
				call s:getAnchors(s:pat)
			else
				let s:BanchorPat=''
				let s:AanchorPat=''
			endif
			execute bufwinnr(g:VimrexSrcFile).'wincmd w'
			syntax clear VimrexSearchAnchor
			syntax clear VimrexSearchPattern
			syntax clear VimrexSearchToken
			syntax clear VimrexSearchCgp
			syntax clear VimrexSearchGrp
			syntax clear VimrexSearchChc
			syntax clear VimrexSearchExp
		endif
		execute bufwinnr(g:VimrexRsltFile).'wincmd w'
		let b:pat=s:pat
		unlet s:pat
		normal G
		call append(line('$'),'Analyzing pattern: '.b:pat)
		setlocal nomodified
		normal j
		execute "normal z\<CR>"
	else
		let b:pat=a:1
		echomsg 'Analyzing pattern: '.b:pat
	endif
	while b:pat != ''
		let desc=s:getTokDesc(b:pat,'b:foundPat','b:pat')
		let pad=''
		if s:ingroup
			let indents=s:ingroup
			if match(b:foundPat,'^\%(\\(\|\\%(\|[\|\\%[\):\@!') != -1
				let indents=indents-1
			endif
			while indents
				let spaces=&sw
				while spaces
					let pad=pad.' '
					let spaces=spaces-1
				endwhile
				let indents=indents-1
			endwhile
		endif
		if doLocal
			call append(line('$'),pad.b:foundPat.'  >>:'.desc)
			setlocal nomodified
		else
			echomsg pad.b:foundPat.'  >>:'.desc
		endif
	endwhile
	unlet! b:pat b:foundPat
	if doLocal
		execute bufwinnr(g:VimrexFile).'wincmd w'
	endif
endfunction

function! s:repeatAtomDesc(qualifier)
	let qualifier=a:qualifier
	if qualifier == '' || match(qualifier,'\d*,\d*') != -1 || match(qualifier,'\%(+\|-\)') != -1
		let qualify=match(qualifier,'-') != -1 ? 'few as possible "lazy"' : 'all possible "greedy"'
		if qualify[0] == 'f'
			let qualifier=strpart(qualifier,1)
		endif
		let theDesc=qualify.' match'
		if qualifier != ''
			let commaPos=match(qualifier,',')
			let low=strpart(qualifier,0,commaPos)
			let high=strpart(qualifier,commaPos+1)
			if low != ''
				let theDesc=theDesc.' from '.low
			else
				let theDesc=theDesc.' from 0'
			endif
			if high != ''
				let theDesc=theDesc.' to '.high.' of previous atom'
			else
				let theDesc=theDesc.' to maximum of previous atom'
			endif
		else
			let theDesc=theDesc.' of 0 or more of previous atom'
		endif
	else
		let theDesc='exactly '.qualifier.' of previous atom'
	endif
	return theDesc
endfunction

function! s:charClassDesc(class)
	let theClass=StrListTok(s:charClass,'b:charClass',"\<NL>")
	let found=0
	while theClass != '' && !found
		if theClass ==# a:class
			let theDesc=StrListTok('','b:charClass')
			while StrListTok('','b:charClass') != ''
			endwhile
			let found=1
			break
		endif
		let theClass=StrListTok('','b:charClass')
	endwhile
	unlet b:charClass
	if !found
		let theDesc='Unknown class'
	endif
	return theDesc
endfunction

function! s:getTokDesc(pat,thePat,retPat)
	let idx=0
	let lidx=strlen(a:pat)
	let found=0
	let opener=matchstr(a:pat,'^\%(\\(\|\\%(\|[\|\\%[\):\@!')
	if opener != ''
		let s:ingroup=s:ingroup+1
	endif
	let closer=matchstr(a:pat,'^\%(\\)\|]\):\@!')
	if closer != ''
		let s:ingroup=s:ingroup-1
		if closer == ']'
			if s:inChoice
				let s:inChoice=0
			elseif s:inExpansion
				let s:inExpansion=0
			endif
		endif
	endif
	let matchPos=match(a:pat,'\%(\[:\)\@<=\%(\a\+\%(:]\)\@=\)')
	if matchPos == 2
		let matchEnd=matchend(a:pat,'\%(\[:\)\@<=\%(\a\+\%(:]\)\@=\)')
		let qualifier='[:'.matchstr(a:pat,'\%(\[:\)\@<=\%(\a\+\%(:]\)\@=\)').':]'
		let {a:retPat}=strpart(a:pat,matchEnd+2)
		let {a:thePat}=strpart(a:pat,0,matchEnd+2)
		return s:charClassDesc(qualifier)
	endif
	if s:inExpansion && a:pat[0] != ']' && a:pat[0] != '[' && a:pat[0] != '\'
		let matchPos=match(a:pat,'\%(]\|[\|\\\)')
		if a:pat[matchPos] == ']'
			let s:inExpansion=0
		endif
		let {a:retPat}=strpart(a:pat,matchPos)
		let thePat=strpart(a:pat,0,matchPos)
		let {a:thePat}=thePat
		return 'literal character(s): >>'.substitute(thePat,'\%(\\\)\%(\\\|-\)\@=','','g').'<<'
	endif
	if s:inChoice && a:pat[0] != ']'
		let matchPos=match(a:pat,'\%(]\|\[:\)')
		if a:pat[matchPos] == ']'
			let s:inChoice=0
		endif
		let {a:retPat}=strpart(a:pat,matchPos)
		let thePat=strpart(a:pat,0,matchPos)
		let {a:thePat}=thePat
		return 'literal character(s): >>'.substitute(thePat,'\%(\\\)\%(\\\|-\)\@=','','g').'<<'
	endif
	let matchPos=match(a:pat,'\%(\\{\)\@<=\%(\%(\%(-\|+\)\?\d*,\?\d*\)}\@=\)')
	if matchPos == 2
		let matchEnd=matchend(a:pat,'\%(\\{\)\@<=\%(\%(\%(-\|+\)\?\d*,\?\d*\)}\@=\)')
		let qualifier=matchstr(a:pat,'\%(\\{\)\@<=\%(\%(\%(-\|+\)\?\d*,\?\d*\)}\@=\)')
		let {a:retPat}=strpart(a:pat,matchEnd+1)
		let {a:thePat}=strpart(a:pat,0,matchEnd+1)
		return s:repeatAtomDesc(qualifier)
	endif
	if a:pat[0] == '\' && a:pat[1] =~ '\d'
		let matchBeg=match(a:pat,'\d\+',1)
		let matchEnd=matchend(a:pat,'\d\+',1)
		let {a:retPat}=strpart(a:pat,matchEnd)
		let theNum=strpart(a:pat,1,matchEnd)
		let {a:thePat}='\'.theNum
		let theDesc="back reference to capture group ".theNum." in this pattern"
		return theDesc
	endif
	if a:pat[0] == '\'
		if match(s:VimRegExTokBS1stChar,a:pat[1]) == -1 || a:pat[1] == '.'
			let idx=2
			while match(s:VimRegExTokOpen,escape(a:pat[idx],'$~.^')) == -1
				let idx=idx+1
			endwhile
			let {a:retPat}=strpart(a:pat,idx)
			let {a:thePat}=strpart(a:pat,0,idx)
			return 'literal character(s): >>'.strpart(a:pat,1,idx-1).'<<'
		endif
	endif
	if match(s:VimRegExTokOpen,escape(a:pat[0],'$~^*.')) == -1
		let idx=idx+1
		while match(s:VimRegExTokOpen,escape(a:pat[idx],'$~.^')) == -1
			let idx=idx+1
		endwhile
		let {a:retPat}=strpart(a:pat,idx)
		let {a:thePat}=strpart(a:pat,0,idx)
		return 'literal character(s): >>'.strpart(a:pat,0,idx).'<<'
	endif
	if match(a:pat,'^\\%[') != -1
		let s:inExpansion=1
	endif
	if a:pat[0] == '['
		let s:inChoice=1
		if a:pat[1] == '^'
			let {a:retPat}=strpart(a:pat,2)
			let {a:thePat}='[^'
			return 'begin disallowed choice list'
		else
			let {a:retPat}=strpart(a:pat,1)
			let {a:thePat}='['
			return 'begin allowed choice list'
		endif
	endif
	while idx < lidx && !found
		let thisPat=StrListTok(s:VimRegExTokDesc,'b:thisTokDescList',"\<NL>")
		let matchPat=strpart(a:pat,0,idx+1)
		while thisPat != ''
			let theDesc=StrListTok('','b:thisTokDescList')
			if matchPat ==# '^'
				let thisPat='^'
				let theDesc='begin line'
				while StrListTok('','b:thisTokDescList') != ''
				endwhile
				let found=1
				break
			endif
			if matchPat ==# thisPat
				while StrListTok('','b:thisTokDescList') != ''
				endwhile
				let found=1
				break
			endif
			let thisPat=StrListTok('','b:thisTokDescList')
		endwhile
		let idx=idx+1
	endwhile
	if thisPat == ''
		let {a:retPat}=''
		let {a:thePat}=a:pat
		unlet! b:thisTokDescList
		return 'literal character(s): >>'.a:pat.'<<'
	endif
	let {a:retPat}=strpart(a:pat,idx)
	let {a:thePat}=thisPat
	unlet! b:thisTokDescList
	return theDesc
endfunction

if exists('loaded_regex_token_descriptions')
	finish
endif
let loaded_regex_token_descriptions=1
let s:VimRegExTokBS1stChar='%|&+<=>?@ACDFHIKLMOPSUVWXZ_abcdefhiklmnoprstuvwxz()\'

let s:ingroup=0
let s:inChoice=0
let s:inExpansion=0
let s:charClass=
\"
\[:alnum:]\<NL>
\letters and decimal digits\<NL>
\[:alpha:]\<NL>
\letters\<NL>
\[:blank:]\<NL>
\space and tab\<NL>
\[:cntrl:]\<NL>
\control\<NL>
\[:digit:]\<NL>
\decimal digits\<NL>
\[:graph:]\<NL>
\printable except space\<NL>
\[:lower:]\<NL>
\lowercase\<NL>
\[:print:]\<NL>
\printable including space\<NL>
\[:punct:]\<NL>
\punctuation\<NL>
\[:space:]\<NL>
\whitespace\<NL>
\[:upper:]\<NL>
\uppercase\<NL>
\[:xdigit:]\<NL>
\hexadecimal digits\<NL>
\[:return:]\<NL>
\carriage return (non-POSIX)\<NL>
\[:tab:]\<NL>
\tab (non-POSIX)\<NL>
\[:escape:]\<NL>
\esc (non-POSIX)\<NL>
\[:backspace:]\<NL>
\bs (non-POSIX)"

let s:VimRegExTokOpen='$\\~^*.[]'
let s:VimRegExTokDesc="
			\$\<NL>
			\end of line\<NL>
			\*\<NL>
			\0 or more of previous atom\<NL>
			\.\<NL>
			\any but newline\<NL>
			\]\<NL>
			\end choice list or expansion sequence\<NL>
			\\\%[\<NL>
			\begin expansion sequence\<NL>
			\\\%$\<NL>
			\end of file or string\<NL>
			\\\&\<NL>
			\previous atom and next atom are required together ('and')\<NL>
			\\\|\<NL>
			\previous atom and next atom are alternate choices ('or')\<NL>
			\\\(\<NL>
			\begin capture group\<NL>
			\\\)\<NL>
			\end group\<NL>
			\\\%(\<NL>
			\begin non-capture group\<NL>
			\\\)\<NL>
			\end group\<NL>
			\\\%^\<NL>
			\start of file or string\<NL>
			\\\+\<NL>
			\1 or more of previous atom\<NL>
			\\\<\<NL>
			\begin word boundary\<NL>
			\\\=\<NL>
			\0 or 1 of previous atom\<NL>
			\\\>\<NL>
			\end word boundary\<NL>
			\\\?\<NL>
			\0 or 1 of previous atom\<NL>
			\\\@!\<NL>
			\negative lookahead== previous atom present ? no match : match\<NL>
			\\\@<!\<NL>
			\negative lookbehind== previous atom present ? no match : match\<NL>
			\\\@<=\<NL>
			\positive lookbehind== previous atom present ? match : no match\<NL>
			\\\@=\<NL>
			\positive lookahead== previous atom present ? match : no match\<NL>
			\\\@>\<NL>
			\'grab all' independent subexpression\<NL>
			\\\A\<NL>
			\non-alpha\<NL>
			\\\C\<NL>
			\match case\<NL>
			\\\D\<NL>
			\non-digit (decimal)\<NL>
			\\\F\<NL>
			\non-filename non-digit (decimal)\<NL>
			\\\H\<NL>
			\non-head of word (alpha or _)\<NL>
			\\\I\<NL>
			\non-identifier non-digit (decimal)\<NL>
			\\\K\<NL>
			\non-keyword non-digit (decimal)\<NL>
			\\\L\<NL>
			\non-lowercase\<NL>
			\\\M\<NL>
			\magic off for following\<NL>
			\\\O\<NL>
			\non-digit (octal)\<NL>
			\\\P\<NL>
			\printable non-digit (decimal)\<NL>
			\\\S\<NL>
			\non-whitespace\<NL>
			\\\U\<NL>
			\non-uppercase\<NL>
			\\\V\<NL>
			\very magic off for following\<NL>
			\\\W\<NL>
			\non-word (alpha or decimal or _)\<NL>
			\\\X\<NL>
			\non-digit (hex)\<NL>
			\\\Z\<NL>
			\ignore Unicode combine diff\<NL>
			\\\_\<NL>
			\following and newline\<NL>
			\\\_$\<NL>
			\end of line (anywhere)\<NL>
			\\\_.\<NL>
			\single char or end of line\<NL>
			\\\_^\<NL>
			\start of line (anywhere)\<NL>
			\\\a\<NL>
			\alpha\<NL>
			\\\b\<NL>
			\backspace <BS>\<NL>
			\\\c\<NL>
			\ignore case\<NL>
			\\\d\<NL>
			\digit (decimal)\<NL>
			\\\e\<NL>
			\escape <Esc>\<NL>
			\\\f\<NL>
			\filename\<NL>
			\\\h\<NL>
			\head of word (alpha or _)\<NL>
			\\\i\<NL>
			\identifier\<NL>
			\\\k\<NL>
			\keyword\<NL>
			\\\l\<NL>
			\lowercase\<NL>
			\\\m\<NL>
			\magic on for following\<NL>
			\\\n\<NL>
			\newline (possibly combination)\<NL>
			\\\o\<NL>
			\digit (octal)\<NL>
			\\\p\<NL>
			\printable\<NL>
			\\\r\<NL>
			\carriage return <CR>\<NL>
			\\\s\<NL>
			\whitespace <Space> or <Tab>\<NL>
			\\\t\<NL>
			\tab <Tab>\<NL>
			\\\u\<NL>
			\uppercase\<NL>
			\\\v\<NL>
			\very magic on for following\<NL>
			\\\w\<NL>
			\word (alpha or decimal or _)\<NL>
			\\\x\<NL>
			\digit (hex)\<NL>
			\\\ze\<NL>
			\previous atom is end of whole match\<NL>
			\\\zs\<NL>
			\following is start of whole match\<NL>
			\~\<NL>
			\last given substitute
			\"

let s:sampleRegex1='\w\+'
let s:sampleRegex2='[[:punct:]]\+'
let s:sampleRegex3='\%(ABC\|abc\)\@<=\(DEF\|def\)\%(GHIJ\|ghij\)\@='
let s:sampleRegex4='\%(ABC\|abc\)\@<=\%(DEF\|def\)\%(GHIJ\|ghij\)\@='
let s:sampleRegex5='\%(ABC\|abc\)\@<=DEF\|def\%(GHIJ\|ghij\)\@='
let s:sampleRegex6='" Any alpha sequence as long as it is followed by a non-vowel'
let s:sampleRegex7='[[:alpha:]]\+\([^aeiouAEIOU]\)\@='
let s:sampleRegex8='" A regex for email address'
let s:sampleRegex9='\<[A-Za-z0-9._%-]\+@[A-Za-z0-9._%-]\+\.[A-Za-z]\{2,4}\>'
let s:sampleRegex10='" Another regex for email address'
let s:sampleRegex11='\<[[:alnum:]._%-]\+@[._%\-[:alnum:]]\+\.[[:alpha:]]\{2,4}\>'
let s:sampleRegex12='" Yet another regex for email address'
let s:sampleRegex13='\<\%(\w\|[.%-]\)\+@\%(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex14='\<\(\w\|[.%-]\)\+@\(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex15='\<\%(\w\|[.%-]\)\+@\(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex16='\<\(\w\|[.%-]\)\+@\%(\w\|[.%-]\)\+\.\w\{2,4}\>'
let s:sampleRegex17='" RTFM or Read The Fine Manual'
let s:sampleRegex18='R\%[ead\s]T\%[he\s]F\%[ine\s]M\%[anual]'
let s:sampleRegex19='" This allows anything printable after the "F"; or even unprintable!;)'
let s:sampleRegex20='R\%[ead]\s*T\%[he]\s*F\p\{-}\s*M\%[anual]'
let s:sampleRegex21='" Even more flexibility'
let s:sampleRegex22='R\%[ea[[:alpha:]]]\s\{-}T\%[he]\s\{-}F\p\{-}\s\{-}M\%[anu]\a*'
let s:sampleRegex23='R\%[ea\a]\s\{-}T\%[he]\s\{-}F\p\{-}\s\{-}M\%[anu]\a*'
let s:sampleRegex24='R\%[ea\a\a]\s\{-}T\%[he]\s\{-}F\p\{-}\s\{-}M\%[anu]\a*'
let s:sampleRegex25='" Hmm...'
let s:sampleRegex26='\%(\<\)\@<=\%([A-Za-z0-9._%-]\+\)\%(@[A-Za-z0-9._%-]\+\.[A-Za-z]\{2,4}\>\)\@='
let s:sampleRegex27='\%(\<[A-Za-z0-9._%-]\+@\)\@<=\%([A-Za-z0-9._%-]\+\)\%(\.[A-Za-z]\{2,4}\>\)\@='
let s:sampleRegex28='\%(\<[A-Za-z0-9._%-]\+@[A-Za-z0-9._%-]\+\.\)\@<=\%([A-Za-z]\{2,4}\)\%(\>\)\@='

let s:sampleSrc1='1 2 3 4 five six seven 8910'
let s:sampleSrc2=" !\"#$%&'()*+,-./0123456789:;<=>?"
let s:sampleSrc3='@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'
let s:sampleSrc4='`abcdefghijklmnopqrstuvwxyz{|}'
let s:sampleSrc5=' ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿'
let s:sampleSrc6='ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß'
let s:sampleSrc7='àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ'
let s:sampleSrc8='JoeValachi@crime.org'
let s:sampleSrc9='LegsDiamond@crime.org'
let s:sampleSrc10='BillGates@crime.org'
let s:sampleSrc11='RTFM'
let s:sampleSrc12='Read The Fine Manual'
let s:sampleSrc13='Read The Formidable Manual'
let s:sampleSrc14='Read The Facinating Manual'
let s:sampleSrc15='Read The Finished Manuscript'
let s:sampleSrc16='Reap The Future Manufacturing Benefits'
let s:sampleSrc17='Reach The Final Manufacture Phase'

function s:doUsageSyntax()
	syntax match VimrexUsageDesc '\p*' contains=VimrexUsageTitle,VimrexUsageSketch,VimrexUsageEmph,VimrexUsageHotkey,VimrexSearchPattern,VimrexFilePattern,VimrexSearchToken,VimrexSearchCgp,VimrexSearchGrp,VimrexSearchChc,VimrexSearchAnchor,VimrexSearchExp
	syntax match VimrexFilePattern "current regex"
	syntax match VimrexSearchToken "plain search"
	syntax match VimrexSearchCgp "capture"
	syntax match VimrexSearchGrp "non-capture"
	syntax match VimrexSearchChc "choice"
	syntax match VimrexSearchExp "expansion"
	syntax match VimrexSearchAnchor "lookaround"
	syntax match VimrexSearchPattern "non-current"
	syntax match VimrexUsageTitle ": Vim Regular Expression Developer Plugin"
	syntax match VimrexUsageTitle ": Synopsis of Use"
	syntax match VimrexUsageTitle ": Command Summary"
	syntax match VimrexUsageTitle ": Global Variables"
	syntax match VimrexUsageTitle ": Pattern and Match Highlighting"
	syntax match VimrexUsageTitle ": Generating Files"
	syntax match VimrexUsageTitle ": Contact Information"
	syntax match VimrexUsageSketch '+\|-\||'
	syntax match VimrexUsageEmph '[Rr]egular [Ee]xpression\%[s]'
	syntax match VimrexUsageEmph '[Ss]earch\%[e[sd]]'
	syntax match VimrexUsageEmph '[Ee]xecut\%(e\%[d]\|ion\|ing\)'
	syntax match VimrexUsageEmph '[Aa]nalys[ei]s'
	syntax match VimrexUsageEmph '[Aa]nalyze\%[[ds]]'
	syntax match VimrexUsageEmph '[Aa]nalyzing'
	syntax match VimrexUsageEmph '[Rr]esult\%[s]'
	syntax match VimrexUsageEmph '[Tt]ext'
	syntax match VimrexUsageEmph '[Mm]atch\%[ing]'
	syntax match VimrexUsageEmph '[Mm]atche[ds]'
	syntax match VimrexUsageEmph '\%[reverse ][Hh]ighlight\%(s\|ed\|ing\)'
	syntax match VimrexUsageEmph '[Tt]oken\%[s]'
	syntax match VimrexUsageEmph 'NOTE:'
	syntax match VimrexUsageEmph 'See:'
	syntax match VimrexUsageHotkey 'g:VimrexExec'
	syntax match VimrexUsageHotkey 'g:VimrexAnlz'
	syntax match VimrexUsageHotkey 'g:VimrexTop'
	syntax match VimrexUsageHotkey 'g:VimrexBtm'
	syntax match VimrexUsageHotkey 'g:VimrexCtr'
	syntax match VimrexUsageHotkey 'g:VimrexCLS'
	syntax match VimrexUsageHotkey 'g:VimrexDRslt'
	syntax match VimrexUsageHotkey 'g:VimrexDSrc'
	syntax match VimrexUsageHotkey 'g:VimrexRdSrc'
	syntax match VimrexUsageHotkey 'g:VimrexRdRex'
	syntax match VimrexUsageHotkey 'g:VimrexQQ'
	syntax match VimrexUsageHotkey 'g:VimrexQC'
	syntax match VimrexUsageHotkey 'g:VimrexQP'
	syntax match VimrexUsageHotkey 'g:VimrexQL'
	syntax match VimrexUsageHotkey 'g:VimrexZHV'
	syntax match VimrexUsageHotkey 'g:VimrexZHS'
	syntax match VimrexUsageHotkey 'g:VimrexZHU'
	syntax match VimrexUsageHotkey 'g:VimrexZHR'
	syntax match VimrexUsageHotkey 'g:VimrexZHA'
	syntax match VimrexUsageHotkey 'g:VimrexZTV'
	syntax match VimrexUsageHotkey 'g:VimrexZTS'
	syntax match VimrexUsageHotkey 'g:VimrexZTU'
	syntax match VimrexUsageHotkey 'g:VimrexZTR'
	syntax match VimrexUsageHotkey 'g:VimrexZTA'
	syntax match VimrexUsageHotkey 'g:VimrexExit'
	syntax match VimrexUsageHotkey 'g:VimrexBrowseDir'
	syntax match VimrexUsageHotkey 'g:VimrexFile\%[Dir]'
	syntax match VimrexUsageHotkey 'g:VimrexRsltFile'
	syntax match VimrexUsageHotkey 'g:VimrexSrcFile'
	syntax match VimrexUsageHotkey 'g:VimrexUsageFile'
	syntax match VimrexUsageHotkey 'g:VimrexSrchPatLnk'
	syntax match VimrexUsageHotkey 'g:VimrexSrchPatCFG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchPatCBG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchPatGFG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchPatGBG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchAncLnk'
	syntax match VimrexUsageHotkey 'g:VimrexSrchAncCFG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchAncCBG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchAncGFG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchAncGBG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchTokLnk'
	syntax match VimrexUsageHotkey 'g:VimrexSrchTokCBG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchTokCFG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchTokGBG'
	syntax match VimrexUsageHotkey 'g:VimrexSrchTokGFG'
	syntax match VimrexUsageHotkey 'g:VimrexFilePatLnk'
	syntax match VimrexUsageHotkey 'g:VimrexFilePatCFG'
	syntax match VimrexUsageHotkey 'g:VimrexFilePatCBG'
	syntax match VimrexUsageHotkey 'g:VimrexFilePatGFG'
	syntax match VimrexUsageHotkey 'g:VimrexFilePatGBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileCgpLnk'
	syntax match VimrexUsageHotkey 'g:VimrexFileCgpCFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileCgpCBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileCgpGFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileCgpGBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileGrpLnk'
	syntax match VimrexUsageHotkey 'g:VimrexFileGrpCFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileGrpCBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileGrpGFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileGrpGBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileChcLnk'
	syntax match VimrexUsageHotkey 'g:VimrexFileChcCFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileChcCBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileChcGFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileChcGBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileExpLnk'
	syntax match VimrexUsageHotkey 'g:VimrexFileExpCFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileExpCBG'
	syntax match VimrexUsageHotkey 'g:VimrexFileExpGFG'
	syntax match VimrexUsageHotkey 'g:VimrexFileExpGBG'
	syntax match VimrexUsageHotkey ':h tohtml'
	syntax match VimrexUsageHotkey '/Remarks:'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexExec.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexAnlz.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexTop.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexBtm.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexCtr.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexCLS.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexDRslt.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexDSrc.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexRdSrc.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexRdRex.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexQQ.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexQC.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexQP.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexQL.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHV.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHS.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHU.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHR.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZHA.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTV.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTS.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTU.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTR.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexZTA.'"'
	execute 'syntax match VimrexUsageHotkey "'.g:VimrexExit.'"'
	execute 'syntax match VimrexUsageHotkey "'.s:myName.'"'
	highlight link VimrexUsageTitle Title
	highlight link VimrexUsageDesc Identifier
	highlight link VimrexUsageSketch StatusLine
	highlight link VimrexUsageEmph NonText
	highlight link VimrexUsageHotkey Statement
endfunction

function! s:usage()
	if bufwinnr(g:VimrexUsageFile) != -1
		return
	endif
	echohl WarningMsg
	echomsg 'Generating Usage Document...'
	echohl None
	let Exec=PadField('l','12',g:VimrexExec)
	let Anlz=PadField('l','12',g:VimrexAnlz)
	let Top=PadField('l','12',g:VimrexTop)
	let Btm=PadField('l','12',g:VimrexBtm)
	let Ctr=PadField('l','12',g:VimrexCtr)
	let CLS=PadField('l','12',g:VimrexCLS)
	let DRslt=PadField('l','12',g:VimrexDRslt)
	let DSrc=PadField('l','12',g:VimrexDSrc)
	let RdSrc=PadField('l','12',g:VimrexRdSrc)
	let RdRex=PadField('l','12',g:VimrexRdRex)
	let QQ=PadField('l','12',g:VimrexQQ)
	let QC=PadField('l','12',g:VimrexQC)
	let QP=PadField('l','12',g:VimrexQP)
	let QL=PadField('l','12',g:VimrexQL)
	let ZHV=PadField('l','12',g:VimrexZHV)
	let ZHS=PadField('l','12',g:VimrexZHS)
	let ZHU=PadField('l','12',g:VimrexZHU)
	let ZHR=PadField('l','12',g:VimrexZHR)
	let ZHA=PadField('l','12',g:VimrexZHA)
	let ZTV=PadField('l','12',g:VimrexZTV)
	let ZTS=PadField('l','12',g:VimrexZTS)
	let ZTU=PadField('l','12',g:VimrexZTU)
	let ZTR=PadField('l','12',g:VimrexZTR)
	let ZTA=PadField('l','12',g:VimrexZTA)
	let Exit=PadField('l','12',g:VimrexExit)
	wincmd t
	call s:delFile(g:VimrexUsageFile)
	new
	execute 'silent edit! '.escape(g:VimrexUsageFile,' ')
	setlocal noreadonly modifiable nonumber noswapfile
	execute 'resize '.&lines
	execute 'vertical resize '.&columns
	call append(0,PadField('c',76,s:myName.": Vim Regular Expression Developer Plugin"))
	call s:doUsageSection('ONE')
	call append(line('$'),PadField('c',76,s:myName.": Command Summary"))
	call append(line('$'),"")
	call append(line('$'),Exec."Execute Regular Expression")
	call append(line('$'),Anlz."Analyze Regular Expression")
	call append(line('$'),Top."Changes to .Vim Regular Expression Specification Window")
	call append(line('$'),Btm."Changes to .Vim Regular Expression Search Source Window")
	call append(line('$'),Ctr."Changes to .Vim Regular Expression Result Window")
	call append(line('$'),CLS."Clear .Vim Regular Expression Specification Window")
	call append(line('$'),DRslt."Clear .Vim Regular Expression Result Window")
	call append(line('$'),DSrc."Clear .Vim Regular Expression Search Source Window")
	call append(line('$'),RdSrc."Read File into .Vim Regular Expression Search Source Window")
	call append(line('$'),RdRex."Read File into .Vim Regular Expression Specification Window")
	call append(line('$'),QQ."Open Usage Window (display this file)")
	call append(line('$'),QL."Close Usage Window")
	call append(line('$'),QC."Collapse Usage Window")
	call append(line('$'),QP."Expand Usage Window")
	call append(line('$'),ZHV."Generate HTML File of Regular Expression Window")
	call append(line('$'),ZHS."Generate HTML File of Search Source Window")
	call append(line('$'),ZHU."Generate HTML File of Usage Window")
	call append(line('$'),ZHR."Generate HTML File of Results Window")
	call append(line('$'),ZHA."Generate HTML File of All But Usage Window")
	call append(line('$'),ZTV."Generate TEXT (.txt) File of Regular Expression Window")
	call append(line('$'),ZTS."Generate TEXT (.txt) File of Search Source Window")
	call append(line('$'),ZTU."Generate TEXT (.txt) File of Usage Window")
	call append(line('$'),ZTR."Generate TEXT (.txt) File of Results Window")
	call append(line('$'),ZTA."Generate TEXT (.txt) File of All But Usage Window")
	call append(line('$'),Exit."Exit ".s:myName." (close all windows)")
	call s:doUsageSection('TWO')
	call append(line('$'),PadField('c',76,s:myName.": Synopsis of Use"))
	call s:doUsageSection('THREE')
	call append(line('$'),PadField('c',76,g:VimrexAnlz))
	call s:doUsageSection('FOUR')
	call append(line('$'),PadField('c',76,g:VimrexExec))
	call s:doUsageSection('FIVE')
	call append(line('$'),PadField('c',76,s:myName.": Global Variables"))
	call append(line('$')," ")
	call append(line('$'),PadField('l',20,'g:VimrexExec')."mapping sequence for executing regular expression")
	call append(line('$'),PadField('l',20,'g:VimrexAnlz')."mapping sequence for analyzing regular expression")
	call append(line('$'),PadField('l',20,'g:VimrexTop')."mapping sequence for goto top window")
	call append(line('$'),PadField('l',20,'g:VimrexBtm')."mapping sequence for goto bottom window")
	call append(line('$'),PadField('l',20,'g:VimrexCtr')."mapping sequence for goto center window")
	call append(line('$'),PadField('l',20,'g:VimrexCLS')."mapping sequence for clearing top window")
	call append(line('$'),PadField('l',20,'g:VimrexDSrc')."mapping sequence for clearing bottom window")
	call append(line('$'),PadField('l',20,'g:VimrexDRslt')."mapping sequence for clearing center window")
	call append(line('$'),PadField('l',20,'g:VimrexRdSrc')."mapping sequence to read file into bottom window")
	call append(line('$'),PadField('l',20,'g:VimrexRdRex')."mapping sequence to read file into top window")
	call append(line('$'),PadField('l',20,'g:VimrexQQ')."mapping sequence to open display of this file")
	call append(line('$'),PadField('l',20,'g:VimrexQL')."mapping sequence to close display of this file")
	call append(line('$'),PadField('l',20,'g:VimrexQC')."mapping sequence to collapse display of this file")
	call append(line('$'),PadField('l',20,'g:VimrexQP')."mapping sequence to expand display of this file")
	call append(line('$'),PadField('l',20,'g:VimrexZHV')."mapping sequence to generate Regular Expression HTML file")
	call append(line('$'),PadField('l',20,'g:VimrexZHS')."mapping sequence to generate Source Search HTML file")
	call append(line('$'),PadField('l',20,'g:VimrexZHU')."mapping sequence to generate Usage HTML file")
	call append(line('$'),PadField('l',20,'g:VimrexZHR')."mapping sequence to generate Results HTML file")
	call append(line('$'),PadField('l',20,'g:VimrexZHA')."mapping sequence to generate All But Usage HTML file")
	call append(line('$'),PadField('l',20,'g:VimrexZTV')."mapping sequence to generate Regular Expression TEXT file")
	call append(line('$'),PadField('l',20,'g:VimrexZTS')."mapping sequence to generate Source Search TEXT file")
	call append(line('$'),PadField('l',20,'g:VimrexZTU')."mapping sequence to generate Usage TEXT file")
	call append(line('$'),PadField('l',20,'g:VimrexZTR')."mapping sequence to generate Results TEXT file")
	call append(line('$'),PadField('l',20,'g:VimrexZTA')."mapping sequence to generate All But Usage TEXT file")
	call append(line('$'),PadField('l',20,'g:VimrexExit')."mapping sequence to exit ".s:myName)
	call append(line('$'),PadField('l',20,"g:VimrexBrowseDir")."directory to browse for read files")
	call append(line('$'),PadField('l',20,"g:VimrexFileDir")."directory to create files ('~')")
	call append(line('$'),PadField('l',20,"g:VimrexFile")."regular expression file")
	call append(line('$'),PadField('l',20,"g:VimrexRsltFile")."result file")
	call append(line('$'),PadField('l',20,"g:VimrexSrcFile")."search source file")
	call append(line('$'),PadField('l',20,"g:VimrexUsageFile")."usage file")
	call append(line('$'),PadField('l',20,"g:VimrexSrchPatLnk")."highlight link for non-current highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexSrchPatCFG")."ctermfg= value for non-current highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchPatCBG")."ctermbg= value for non-current highlighting ('DarkMagenta')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchPatGFG")."guifg= value for non-current highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchPatGBG")."guibg= value for non-current highlighting ('DarkMagenta')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchAncLnk")."highlight link for lookaround highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexSrchAncCFG")."ctermfg= value for lookaround highlighting ('DarkRed')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchAncCBG")."ctermbg= value for lookaround highlighting ('gray')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchAncGFG")."guifg= value for lookaround highlighting ('DarkRed')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchAncGBG")."guibg= value for lookaround highlighting ('gray')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchTokLnk")."highlight link for plain search highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexSrchTokCBG")."ctermfg= value for plain search highlighting ('LightCyan')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchTokCFG")."ctermbg= value for plain search highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchTokGBG")."guifg= value for plain search highlighting ('LightCyan')")
	call append(line('$'),PadField('l',20,"g:VimrexSrchTokGFG")."guibg= value for plain search highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexFilePatLnk")."highlight link for current regex highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexFilePatCFG")."ctermfg= value for current regex highlighting ('cyan')")
	call append(line('$'),PadField('l',20,"g:VimrexFilePatCBG")."ctermfg= value for current regex highlighting ('brown')")
	call append(line('$'),PadField('l',20,"g:VimrexFilePatGFG")."guifg= value for current regex highlighting ('cyan')")
	call append(line('$'),PadField('l',20,"g:VimrexFilePatGBG")."guifg= value for current regex highlighting ('brown')")
	call append(line('$'),PadField('l',20,"g:VimrexFileCgpLnk")."highlight link for capture group highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexFileCgpCFG")."ctermfg= value for capture group highlighting ('blue')")
	call append(line('$'),PadField('l',20,"g:VimrexFileCgpCBG")."ctermfg= value for capture group highlighting ('red')")
	call append(line('$'),PadField('l',20,"g:VimrexFileCgpGFG")."guifg= value for capture group highlighting ('blue')")
	call append(line('$'),PadField('l',20,"g:VimrexFileCgpGBG")."guifg= value for capture group highlighting ('red')")
	call append(line('$'),PadField('l',20,"g:VimrexFileGrpLnk")."highlight link for capture group highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexFileGrpCFG")."ctermfg= value for non-capture group highlighting ('red')")
	call append(line('$'),PadField('l',20,"g:VimrexFileGrpCBG")."ctermfg= value for non-capture group highlighting ('blue')")
	call append(line('$'),PadField('l',20,"g:VimrexFileGrpGFG")."guifg= value for non-capture group highlighting ('red')")
	call append(line('$'),PadField('l',20,"g:VimrexFileGrpGBG")."guifg= value for non-capture group highlighting ('blue')")
	call append(line('$'),PadField('l',20,"g:VimrexFileChcLnk")."highlight link for choice list highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexFileChcCFG")."ctermfg= value for choice list highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexFileChcCBG")."ctermfg= value for choice list highlighting ('LightBlue')")
	call append(line('$'),PadField('l',20,"g:VimrexFileChcGFG")."guifg= value for choice list highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexFileChcGBG")."guifg= value for choice list highlighting ('LightBlue')")
	call append(line('$'),PadField('l',20,"g:VimrexFileExpLnk")."highlight link for expansion seq highlighting")
	call append(line('$'),PadField('l',20,"g:VimrexFileExpCFG")."ctermfg= value for expansion seq highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexFileExpCBG")."ctermfg= value for expansion seq highlighting ('LightGreen')")
	call append(line('$'),PadField('l',20,"g:VimrexFileExpGFG")."guifg= value for expansion seq highlighting ('black')")
	call append(line('$'),PadField('l',20,"g:VimrexFileExpGBG")."guifg= value for expansion seq highlighting ('LightGreen')")
	call append(line('$')," ")
	call append(line('$')," ")
	call append(line('$'),PadField('c',76,s:myName.": Pattern and Match Highlighting"))
	call s:doUsageSection('SIX')
	call append(line('$'),PadField('c',76,s:myName.": Generating Files"))
	call append(line('$')," ")
	call append(line('$'),s:myName." will generate files of the current windows for you to view")
	call s:doUsageSection('SEVEN')
	call append(line('$'),PadField('c',76,s:myName.": Contact Information"))
	call append(line('$')," ")
	call append(line('$'),"If you find bugs, have suggestions, or just want to chat:")
	call append(line('$'),"http://www.vim.org/account/profile.php?user_id=5397")
	call append(line('$'),"You'll find my current email address there.")
	syntax sync fromstart
	setlocal nomodified readonly nomodifiable
	echohl Question
	echon 'Done.'
	echohl None
endfunction

function s:doUsageSection(sect)
	silent :w
	execute 'silent view! +set\ noswapfile '.s:thisScript
	let strtStr='^BEGIN MANUAL SECTION '.a:sect
	let endStr='^END MANUAL SECTION '.a:sect
	let lnum=search(strtStr,'W')+1
	let elnum=search(endStr,'W')
	while lnum < elnum
		let usageLine=getline(lnum)
		silent b#
		call append(line('$'),usageLine)
		silent :w
		silent b#
		let lnum=lnum+1
	endwhile
	silent b#
	execute 'silent '.bufnr(s:thisScript).'bd'
	call s:doUsageSyntax()
endfunction

function s:IT_LL_NEVER_HAPPEN()
BEGIN MANUAL SECTION ONE
Uses 3 windows for developing Vim regular expressions.

The top window is used to type in the regular expression(s) or you may
optionally read in a file containing regular expressions.  There can be more
than one regular expression in the top window, as well as comment lines (lines
that begin with a double quote with optional leading whitespace).  The line
containing the cursor in this window is the line of the current regular
expression for execution and/or analysis.

The middle window shows the result of each successive execution or analysis of
the current regular expression.

The bottom window is for source text used in testing regular expressions.  You
either type in text, or read in a file for searching.

The contents of the top and bottom window are saved from one session to the
next.  When the files used to save these contents do not exist or are empty
when starting up, sample contents are placed in each to use as a self
tutorial.


END MANUAL SECTION ONE
BEGIN MANUAL SECTION TWO

The mappings for all the above are configurable in your vimrc by setting their
respective global variables (see below) to the key sequences you desire.


END MANUAL SECTION TWO
BEGIN MANUAL SECTION THREE

   +----------------------------------------------------------------------+
   |" comment line                                                        |
   |regular expression                                                    |
   |                                                                      |
   |             Build regular expressions here                           |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |----------------------------------------------------------------------|
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |       Execution/Analysis results displayed here                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |----------------------------------------------------------------------|
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |              Text to be searched goes here                           |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   |                                                                      |
   +----------------------------------------------------------------------+

To use, enter a regular expression in the top window and some text to search in
the bottom window.  With the cursor on the line with the regular expression in
the top window, type

END MANUAL SECTION THREE
BEGIN MANUAL SECTION FOUR

and the analysis of the regular expression will be displayed in the center
window.  Now, type

END MANUAL SECTION FOUR
BEGIN MANUAL SECTION FIVE

the results of the search with the current regular expression will be
displayed in the center window.  Additionally,  all text that qualifies as a
match in the bottom window will be highlighted in the 'non-current'
highlighting with the matching specific token of the current search location
highlighted as appropriate to its regular expression atom(s).

NOTE:  you need to use the menu 'Execute Regular Expression' button or the key
       mapping to search and have the described results.  Using Vim's search
			 commands will move to different matches, but will not effect the
			 highlighting.  See : Pattern and Match Highlighting below.


END MANUAL SECTION FIVE
BEGIN MANUAL SECTION SIX

Highlighting is set by either a link or by setting the foreground and/or
background values for cterm or gui.  If the respective 'g:Vimrex...Lnk'
variable exists, the link is used, else the highlighting is set via the
cterm/gui values.

There are eight highlight groups used.  They are:

     current regex
		 plain search
		 capture
		 non-capture
		 choice
		 expansion
		 lookaround
		 non-current

current regex is used to highlight the current regular expression in the top
window.

plain search is the default highlighting for the current match.  If no other
atom highlighting applies, this is the highlighting that is displayed.

capture is the highlighting used to delineate the portion of the current match
that is part of a capture group, i.e., results from a regular expression
enclosed in '\(...\)'.

non-capture highlighting is used to indicate the portion of the current match
that is part of a non-capture group, i.e., results from a regular expression
enclosed in '\%(...\)'.

choice highlighting indicates the portion of the current match that is the
result of a choice list atom, that is, a list of characters or character
classes enclosed in '[...]'.

expansion highlighting indicates the portion of the current match that is the
result of an expansion list, or sequence, atom, that is, a list of characters
or character classes enclosed in '\%[...]'.

lookaround highlighting results from the portion of the current match that
conforms to a lookaround anchor, e.g., '\@<=' or '\@='.  It is, of course,
only seen in the case of a positive lookaround, since the absence of the
anchor triggers the negative lookaround and an 'absence' is difficult to
highlight!;)

non-current highlighting applies to all of the bottom window text that matches
the pattern but is not the current match.


END MANUAL SECTION SIX
BEGIN MANUAL SECTION SEVEN
separately.  Files can be of HTML (.html) or TEXT (.txt) format.  There are
menu buttons and mappings to generate files for each of the windows,
individually or you can generate all but the Usage file into one file for
composite viewing.

NOTE:  HTML only works with Vim compiled with GUI support.  The gui need not
       be running, but in some systems (X11), colors may not be what you see
       when in Vim.  On my system, Windows (g)vim produce comparable colors to
       those shown in Vim.  Cygwin produces the colors as seen in a standard
       xterm window, whether Vim was run in a command prompt window with bash
       or in a special xinit xterm.  By 'standard xterm', I mean an xterm
       started with no arguments, for example, from the command line as
       'xterm &'.

See:   :h tohtml, then /Remarks: (search for 'Remarks:').



END MANUAL SECTION SEVEN
endfunction
