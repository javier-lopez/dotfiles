" Vim completion script
" Language:	EDC
" Maintainer:	Viktor Kojouharov
" Last Change:	2007 02 24

function! edccomplete#Complete(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    let compl_begin = col('.') - 2
    let lastword = -1
    if line =~ ':' && line !~ '\.'
      while start > 0 && (line[start - 1] =~ '\k' || line[start - 1] =~ '"')
	let start -= 1
      endwhile
    else
      while start > 0
	if line[start - 1] =~ '\k'
	  let start -= 1
	elseif line[start - 1] =~ '\.'
	  if lastword == -1
	    let lastword = start - 2
	  endif
	  let start -= 1
	else
	  break
	endif
      endwhile
    endif
    let b:compl_context = getline('.')[0:compl_begin]

    if lastword == -1
      let ppe = searchpos('\.', 'bcn')
      let pps = searchpos('\w\+\.', 'bcn')
      let b:sparent = ''
      if ppe != [0, 0] && pps[0] == ppe[0] && pps[1] <= ppe[1] && pps[0] == line('.')
	let b:scontext = line[pps[1] -1 : ppe[1] - 2]
        call edccomplete#FindParent(pps[0], pps[1])
	return start
      endif

      let startpos = searchpair('{', '', '}', 'bnW')
      let lnum = startpos
      let line = getline(lnum)

      if line !~ '\a\+'
        let lnum = prevnonblank(lnum - 1)
	let line = getline(lnum)
      endif

      call edccomplete#FindParent(lnum, 1)
      let b:scontext = matchstr(line, '\w\+')

      return start
    else
      let b:scontext = line[start : lastword]

      return lastword + 2
    endif
  else
    " find months matching with "a:base"
    let res = []
    if exists("b:compl_context")
      let line = b:compl_context
      unlet! b:compl_context
    else
      let line = a:base
    endif

    if b:scontext == 'part'
      call edccomplete#AddLabel(res, line, a:base, s:partLabel)
      call edccomplete#AddStatement(res, line, a:base, s:partStatement)
      if line =~ 'type:\s*'
	call edccomplete#AddKeyword(res, a:base, s:partTypes)
      elseif line =~ 'effect:\s*'
	call edccomplete#AddKeyword(res, a:base, s:partEffects)
      elseif line =~ 'ignore_flags:\s*'
	call edccomplete#AddKeyword(res, a:base, s:partIgnoreFlags)
      elseif line =~ 'pointer_mode:\s*'
	call edccomplete#AddKeyword(res, a:base, s:partPointerMode)
      elseif line =~ 'editable_mode:\s*'
	call edccomplete#AddKeyword(res, a:base, s:partEditableMode)
      endif
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif b:scontext == 'dragable'
      call edccomplete#AddLabel(res, line, a:base, s:dragableLabel)

    elseif b:scontext == 'description'
      call edccomplete#AddLabel(res, line, a:base, s:descriptionLabel)
      call edccomplete#AddStatement(res, line, a:base, s:descriptionStatement)
      if line =~ 'aspect_preference:\s*'
	call edccomplete#AddKeyword(res, a:base, s:aspectPrefTypes)
      elseif line =~ 'inherit:\s*"\?'
	call edccomplete#FindStates(res, a:base, 1)
      endif

    elseif b:scontext == 'rel1' || b:scontext == 'rel2'
      call edccomplete#AddLabel(res, line, a:base, s:relLabel)
      if line =~ 'to\%(_[xy]\)\?:\s*"\?'
	call edccomplete#FindNamesIn(res, a:base, 'parts')
      endif

    elseif b:scontext == 'image'
      call edccomplete#AddLabel(res, line, a:base, s:imageLabel)
      call edccomplete#AddStatement(res, line, a:base, s:imageStatement)
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif b:scontext == 'fill'
      call edccomplete#AddLabel(res, line, a:base, s:fillLabel)
      call edccomplete#AddStatement(res, line, a:base, s:fillStatement)

    elseif b:scontext == 'origin' || b:scontext == 'size'
      call edccomplete#AddLabel(res, line, a:base, s:fillInnerStatement)

    elseif b:scontext == 'text'
      call edccomplete#AddLabel(res, line, a:base, s:textLabel)
      call edccomplete#AddStatement(res, line, a:base, s:textStatement)

    elseif b:scontext == 'program'
      call edccomplete#AddLabel(res, line, a:base, s:programLabel)
      call edccomplete#AddStatement(res, line, a:base, s:programStatement)
      if line =~ 'transition:\s*'
	call edccomplete#AddKeyword(res, a:base, s:transitionTypes)
      elseif line =~ 'STATE_SET\s*"\?'
	call edccomplete#FindStates(res, a:base, 0)
      elseif line =~ 'action:\s*'
	call edccomplete#AddKeyword(res, a:base, s:actionTypes)
      elseif line =~ 'target:\s*"\?'
	call edccomplete#FindNamesIn(res, a:base, 'parts')
      elseif line =~ 'after:\s*"\?'
	call edccomplete#FindNamesIn(res, a:base, 'programs')
      endif

    elseif b:scontext == 'programs'
      call edccomplete#AddLabel(res, line, a:base, s:programsLabel)
      call edccomplete#AddStatement(res, line, a:base, s:programsStatement)
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif b:scontext == 'box' && b:sparent == 'part'
      call edccomplete#AddStatement(res, line, a:base, s:boxStatement)

    elseif b:scontext == 'items'
      call edccomplete#AddStatement(res, line, a:base, s:boxItemsStatement)

    elseif b:scontext == 'item'
      call edccomplete#AddLabel(res, line, a:base, s:boxItemLabel)
      if line =~ 'type:\s*'
	call edccomplete#AddKeyword(res, a:base, s:boxItemTypes)
      elseif line =~ 'aspect_mode:\s*"\?'
	call edccomplete#AddKeyword(res, a:base, s:boxItemAspectMode)
      endif

    elseif b:scontext == 'box' && b:sparent == 'description'
      call edccomplete#AddLabel(res, line, a:base, s:boxDescLabel)
      if line =~ 'layout:\s*'
	call edccomplete#AddKeyword(res, a:base, s:boxLayout)
      endif

    elseif b:scontext == 'table' && b:sparent == 'description'
      call edccomplete#AddLabel(res, line, a:base, s:tableDescLabel)
      if line =~ 'homogeneous:\s*'
	call edccomplete#AddKeyword(res, a:base, s:tableHomogeneousMode)
      endif

    elseif b:scontext == 'group'
      call edccomplete#AddLabel(res, line, a:base, s:groupLabel)
      call edccomplete#AddStatement(res, line, a:base, s:groupStatement)
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif b:scontext == 'parts'
      call edccomplete#AddLabel(res, line, a:base, s:partsLabel)
      call edccomplete#AddStatement(res, line, a:base, s:partsStatement)
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif b:scontext == 'data'
      call edccomplete#AddLabel(res, line, a:base, s:dataLabel)

    elseif b:scontext == 'fonts'
      call edccomplete#AddLabel(res, line, a:base, s:fontsLabel)

    elseif b:scontext == 'spectra'
      call edccomplete#AddStatement(res, line, a:base, s:spectraStatement)

    elseif b:scontext == 'spectrum'
      call edccomplete#AddLabel(res, line, a:base, s:spectrumLabel)

    elseif b:scontext == 'gradient'
      call edccomplete#AddLabel(res, line, a:base, s:gradientLabel)
      call edccomplete#AddStatement(res, line, a:base, s:gradientStatement)

    elseif b:scontext == 'styles'
      call edccomplete#AddStatement(res, line, a:base, s:stylesStatement)

    elseif b:scontext == 'style'
      call edccomplete#AddLabel(res, line, a:base, s:styleLabel)

    elseif b:scontext == 'color_classes'
      call edccomplete#AddStatement(res, line, a:base, s:color_classesStatement)

    elseif b:scontext == 'color_class'
      call edccomplete#AddLabel(res, line, a:base, s:color_classLabel)

    elseif b:scontext == 'images'
      call edccomplete#AddLabel(res, line, a:base, s:imagesLabel)
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif b:scontext == 'collections'
      call edccomplete#AddLabel(res, line, a:base, s:collectionsLabel)
      call edccomplete#AddStatement(res, line, a:base, s:collectionsStatement)
      if line =~ 'image:\s*".\{-}"'
	call edccomplete#AddKeyword(res, a:base, s:imageStorageMethod)
      endif

    elseif strlen(b:scontext) == 0
      call edccomplete#AddStatement(res, line, a:base, s:topStatement)
    endif

    unlet! b:scontext

    return res
  endif
