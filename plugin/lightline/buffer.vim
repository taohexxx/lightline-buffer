" =============================================================================
" File: plugin/lightline/buffer.vim
" Author: taohe <taohex@gmail.com>
" License: MIT License
" Updated: 2017/03/31
" Version: 0.0.7
" =============================================================================

if exists('g:loaded_lightline_buffer')
  finish
elseif v:version < 703
  echoerr 'lightline-buffer does not work this version of Vim "' . v:version . '".'
  finish
endif
let g:loaded_lightline_buffer = 1

let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo

