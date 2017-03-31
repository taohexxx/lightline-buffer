" =============================================================================
" File: autoload/lightline/buffer.vim
" Author: taohe <taohex@gmail.com>
" License: MIT License
" Updated: 2017/03/31
" Version: 0.0.7
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

call s:check_defined('g:lightline_buffer_logo', '')
call s:check_defined('g:lightline_buffer_readonly_icon', 'RO')
call s:check_defined('g:lightline_buffer_modified_icon', '*')
call s:check_defined('g:lightline_buffer_git_icon', '')
call s:check_defined('g:lightline_buffer_ellipsis_icon', '..')
call s:check_defined('g:lightline_buffer_expand_left_icon', '<')
call s:check_defined('g:lightline_buffer_expand_right_icon', '>')
call s:check_defined('g:lightline_buffer_active_buffer_left_icon', '')
call s:check_defined('g:lightline_buffer_active_buffer_right_icon', '')
call s:check_defined('g:lightline_buffer_separator_icon', ' ')

call s:check_defined('g:lightline_buffer_show_bufnr', 1)
call s:check_defined('g:lightline_buffer_rotate', 0)
" :help filename-modifiers
call s:check_defined('g:lightline_buffer_fname_mod', ':t')  " ':.'
call s:check_defined('g:lightline_buffer_excludes', ['vimfiler'])

call s:check_defined('g:lightline_buffer_maxflen', 30)
call s:check_defined('g:lightline_buffer_maxfextlen', 3)
call s:check_defined('g:lightline_buffer_minflen', 16)
call s:check_defined('g:lightline_buffer_minfextlen', 3)
call s:check_defined('g:lightline_buffer_reservelen', 20)

let g:lightline_buffer_status_info = {
    \ 'count': 0,
    \ 'before': '',
    \ 'current': '',
    \ 'after': '',
    \ }
call s:check_defined('g:lightline_buffer_status_info', {})
call s:check_defined('g:lightline_buffer_status_info.count', 0)
call s:check_defined('g:lightline_buffer_status_info.before', '')
call s:check_defined('g:lightline_buffer_status_info.current', '')
call s:check_defined('g:lightline_buffer_status_info.after', '')

function! s:shorten_name(name, newlen, extlen, oldlen)
  if a:oldlen <= a:newlen
    return a:name
  endif
  return strpart(a:name, 0, a:newlen - 2 - a:extlen) .
      \ g:lightline_buffer_ellipsis_icon .
      \ strpart(a:name, a:oldlen - a:extlen, a:extlen)
endfunction

function! s:shorten_left(str, newlen, oldlen)
  if a:oldlen <= a:newlen
    return a:str
  endif
  return g:lightline_buffer_expand_left_icon .
      \ strpart(a:str, a:oldlen - a:newlen, a:newlen - 4)
endfunction

function! s:shorten_right(str, newlen, oldlen)
  if a:oldlen <= a:newlen
    return a:str
  endif
  return strpart(a:str, 0, a:newlen - 4) . g:lightline_buffer_expand_right_icon
endfunction

function! s:int_compare(l, r)
  return a:l - a:r
endfunction