endfunction

function! edccomplete#AddLabel(res, line, base, label)
  if a:line =~ ':'
    return
  endif

  for m in sort(keys(a:label))
    if m =~ '^' . a:base
      call add(a:res, {'word': m . ':', 'menu': a:label[m]})
    endif
  endfor
endfunction

function! edccomplete#AddKeyword(res, base, label)
  for m in sort(keys(a:label))
    if m =~ '^' . a:base
      call add(a:res, {'word': m, 'menu': a:label[m]})
    endif
  endfor
endfunction

function! edccomplete#AddStatement(res, line, base, statement)
  if a:line =~ ':'
    return
  endif

  for m in sort(a:statement)
    if m =~ '^' . a:base
      call add(a:res, m . ' {')
    endif
  endfor
endfunction

function! edccomplete#FindStates(res, base, in_part)
  let curpos = getpos('.')
  call remove(curpos, 0, 0)

  let states_list = []
  if a:in_part == 1 	" in the current part only
    let part_start = search('^[ \t}]*\<part\>[ \t{]*$', 'bnW')
    if part_start != 0  " found it
      let line = getline(part_start)
      if line !~ '{'
	let part_start = nextnonblank(part_start)
      endif
      call cursor(part_start, 0)
      let part_end = searchpair('{', '', '}', 'nW')
    endif
  else 			" in the current parts group
    let part_start = search('^[ \t}]*\<parts\>[ \t{]*$', 'bnW')
    if part_start != 0  " found it
      let line = getline(part_start)
      if line !~ '{'
	let part_start = nextnonblank(part_start)
      endif
      call cursor(part_start, 0)
      let part_end = searchpair('{', '', '}', 'nW')
    endif
  endif

  let state_num = search('\%(state:\s*\)"\w\+"', 'W', part_end)
  while state_num
    let state = matchstr(getline(state_num), '\%(state:\s*\)\@<="\w\+"')
    call extend(states_list, [state])
    let state_num = search('\%(state:\s*\)"\w\+"', 'W', part_end)
  endwhile
  call cursor(curpos)

  for m in sort(states_list)
    if m =~ '^' . a:base
      call add(a:res, m)
    endif
  endfor
