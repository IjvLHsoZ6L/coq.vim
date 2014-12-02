" Vim plugin file
" Language:    Coq
" Maintainer:  IjvLHsoZ6L
" Last Change: 2014 Dec 1

" Only do this when not done yet for this buffer
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" optional key bind
nnoremap <buffer> <silent> ,, :CoqRunToCursor<CR>

command! CoqRunToCursor call <sid>runtocursor()

function! s:runtocursor()

  if &autowrite
    write
  endif

  let input = join(getline(1, '.'), "\n")

  if empty(input)
    return
  endif

  let output = system('coqtop -emacs', input)

  let last = ''
  for line in split(output, '\m\_\s*<prompt>.\{-}</prompt>\_\s*')
    if !empty(line)
      let last = line
    endif
  endfor

  let curbuf = bufnr('%')

  let nr = bufwinnr('__coq_ide__')
  if nr == -1
    silent! execute 10 'split __coq_ide__'
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nolist
  else
    execute nr 'wincmd w'
  endif

  silent! execute '%delete'
  call append(0, split(last, "\n"))
  call cursor(1, 1)

  execute bufwinnr(curbuf) 'wincmd w'

endfunction