function! s:generate_buffer_names()
  let flensum = 0
  "let current_bufnr = bufnr('%')
  let len2bufnrs = {}
  " key is always string in map
  let bufnr2names = {}
  for nr in range(1, bufnr('$'))
    if bufexists(nr) && buflisted(nr)
      let modified = ''
      if getbufvar(nr, '&mod')
        let modified = g:lightline_buffer_modified_icon
      endif
      let fname = bufname(nr)
      if fname !=# ''
        if has('modify_fname')
          let fname = fnamemodify(fname, g:lightline_buffer_fname_mod)
        endif
        " % is a legal char in file name, but a escape char in vim
        let fname = substitute(fname, "%", "%%", "g")
      else
        let fname = '[No Name]'
      endif

      let skip = 0
      for exclude in g:lightline_buffer_excludes
        if match(fname, exclude) > -1
          let skip = 1
          break
        endif
      endfor

      if !skip
        let foldlen = strlen(fname)
        if foldlen > g:lightline_buffer_maxflen
          let fname = s:shorten_name(fname, g:lightline_buffer_maxflen,
              \ g:lightline_buffer_maxfextlen, foldlen)
        endif

        let name = ''
        "if g:lightline_buffer_show_bufnr != 0 &&
        "    \ g:lightline_buffer_status_info.count >= g:lightline_buffer_show_bufnr
        "  let name = nr . ' '
        "endif
        let name .= fname . ' ' . modified

        "if current_bufnr == nr
        "  let name = g:lightline_buffer_active_buffer_left_icon . name .
        "      \ g:lightline_buffer_active_buffer_right_icon
        "  let g:lightline_buffer_status_info.current = name
        "else
        "  let name = g:lightline_buffer_separator_icon . name .
        "      \ g:lightline_buffer_separator_icon
        "endif

        let bufnr2names[nr] = name

        let namelen = strlen(name)
        "if get(len2bufnrs, namelen) == 0
        "  let len2bufnrs[namelen] = []
        "endif
        "call add(len2bufnrs[namelen], nr)
        "len2bufnrs[namelen] += [nr]
        if get(len2bufnrs, namelen) == 0
          let len2bufnrs[namelen] = ''
        endif
        let len2bufnrs[namelen] .= nr . ' '

        " add number and space * 2
        let flensum += strlen(nr) + namelen +
            \ strlen(g:lightline_buffer_separator_icon) + 2
      endif
    endif
  endfor
  let flensum += strlen(g:lightline_buffer_active_buffer_left_icon) +
      \ strlen(g:lightline_buffer_active_buffer_right_icon)

  let g:lightline_buffer_status_info.info = ''
  let namelens = sort(keys(len2bufnrs), "s:int_compare")

  " debug only
  "for namelen in namelens
  "  let g:lightline_buffer_status_info.info .= namelen . ': '
  "  "for bufnr in len2bufnrs[namelen]
  "  let bufnrs = split(len2bufnrs[namelen])
  "  for bufnr in bufnrs
  "    let g:lightline_buffer_status_info.info .= bufnr . ' ' . bufnr2names[bufnr] . ', '
  "  endfor
  "  let g:lightline_buffer_status_info.info .= '; '
  "endfor
  let g:lightline_buffer_status_info.info = g:lightline_buffer_logo .
      \ tabpagenr() . '/' . tabpagenr('$')

  for namelen in namelens
    if flensum + g:lightline_buffer_reservelen <= &columns
      break
    endif
    "for bufnr in len2bufnrs[namelen]
    let bufnrs = split(len2bufnrs[namelen])
    for bufnr in bufnrs
      if flensum + g:lightline_buffer_reservelen <= &columns
        continue
      endif
      let foldlen = strlen(bufnr2names[bufnr])
      let bufnr2names[bufnr] = s:shorten_name(bufnr2names[bufnr],
          \ g:lightline_buffer_minflen, g:lightline_buffer_minfextlen, foldlen)
      let fnewlen = strlen(bufnr2names[bufnr])
      let flensum -= foldlen - fnewlen
    endfor
  endfor
  "let i = 0
  "while i < len(names)
  "  if flensum + g:lightline_buffer_reservelen > &columns
  "    let foldlen = strlen(names[i][1])
  "    let names[i][1] = s:shorten_name(names[i][1], g:lightline_buffer_minflen,
  "        \ g:lightline_buffer_minfextlen, foldlen)
  "    let fnewlen = strlen(names[i][1])
  "    let flensum -= foldlen - fnewlen
  "  endif
  "  let i += 1
  "endwhile
  let names = []
  for bufnr in sort(keys(bufnr2names), "s:int_compare")
    call add(names, [bufnr, bufnr2names[bufnr]])
  endfor

  "if len(names) > 1
  "  if g:lightline_buffer_rotate == 1
  "    call bufferline#algos#fixed_position#modify(names)
  "  endif
  "endif

  return names
endfunction