endfunction

function! edccomplete#FindNamesIn(res, base, str)
  let curpos = getpos('.')
  call remove(curpos, 0, 0)

  let names_list = []
  let part_start = search('^[ \t}]*\<' . a:str . '\>[ \t{]*$', 'bnW')
  if part_start != 0  " found it
    let line = getline(part_start)
    if line !~ '{'
      let part_start = nextnonblank(part_start)
    endif
    call cursor(part_start, 0)
    let part_end = searchpair('{', '', '}', 'nW')
  endif

  let name_num = search('\%(name:\s*\)"\w\+"', 'W', part_end)
  while name_num
    let name = matchstr(getline(name_num), '\%(name:\s*\)\@<="\w\+"')
    call extend(names_list, [name])
    let name_num = search('\%(name:\s*\)"\w\+"', 'W', part_end)
  endwhile
  call cursor(curpos)

  for m in sort(names_list)
    if m =~ '^' . a:base
      call add(a:res, m)
    endif
  endfor
endfunction

function! edccomplete#FindParent(lnum, cnum)
  call setpos('.', [0, a:lnum, a:cnum, 0])
  let ppe = searchpos('\.', 'bcn')
  let pps = searchpos('\w\+\.', 'bcn')
  if ppe != [0, 0] && pps[0] == ppe[0] && pps[1] <= ppe[1] && pps[0] == line('.')
    let b:sparent = line[pps[1] -1 : ppe[1] - 2]
    return
  endif

  let startpos = searchpair('{', '', '}', 'bnW')
  let lnum = startpos
  let line = getline(lnum)

  if line !~ '\a\+'
    let line = getline(prevnonblank(lnum - 1))
  endif

  let b:sparent = matchstr(line, '\w\+')
