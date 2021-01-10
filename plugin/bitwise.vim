" Vim plug-in
" Author: Ramon Fried <rfried.dev@gmail.com>
" Last Change: July 14, 2019
" URL: https://github.com/mellowcandle/vim-bitwise

" Don't source the plug-in when it's already been loaded or &compatible is set.
if &cp || exists('g:loaded_vim_bitwise')
  finish
endif

if !executable('bitwise')
		echom "Bitwise is not installed on this system or not in path"
    finish
endif

" Make sure the plug-in is only loaded once.
let g:loaded_vim_bitwise = 1


command! -nargs=+ Bitwise call s:RunShellCommand('bitwise --no-color '.<q-args>)
nnoremap <leader>b :set operatorfunc=<SID>BitwiseOperator<cr>g@
vnoremap <silent> <leader>b  :<c-u>call <SID>BitwiseOperator(visualmode())<cr>

function! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

function! s:BitwiseOperator(type)
  let saved_unnamed_register = @@
  echom a:type
  if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'V'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif
  let @@ = Chomp(@@)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, '# ' . shellescape(@@))
  call setline(3,substitute(getline(2),'.','=','g'))
  silent execute '$read !'. "bitwise --no-color ". shellescape(@@)
  setlocal nomodifiable
  let @@ = saved_unnamed_register
endfunction

" RunShellCommand code comes from 
" https://vim.fandom.com/wiki/Display_output_of_shell_commands_in_new_window
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" vim: ts=2 sw=2 et