function! lightline#buffer#bufferline()
  " check for special cases like help files
  let current_bufnr = bufnr('%')
  if !bufexists(current_bufnr) || !buflisted(current_bufnr)
    return ''
  endif

  let names = s:generate_buffer_names()
  let before_str = ''
  let current_str = ''
  let after_str = ''
  let flensum = 0
  " debug only
  "for nr in range(1, bufnr('$'))
  "  if bufexists(nr) && buflisted(nr)
  "    let fname = bufname(nr)
  "    if nr < current_bufnr
  "      let before_str .= nr . ' ' . fname . g:lightline_buffer_separator_icon
  "    elseif nr > current_bufnr
  "      let after_str .= nr . ' ' . fname . g:lightline_buffer_separator_icon
  "    else
  "      let current_str .= g:lightline_buffer_active_buffer_left_icon . nr .
  "          \ g:lightline_buffer_active_buffer_right_icon .
  "          \ g:lightline_buffer_separator_icon
  "    endif
  "    let flensum += nr + fname + strlen(g:lightline_buffer_separator_icon) +
  "        \ 2  " add number and space * 2
  "  endif
  "endfor
  for nr in range(0, len(names) - 1)
    let val = names[nr]
    if val[0] < current_bufnr
      let before_str .= val[0] . ' ' . val[1] . g:lightline_buffer_separator_icon
    elseif val[0] > current_bufnr
      let after_str .= val[0] . ' ' . val[1] . g:lightline_buffer_separator_icon
    else
      let current_str .= g:lightline_buffer_active_buffer_left_icon .
          \ val[0] . ' ' . val[1] .
          \ g:lightline_buffer_active_buffer_right_icon .
          \ g:lightline_buffer_separator_icon
    endif
    let flensum += strlen(val[0]) + strlen(val[1]) +
        \ strlen(g:lightline_buffer_separator_icon) + 2  " add number and space * 2
  endfor
  let flensum += strlen(g:lightline_buffer_active_buffer_left_icon) +
      \ strlen(g:lightline_buffer_active_buffer_right_icon)

  let g:lightline_buffer_status_info.count = len(names)
  "let g:lightline_buffer_status_info.info = flensum . ' ' . &columns
  let g:lightline_buffer_status_info.current = current_str
  let current_str_len = strlen(current_str)
  let before_str_len = strlen(before_str)
  let after_str_len = strlen(after_str)
  if before_str_len + current_str_len + after_str_len +
      \ g:lightline_buffer_reservelen > &columns
    let max_part_len = (&columns - current_str_len -
        \ g:lightline_buffer_reservelen) / 2
    if before_str_len < max_part_len
      let g:lightline_buffer_status_info.before = before_str
      let g:lightline_buffer_status_info.after = s:shorten_right(after_str,
          \ &columns - current_str_len - before_str_len -
          \ g:lightline_buffer_reservelen, after_str_len)
    elseif after_str_len < max_part_len
      let g:lightline_buffer_status_info.before = s:shorten_left(before_str,
          \ &columns - current_str_len - after_str_len -
          \ g:lightline_buffer_reservelen, before_str_len)
      let g:lightline_buffer_status_info.after = after_str
    else
      let g:lightline_buffer_status_info.before =
          \ s:shorten_left(before_str, max_part_len, before_str_len)
      let g:lightline_buffer_status_info.after =
          \ s:shorten_right(after_str, max_part_len, after_str_len)
    endif
  else
    let g:lightline_buffer_status_info.before = before_str
    let g:lightline_buffer_status_info.after = after_str
  endif
  " debug only
  "let g:lightline_buffer_status_info.before =
  "    \ s:shorten_left(before_str, before_str_len - 14, before_str_len)
  "let g:lightline_buffer_status_info.after =
  "    \ s:shorten_right(after_str, after_str_len - 14, after_str_len)
  let line = before_str . current_str . after_str

  return line
endfunction

function! lightline#buffer#bufferinfo()
  call lightline#buffer#bufferline()
  if exists('g:lightline_buffer_status_info.info')
    return g:lightline_buffer_status_info.info
  endif
  return ''
endfunction

function! lightline#buffer#bufferbefore()
  return g:lightline_buffer_status_info.before
endfunction

function! lightline#buffer#bufferafter()
  return g:lightline_buffer_status_info.after
endfunction

function! lightline#buffer#buffercurrent()
  return g:lightline_buffer_status_info.current
endfunction

" have to use %{} in tabline, otherwise the content will not change
function! lightline#buffer#buffercurrent2()
  return '%{lightline#buffer#buffercurrent()}'
endfunction

function! lightline#buffer#bufferall()
  return "[[ '%{lightline#buffer#bufferbefore()}' ], " .
      \ "[ '%{lightline#buffer#buffercurrent()}' ], " .
      \ "[ '%{lightline#buffer#bufferafter()}' ]]"
endfunction

function! LightlineBufferEcho()
  echo g:lightline_buffer_status_info.before . '[' .
      \ g:lightline_buffer_status_info.current . ']' .
      \ g:lightline_buffer_status_info.after
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