endfunction

" part
let s:partLabel = {
      \ 'name': 		        '"string"',
      \ 'type':			        '"keyword"',
      \ 'effect':		        '"keyword"',
      \ 'ignore_flags':		        '"keyword" ...',
      \ 'pointer_mode':		        '"keyword"',
      \ 'mouse_events':		        '"bool"',
      \ 'repeat_events':	        '"bool"',
      \ 'scale':	                '"bool"',
      \ 'precise_is_inside':	        '"bool"',
      \ 'use_alternate_font_metrics':	'"bool"',
      \ 'clip_to':		        '"string"',
      \ 'source':		        '"string"',
      \ 'image':		        '"string" "keyword"',
      \ 'font':			        '"string" "string"',
      \ 'entry_mode':		        '"keyword"',
      \ }
let s:partStatement = [
      \ 'dragable',
      \ 'images',
      \ 'fonts',
      \ 'description',
      \ 'styles',
      \ 'color_classes',
      \ 'program',
      \ 'programs',
      \ 'box',
      \ ]

" dragable
let s:dragableLabel = {
      \ 'x':		'"bool" "int" "int"',
      \ 'y':		'"bool" "int" "int"',
      \ 'confine':	'"string"',
      \ 'events':	'"string"',
      \ }

" description
let s:descriptionLabel = {
      \ 'state':		'"string" "float"',
      \ 'inherit':		'"string" "float"',
      \ 'visible':		'"bool"',
      \ 'align':		'"float" "float"',
      \ 'fixed': 		'"float" "float"',
      \ 'min':			'"int" "int"',
      \ 'max':			'"int" "int"',
      \ 'step':			'"int" "int"',
      \ 'aspect':		'"float" "float"',
      \ 'aspect_preference':	'"keyword"',
      \ 'color_class':		'"string"',
      \ 'color':		'"int" "int" "int" "int"',
      \ 'color2':		'"int" "int" "int" "int"',
      \ 'color3':		'"int" "int" "int" "int"',
      \ 'font':			'"string" "string"',
      \ }
let s:descriptionStatement = [
      \ 'rel1',
      \ 'rel2',
      \ 'image',
      \ 'fill',
      \ 'text',
      \ 'gradient',
      \ 'images',
      \ 'fonts',
      \ 'styles',
      \ 'color_classes',
      \ 'program',
      \ 'programs',
      \ 'box',
      \ ]

" rel
let s:relLabel = {
      \ 'relative':	'"float" "float"',
      \ 'offset':	'"int" "int"',
      \ 'to':		'"string"',
      \ 'to_x':		'"string"',
      \ 'to_y':		'"string"',
      \ }

" image
let s:imageStatement = [
      \ 'images',
      \ ]
let s:imageLabel = {
      \ 'image':	'"string" "keyword"',
      \ 'normal':	'"string"',
      \ 'tween':	'"string"',
      \ 'border':	'"int" "int" "int" "int"',
      \ 'middle':	'"bool"',
      \ }

" fill
let s:fillLabel = {
      \ 'smooth':	'"bool"',
      \ 'angle':	'"0-360"',
      \ 'spread':	'"bool"',
      \ }
let s:fillStatement = [
      \ 'origin',
      \ 'size',
      \ ]
" fill origin/size
let s:fillInnerStatement = {
      \ 'relative':	'"float" "float"',
      \ 'offset':	'"int" "int"',
      \ }

" text
let s:textLabel = {
      \ 'text':		'"string"',
      \ 'text_class':	'"string"',
      \ 'font':		'"string"',
      \ 'style':	'"string"',
      \ 'size':		'"int"',
      \ 'fit':		'"bool" "bool"',
      \ 'min':		'"bool" "bool"',
      \ 'max':		'"bool" "bool"',
      \ 'align':	'"float" "float"',
      \ 'elipsis':	'"float"',
      \ 'source':	'"string"',
      \ 'text_source':	'"string"',
      \ }
let s:textStatement = [
      \ 'fonts',
      \ ]

" program
let s:programLabel = {
      \ 'name':		'"string"',
      \ 'signal':	'"string"',
      \ 'source':	'"string"',
      \ 'action':	'"keyword" ...',
      \ 'transition':	'"keyword" "float"',
      \ 'target':	'"string"',
      \ 'after':	'"string"',
      \ 'in':		'"float" "float"',
      \ }
let s:programStatement = [
      \ 'script',
      \ ]


" programs
let s:programsLabel = {
      \ 'image':	'"string" "keyword"',
      \ 'font':		'"string" "string"',
      \ }
let s:programsStatement = [
      \ 'images',
      \ 'fonts',
      \ 'program',
      \ ]

" box and table
let s:boxStatement = [
      \ 'items',
      \ ]
let s:boxItemsStatement = [
      \ 'item',
      \ ]
let s:boxItemLabel = {
      \ 'type':	        '"keyword"',
      \ 'name':	        '"string"',
      \ 'source':	'"string"   # Group name',
      \ 'min':		'"int" "int"',
      \ 'prefer':	'"int" "int"',
      \ 'max':		'"int" "int"',
      \ 'padding':      '"int" "int" "int" "int"',
      \ 'align':	'"float" "float"',
      \ 'weight':	'"float" "float"',
      \ 'aspect':	'"float" "float"',
      \ 'aspect_mode':  '"keyword"',
      \ 'options':      '"string"',
      \ }
let s:boxDescLabel = {
      \ 'layout':       '"string" ["string"]',
      \ 'align':	'"float" "float"',
      \ 'padding':      '"int" "int"',
      \ }
let s:tableItemLabel = {
      \ 'position':	'"int" "int"',
      \ 'span':	        '"int" "int"',
      \ }
let s:tableDescLabel = {
      \ 'homogeneous':	'"keyword"',
      \ 'align':	'"float" "float"',
      \ 'padding':      '"int" "int"',
      \ }

" group
let s:groupLabel = {
      \ 'name':		'"string"',
      \ 'alias':	'"string"',
      \ 'min':		'"int" "int"',
      \ 'max':		'"int" "int"',
      \ 'image':	'"string" "keyword"',
      \ 'font':		'"string" "string"',
      \ }
let s:groupStatement = [
      \ 'data',
      \ 'script',
      \ 'parts',
      \ 'images',
      \ 'fonts',
      \ 'styles',
      \ 'color_classes',
      \ 'program',
      \ 'programs',
      \ ]

" parts
let s:partsStatement = [
      \ 'images',
      \ 'fonts',
      \ 'part',
      \ 'styles',
      \ 'color_classes',
      \ 'program',
      \ 'programs',
      \ ]
let s:partsLabel = {
      \ 'image':	'"string" "keyword"',
      \ 'font':		'"string" "string"',
      \ }

" data
let s:dataLabel = {
      \ 'item':		'"string" "string" ...',
      \ }

" fonts
let s:fontsLabel = {
      \ 'font':		'"string" "string"',
      \ }

"images
let s:imagesLabel = {
      \ 'image':	'"string" "keyword"',
      \ }

"collections
let s:collectionsStatement = [
      \ 'group',
      \ 'images',
      \ 'fonts',
      \ 'styles',
      \ 'color_classes',
      \ ]
let s:collectionsLabel = {
      \ 'image':	'"string" "keyword"',
      \ 'font':		'"string" "string"',
      \ }

" spectra
let s:spectraStatement = [
      \ 'spectrum',
      \ ]
" spectrum
let s:spectrumLabel = {
      \ 'name':		'"string"',
      \ 'color': 	'"int" "int" "int" "int" "int"',
      \ }
" gradient
let s:gradientLabel = {
      \ 'type':		'"string"',
      \ 'spectrum':	'"string"',
      \ }
let s:gradientStatement = [
      \ 'rel1',
      \ 'rel2',
      \ ]

" styles
let s:stylesStatement = [
      \ 'style',
      \ ]
" style
let s:styleLabel = {
      \ 'name':		'"string"',
      \ 'base': 	'"string"',
      \ 'tag': 		'"string"',
      \ }

" color_classes
let s:color_classesStatement = [
      \ 'color_class',
      \ ]
" color_class
let s:color_classLabel = {
      \ 'name':		'"string"',
      \ 'color':	'"int" "int" "int" "int"',
      \ 'color2':	'"int" "int" "int" "int"',
      \ 'color3':	'"int" "int" "int" "int"',
      \ }

" toplevel
let s:topStatement = [
      \ 'fonts',
      \ 'images',
      \ 'data',
      \ 'collections',
      \ 'spectra',
      \ 'styles',
      \ 'color_classes',
      \ ]

" images image storage method
let s:imageStorageMethod = {
      \ 'COMP':		'',
      \ 'RAW':		'',
      \ 'LOSSY':	'0-100',
      \ }

" part types
let s:partTypes = {
      \ 'TEXT':		'',
      \ 'IMAGE':	'',
      \ 'RECT':		'',
      \ 'TEXTBLOCK':	'',
      \ 'SWALLOW':	'',
      \ 'GRADIENT':	'',
      \ 'GROUP':	'',
      \ 'BOX':	        '',
      \ 'TABLE':        '',
      \ }
" part effects
let s:partEffects = {
      \ 'NONE':			'',
      \ 'PLAIN':		'',
      \ 'OUTLINE':		'',
      \ 'SOFT_OUTLINE':		'',
      \ 'SHADOW':		'',
      \ 'SOFT_SHADOW':		'',
      \ 'OUTLINE_SHADOW':	'',
      \ 'OUTLINE_SOFT_SHADOW':	'',
      \ 'FAR_SHADOW':	'',
      \ 'FAR_SOFT_SHADOW':	'',
      \ 'GLOW':	'',
      \ }
" part ignore flags 
let s:partIgnoreFlags = {
      \ 'NONE':	        '',
      \ 'ON_HOLD':	'',
      \ }
" part pointer mode
let s:partPointerMode = {
      \ 'AUTOGRAB':     '',
      \ 'NOGRAB':	'',
      \ }
" part editable_mode
let s:partEditableMode = {
      \ 'NONE':		'',
      \ 'PLAIN':	'',
      \ 'EDITABLE':	'',
      \ 'PASSWORD':	'',
      \ }

" aspect_preference types
let s:aspectPrefTypes = {
      \ 'VERTICAL':	'',
      \ 'HORIZONTAL':	'',
      \ 'BOTH':		'',
      \	}

" program transition types
let s:transitionTypes = {
      \ 'LINEAR':	'0.0 - 1.0',
      \ 'SINUSOIDAL':	'0.0 - 1.0',
      \ 'ACCELERATE':	'0.0 - 1.0',
      \ 'DECELERATE':	'0.0 - 1.0',
      \ }
" program action types
let s:actionTypes = {
      \ 'STATE_SET':		'"string" "0.0 - 1.0"',
      \ 'ACTION_STOP':		'',
      \ 'SIGNAL_EMIT':		'"string" "string"',
      \ 'DRAG_VAL_SET':		'"float" "float"',
      \ 'DRAG_VAL_STEP':	'"float" "float"',
      \ 'DRAG_VAL_PAGE':	'"float" "float"',
      \ 'FOCUS_SET':	        '',
      \ }
" box item types
let s:boxItemTypes = {
      \ 'GROUP':	'',
      \ }
" box item aspect mode
let s:boxItemAspectMode = {
      \ 'NONE':	        '',
      \ 'NEITHER':	'',
      \ 'VERTICAL':	'',
      \ 'HORIZONTAL':	'',
      \ 'BOTH':		'',
      \	}
" box layout
let s:boxLayout = {
      \ '"horizontal"':	        '',
      \ '"horizontal_homogeneous"':	'',
      \ '"horizontal_max"':	'',
      \ '"horizontal_flow"':	'',
      \ '"vertical"':	        '',
      \ '"vertical_homogeneous"':	'',
      \ '"vertical_max"':	'',
      \ '"vertical_flow"':	'',
      \ '"stack"':		'',
      \	}
" table homogeneous mode
let s:tableHomogeneousMode = {
      \ 'NONE':		'',
      \ 'TABLE':	'',
      \ 'ITEM':		'',
      \	}
