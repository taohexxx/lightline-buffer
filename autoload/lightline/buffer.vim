" =============================================================================
" File: autoload/lightline/buffer.vim
" Author: taohe <taohex@gmail.com>
" License: MIT License
" Updated: 2018/03/04
" Version: 2.0.0
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

function! s:check_deprecated_defined(variable, deprecated_variable, default)
  if !exists(a:variable) && !exists(a:deprecated_variable)
    let {a:variable} = a:default
    return
  endif
  if exists(a:variable)
    return
  endif
  if exists(a:deprecated_variable)
    let {a:variable} = a:deprecated_variable
    return
  endif
endfunction

" icon
call s:check_defined('g:lightline_buffer_logo', '')
call s:check_defined('g:lightline_buffer_readonly_icon', 'RO')
call s:check_defined('g:lightline_buffer_modified_icon', '*')
call s:check_defined('g:lightline_buffer_git_icon', '')
call s:check_defined('g:lightline_buffer_ellipsis_icon', '..')
call s:check_defined('g:lightline_buffer_expand_left_icon', '<')
call s:check_defined('g:lightline_buffer_expand_right_icon', '>')
call s:check_defined('g:lightline_buffer_active_buffer_left_icon', '')
call s:check_defined('g:lightline_buffer_active_buffer_right_icon', '')
call s:check_defined('g:lightline_buffer_separator_left_icon', ' ')
call s:check_defined('g:lightline_buffer_separator_right_icon', ' ')
call s:check_defined('g:lightline_buffer_attribute_separator_icon', ' ')
call s:check_defined('g:lightline_buffer_type_separator_icon', ' ')

" enable devicons, only support utf-8
" require <https://github.com/ryanoasis/vim-devicons>
call s:check_defined('g:lightline_buffer_enable_devicons', 1)

" show buffer number
call s:check_defined('g:lightline_buffer_show_bufnr', 1)

" show debug info
call s:check_defined('g:lightline_buffer_debug_info', 0)

"call s:check_defined('g:lightline_buffer_rotate', 0)

" :help filename-modifiers
call s:check_defined('g:lightline_buffer_fname_mod', ':t')  " ':.'

" hide buffer list
call s:check_defined('g:lightline_buffer_excludes', ['vimfiler'])

" max file name length
call s:check_defined('g:lightline_buffer_maxflen', 30)

" max file extension length
call s:check_defined('g:lightline_buffer_maxfextlen', 3)

" min file name length
call s:check_defined('g:lightline_buffer_minflen', 16)

" min file extension length
call s:check_defined('g:lightline_buffer_minfextlen', 3)

" reserve length for other component (e.g. info, close)
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

" lazy recalc
"let g:last_current_bufnr = 0

" <https://vi.stackexchange.com/questions/4947/is-there-a-version-of-strpart-that-is-aware-of-characters-rather-than-bytes>

if exists('*strcharpart')
  function! s:mb_str_part(mb_string, start, len)
    return strcharpart(a:mb_string, a:start, a:len)
  endfunction
else
  function! s:mb_str_part(mb_string, start, len)
    return matchstr(a:mb_string, '.\{,' . a:len . '}', 0, a:start + 1)
  endfunction
endif

if exists('*strdisplaywidth')
  function! s:mb_str_len(mb_string)
    return strdisplaywidth(a:mb_string)
  endfunction
else
  function! s:mb_str_len(mb_string)
    return strlen(substitute(a:mb_string, '.', 'a', 'g'))
  endfunction
endif

let g:lightline_buffer_active_buffer_left_icon_len =
      \ s:mb_str_len(g:lightline_buffer_active_buffer_left_icon)
let g:lightline_buffer_active_buffer_right_icon_len =
      \ s:mb_str_len(g:lightline_buffer_active_buffer_right_icon)
let g:lightline_buffer_separator_left_icon_len =
      \ s:mb_str_len(g:lightline_buffer_separator_left_icon)
let g:lightline_buffer_separator_right_icon_len =
      \ s:mb_str_len(g:lightline_buffer_separator_right_icon)
let g:lightline_buffer_expand_left_icon_len =
      \ s:mb_str_len(g:lightline_buffer_expand_left_icon)
let g:lightline_buffer_expand_right_icon_len =
      \ s:mb_str_len(g:lightline_buffer_expand_right_icon)
let g:lightline_buffer_ellipsis_icon_len =
      \ s:mb_str_len(g:lightline_buffer_ellipsis_icon)

function! s:shorten_name(name, newlen, extlen, oldlen)
  if a:oldlen <= a:newlen
    return a:name
  endif

  return s:mb_str_part(a:name, 0,
      \ a:newlen - g:lightline_buffer_ellipsis_icon_len - a:extlen) .
      \ g:lightline_buffer_ellipsis_icon .
      \ s:mb_str_part(a:name, a:oldlen - a:extlen, a:extlen)
endfunction

function! s:clickable_text(text, minwid)
  if has('tablineat')
    return '%' . a:minwid . '@lightline#buffer#clickbuf@' . a:text . '%X'
  endif

  return a:text
endfunction

function! s:shorten_left(str, newlen, oldlen, my_minwid, left_minwid)
  if a:oldlen + g:lightline_buffer_expand_left_icon_len <= a:newlen
    return a:str
  endif

  if a:my_minwid < 0 || a:left_minwid < 0
    return g:lightline_buffer_expand_left_icon .
        \ s:mb_str_part(a:str,
        \ a:oldlen - a:newlen + g:lightline_buffer_expand_left_icon_len,
        \ a:newlen - g:lightline_buffer_expand_left_icon_len)
  endif

  return s:clickable_text(g:lightline_buffer_expand_left_icon, a:left_minwid) .
      \ s:clickable_text(s:mb_str_part(a:str,
      \ a:oldlen - a:newlen + g:lightline_buffer_expand_left_icon_len,
      \ a:newlen - g:lightline_buffer_expand_left_icon_len), a:my_minwid)
endfunction

function! s:shorten_right(str, newlen, oldlen, my_minwid, right_minwid)
  if a:oldlen + g:lightline_buffer_expand_right_icon_len <= a:newlen
    return a:str
  endif
  if a:my_minwid < 0 || a:right_minwid < 0
    return s:mb_str_part(a:str, 0,
        \ a:newlen - g:lightline_buffer_expand_right_icon_len) .
        \ g:lightline_buffer_expand_right_icon
  endif

  return s:clickable_text(s:mb_str_part(a:str,
      \ 0, a:newlen - g:lightline_buffer_expand_right_icon_len), a:my_minwid) .
      \ s:clickable_text(g:lightline_buffer_expand_right_icon, a:right_minwid)
endfunction

function! s:int_compare(l, r)
  return a:l - a:r
endfunction

function! s:generate_buffer_names()
  let l:flensum = 0
  "let l:current_bufnr = bufnr('%')
  let l:len2bufnrs = {}
  " key is always string in map
  let l:bufnr2names = {}

  for nr in range(1, bufnr('$'))
    if bufexists(nr) && buflisted(nr)
      " fname
      let l:fname = bufname(nr)
      if l:fname !=# ''
        if has('modify_fname')
          let l:fname = fnamemodify(l:fname, g:lightline_buffer_fname_mod)
        endif
        " % is a legal char in file name, but a escape char in vim
        let l:fname = substitute(l:fname, "%", "%%", "g")
      else
        let l:fname = '[No Name]'
      endif

      " attribute
      let l:attribute = ''
      if getbufvar(nr, '&mod')
        let l:attribute = g:lightline_buffer_attribute_separator_icon .
            \ g:lightline_buffer_modified_icon
      endif
      if (getbufvar(nr, '&readonly') || !getbufvar(nr, '&modifiable')) &&
          \ getbufvar(nr, '&filetype') != 'help'
        let l:attribute = g:lightline_buffer_attribute_separator_icon .
            \ g:lightline_buffer_readonly_icon
      endif

      " icon
      let l:icon = ''
      if g:lightline_buffer_enable_devicons &&
          \ exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
        " WebDevIconsGetFileTypeSymbol output symbol and a space
        " not need to add a space by your self
        let l:icon = g:lightline_buffer_type_separator_icon .
            \ WebDevIconsGetFileTypeSymbol(l:fname, isdirectory(l:fname))
      endif

      " merge
      let l:skip = 0
      for exclude in g:lightline_buffer_excludes
        if match(l:fname, exclude) > -1
          let l:skip = 1
          break
        endif
      endfor

      if !l:skip
        let l:foldlen = s:mb_str_len(l:fname)
        if l:foldlen > g:lightline_buffer_maxflen
          let l:fname = s:shorten_name(l:fname, g:lightline_buffer_maxflen,
              \ g:lightline_buffer_maxfextlen, l:foldlen)
        endif

        let l:name = ''
        "if g:lightline_buffer_show_bufnr != 0 &&
        "    \ g:lightline_buffer_status_info.count >=
        "    \ g:lightline_buffer_show_bufnr
        "  let l:name = nr . ' '
        "endif
        let l:name .= l:fname . l:attribute . l:icon

        "if l:current_bufnr == nr
        "  let l:name = g:lightline_buffer_separator_left_icon .
        "      \ g:lightline_buffer_active_buffer_left_icon . l:name .
        "      \ g:lightline_buffer_active_buffer_right_icon .
        "      \ g:lightline_buffer_separator_right_icon
        "  let g:lightline_buffer_status_info.current = l:name
        "else
        "  let l:name = g:lightline_buffer_separator_left_icon . l:name .
        "      \ g:lightline_buffer_separator_right_icon
        "endif

        let l:bufnr2names[nr] = l:name

        let l:namelen = s:mb_str_len(l:name)
        "if get(l:len2bufnrs, l:namelen) == 0
        "  let l:len2bufnrs[l:namelen] = []
        "endif
        "call add(l:len2bufnrs[l:namelen], nr)
        "l:len2bufnrs[l:namelen] += [nr]
        if get(l:len2bufnrs, l:namelen) == 0
          let l:len2bufnrs[l:namelen] = ''
        endif
        let l:len2bufnrs[l:namelen] .= nr . ' '

        let l:flensum += g:lightline_buffer_separator_left_icon_len +
            \ l:namelen + g:lightline_buffer_separator_right_icon_len
        if g:lightline_buffer_show_bufnr != 0
          " add number and space
          let l:flensum += s:mb_str_len(nr) + 1
        endif
      endif
    endif
  endfor
  let l:flensum += g:lightline_buffer_active_buffer_left_icon_len +
      \ g:lightline_buffer_active_buffer_right_icon_len

  let g:lightline_buffer_status_info.info = ''
  let l:namelens = sort(keys(l:len2bufnrs), "s:int_compare")

  " debug only
  "for namelen in l:namelens
  "  let g:lightline_buffer_status_info.info .= namelen . ': '
  "  "for bufnr in l:len2bufnrs[namelen]
  "  let l:bufnrs = split(l:len2bufnrs[namelen])
  "  for bufnr in l:bufnrs
  "    let g:lightline_buffer_status_info.info .= bufnr . ' ' .
  "        \ l:bufnr2names[bufnr] . ', '
  "  endfor
  "  let g:lightline_buffer_status_info.info .= '; '
  "endfor
  let g:lightline_buffer_status_info.info = g:lightline_buffer_logo .
      \ tabpagenr() . '/' . tabpagenr('$')

  for namelen in l:namelens
    if l:flensum + g:lightline_buffer_reservelen <= &columns
      break
    endif
    "for bufnr in l:len2bufnrs[namelen]
    let l:bufnrs = split(l:len2bufnrs[namelen])
    for bufnr in l:bufnrs
      if l:flensum + g:lightline_buffer_reservelen <= &columns
        continue
      endif
      let l:foldlen = s:mb_str_len(l:bufnr2names[bufnr])
      let l:bufnr2names[bufnr] = s:shorten_name(l:bufnr2names[bufnr],
          \ g:lightline_buffer_minflen,
          \ g:lightline_buffer_minfextlen, l:foldlen)
      let l:fnewlen = s:mb_str_len(l:bufnr2names[bufnr])
      let l:flensum -= l:foldlen - l:fnewlen
    endfor
  endfor
  "let l:i = 0
  "while l:i < len(l:names)
  "  if l:flensum + g:lightline_buffer_reservelen > &columns
  "    let l:foldlen = s:mb_str_len(l:names[l:i][1])
  "    let l:names[l:i][1] = s:shorten_name(l:names[l:i][1],
  "        \ g:lightline_buffer_minflen,
  "        \ g:lightline_buffer_minfextlen, l:foldlen)
  "    let l:fnewlen = s:mb_str_len(l:names[l:i][1])
  "    let l:flensum -= l:foldlen - l:fnewlen
  "  endif
  "  let l:i += 1
  "endwhile
  let l:names = []
  for bufnr in sort(keys(l:bufnr2names), "s:int_compare")
    call add(l:names, [bufnr, l:bufnr2names[bufnr]])
  endfor

  "if len(l:names) > 1
  "  if g:lightline_buffer_rotate == 1
  "    call bufferline#algos#fixed_position#modify(l:names)
  "  endif
  "endif

  return l:names
endfunction

function! s:cat_buffer_names(names, current_bufnr,
    \ shorten_left_len, shorten_right_len)
  let l:current_str = ''
  let l:before_str = ''
  let l:after_str = ''
  let l:visable_current_str = ''
  let l:visable_before_str = ''
  let l:visable_after_str = ''
  let l:visable_before_str_len = 0
  let l:visable_after_str_len = 0
  "let l:debug_str = ''

  " current - from left to right
  for nr in range(0, len(a:names) - 1)
    let l:val = a:names[nr]
    if l:val[0] == a:current_bufnr
      let l:display_name = ''
      if g:lightline_buffer_show_bufnr != 0
          let l:display_name .= l:val[0] . ' ' . l:val[1]
      else
          let l:display_name .= l:val[1]
      endif

      "let l:debug_str .= '=' . l:display_name
      let l:current_str .= l:display_name
      let l:visable_current_str .= l:display_name
    endif
  endfor

  " before - from right to left
  for nr in range(len(a:names) - 1, 0, -1)
    let l:val = a:names[nr]
    if l:val[0] < a:current_bufnr
      let l:display_name = ''
      if g:lightline_buffer_show_bufnr != 0
          let l:display_name .= l:val[0] . ' ' . l:val[1]
      else
          let l:display_name .= l:val[1]
      endif

      "let l:debug_str .= '<' . l:display_name
      let l:temp_visable_str = g:lightline_buffer_separator_left_icon .
          \ l:display_name . g:lightline_buffer_separator_right_icon

      if a:shorten_left_len > 0
        if 0 != g:lightline_buffer_debug_info
          let g:lightline_buffer_status_info.info = a:shorten_left_len
        endif
        if l:visable_before_str_len < a:shorten_left_len
          let l:temp_visable_str_len = s:mb_str_len(l:temp_visable_str)
          if l:visable_before_str_len + l:temp_visable_str_len >=
              \ a:shorten_left_len
            let l:temp_str = s:shorten_left(l:temp_visable_str,
                \ a:shorten_left_len - l:visable_before_str_len,
                \ l:temp_visable_str_len, l:val[0], a:names[0][0])
            let l:before_str = l:temp_str . l:before_str
            let l:temp_visable_str = s:shorten_left(l:temp_visable_str,
                \ a:shorten_left_len - l:visable_before_str_len,
                \ l:temp_visable_str_len, -1, -1)
          else
            let l:before_str = s:clickable_text(l:temp_visable_str, l:val[0]) .
                \ l:before_str
          endif
          let l:visable_before_str = l:temp_visable_str . l:visable_before_str
        endif
      else
        let l:visable_before_str = l:temp_visable_str . l:visable_before_str
        let l:before_str = s:clickable_text(l:temp_visable_str, l:val[0]) .
              \ l:before_str
      endif

      let l:visable_before_str_len = s:mb_str_len(l:visable_before_str)
    endif
  endfor

  " before - left icon
  let l:before_str .= g:lightline_buffer_active_buffer_left_icon
  let l:visable_before_str .= g:lightline_buffer_active_buffer_left_icon
  let l:visable_before_str_len = s:mb_str_len(l:visable_before_str)

  " after - from left to right
  for nr in range(0, len(a:names) - 1)
    let l:val = a:names[nr]
    if l:val[0] > a:current_bufnr
      let l:display_name = ''
      if g:lightline_buffer_show_bufnr != 0
          let l:display_name .= l:val[0] . ' ' . l:val[1]
      else
          let l:display_name .= l:val[1]
      endif

      "let l:debug_str .= '>' . l:display_name
      let l:temp_visable_str = g:lightline_buffer_separator_left_icon .
          \ l:display_name . g:lightline_buffer_separator_right_icon

      if a:shorten_right_len > 0
        if 0 != g:lightline_buffer_debug_info
          let g:lightline_buffer_status_info.info = a:shorten_right_len
        endif
        if l:visable_after_str_len < a:shorten_right_len
          let l:temp_visable_str_len = s:mb_str_len(l:temp_visable_str)
          if l:visable_after_str_len + l:temp_visable_str_len >=
              \ a:shorten_right_len
            let l:temp_str = s:shorten_right(l:temp_visable_str,
                \ a:shorten_right_len - l:visable_after_str_len,
                \ l:temp_visable_str_len, l:val[0],
                \ a:names[len(a:names) - 1][0])
            let l:after_str .= l:temp_str
            let l:temp_visable_str = s:shorten_right(l:temp_visable_str,
                \ a:shorten_right_len - l:visable_after_str_len,
                \ l:temp_visable_str_len, -1, -1)
          else
            let l:after_str .= s:clickable_text(l:temp_visable_str, l:val[0])
          endif
          let l:visable_after_str .= l:temp_visable_str
        endif
      else
        let l:visable_after_str .= l:temp_visable_str
        let l:after_str .= s:clickable_text(l:temp_visable_str, l:val[0])
      endif

      let l:visable_after_str_len = s:mb_str_len(l:visable_after_str)
    endif
  endfor

  " after - #8 not empty tabline_separator
  " if before_str empty and tabline_separator not empty
  " should add a space to after_str to keep text static
  let l:tabline_separator_not_empty =
      \ exists('g:lightline.tabline_separator.left') &&
      \ '' != g:lightline.tabline_separator.left
  let l:separator_not_empty =
      \ exists('g:lightline.separator.left') &&
      \ '' != g:lightline.separator.left
  if (l:tabline_separator_not_empty || l:separator_not_empty) &&
      \ '' == l:before_str && '' == l:visable_before_str
    let l:after_str = ' ' . l:after_str
    let l:visable_after_str = ' ' . l:visable_after_str
    let l:visable_after_str_len = s:mb_str_len(l:visable_after_str)
  endif

  " after - right icon
  let l:after_str = g:lightline_buffer_active_buffer_right_icon . l:after_str
  let l:visable_after_str = g:lightline_buffer_active_buffer_right_icon .
      \ l:visable_after_str
  let l:visable_after_str_len = s:mb_str_len(l:visable_after_str)

  " all
  let l:strs = [ l:current_str, l:before_str, l:after_str,
      \ l:visable_current_str, l:visable_before_str, l:visable_after_str ]
  "echo l:debug_str

  return l:strs
endfunction

function! lightline#buffer#bufferline()
  let l:current_bufnr = bufnr('%')
  " check for special cases like help files
  if !bufexists(l:current_bufnr) || !buflisted(l:current_bufnr)
    return ''
  endif
  " lazy recalc
  "if g:last_current_bufnr == l:current_bufnr
  "  return g:lightline_buffer_status_info.before .
  "      \ '[' . g:lightline_buffer_status_info.current . ']' .
  "      \ g:lightline_buffer_status_info.after
  "endif

  let l:names = s:generate_buffer_names()

  " debug only
  "let l:flensum = 0
  "for nr in range(1, bufnr('$'))
  "  if bufexists(nr) && buflisted(nr)
  "    let l:fname = bufname(nr)
  "    if nr < l:current_bufnr
  "      let l:before_str .= g:lightline_buffer_separator_left_icon . nr .
  "          \ ' ' . l:fname . g:lightline_buffer_separator_right_icon
  "    elseif nr > l:current_bufnr
  "      let l:after_str .= g:lightline_buffer_separator_left_icon . nr .
  "          \ ' ' . l:fname . g:lightline_buffer_separator_right_icon
  "    else
  "      let l:current_str .= g:lightline_buffer_separator_left_icon .
  "          \ g:lightline_buffer_active_buffer_left_icon . nr .
  "          \ ' ' . l:fname . g:lightline_buffer_active_buffer_right_icon .
  "          \ g:lightline_buffer_separator_right_icon
  "    endif
  "
  "    " add number, space and separator
  "    let l:flensum += g:lightline_buffer_separator_left_icon_len +
  "        \ nr + 1 + l:fname +
  "        \ g:lightline_buffer_separator_right_icon_len
  "    if nr == l:current_bufnr
  "      let l:flensum +=
  "          \ g:lightline_buffer_active_buffer_left_icon_len +
  "          \ g:lightline_buffer_active_buffer_right_icon_len
  "  endif
  "endfor

  "echo l:names
  let l:strs = s:cat_buffer_names(l:names, l:current_bufnr, -1, -1)
  let l:current_str = l:strs[0]
  let l:before_str = l:strs[1]
  let l:after_str = l:strs[2]
  let l:visable_current_str = l:strs[3]
  let l:visable_before_str = l:strs[4]
  let l:visable_after_str = l:strs[5]
  " debug only
  "echo l:before_str . '[' . l:current_str . ']' . l:after_str

  let l:visable_current_str_len = s:mb_str_len(l:visable_current_str)
  let l:visable_before_str_len = s:mb_str_len(l:visable_before_str)
  let l:visable_after_str_len = s:mb_str_len(l:visable_after_str)
  "let l:flensum = l:visable_current_str_len + l:visable_before_str_len +
  "    \ l:visable_after_str_len
  "let g:lightline_buffer_status_info.info = l:flensum . ' ' . &columns
  let g:lightline_buffer_status_info.count = len(l:names)
  let g:lightline_buffer_status_info.current = l:current_str
  if l:visable_before_str_len + l:visable_current_str_len +
      \ l:visable_after_str_len + g:lightline_buffer_reservelen > &columns
    let l:max_part_len = (&columns - l:visable_current_str_len -
        \ g:lightline_buffer_reservelen) / 2

    " shorten
    if l:visable_before_str_len <= l:max_part_len
      let l:shorten_right_len = &columns - l:visable_current_str_len -
          \ l:visable_before_str_len - g:lightline_buffer_reservelen

      let l:strs = s:cat_buffer_names(l:names, l:current_bufnr,
          \ -1, l:shorten_right_len)
      let l:current_str = l:strs[0]
      let l:before_str = l:strs[1]
      let l:after_str = l:strs[2]
      "let l:visable_current_str = l:strs[3]
      "let l:visable_before_str = l:strs[4]
      "let l:visable_after_str = l:strs[5]

      let g:lightline_buffer_status_info.before = l:before_str
      let g:lightline_buffer_status_info.after = l:after_str

      if 0 != g:lightline_buffer_debug_info
        let g:lightline_buffer_status_info.info .= '>' . &columns . '-' .
            \ g:lightline_buffer_reservelen
      endif
    elseif l:visable_after_str_len <= l:max_part_len
      let l:shorten_left_len = &columns - l:visable_current_str_len -
          \ l:visable_after_str_len - g:lightline_buffer_reservelen

      let l:strs = s:cat_buffer_names(l:names, l:current_bufnr,
          \ l:shorten_left_len, -1)
      let l:current_str = l:strs[0]
      let l:before_str = l:strs[1]
      let l:after_str = l:strs[2]
      "let l:visable_current_str = l:strs[3]
      "let l:visable_before_str = l:strs[4]
      "let l:visable_after_str = l:strs[5]

      let g:lightline_buffer_status_info.before = l:before_str
      let g:lightline_buffer_status_info.after = l:after_str

      if 0 != g:lightline_buffer_debug_info
        let g:lightline_buffer_status_info.info .= '<' . &columns . '-' .
            \ g:lightline_buffer_reservelen
      endif
    else
      let l:strs = s:cat_buffer_names(l:names, l:current_bufnr,
          \ l:max_part_len, l:max_part_len)

      let l:current_str = l:strs[0]
      let l:before_str = l:strs[1]
      let l:after_str = l:strs[2]
      "let l:visable_current_str = l:strs[3]
      "let l:visable_before_str = l:strs[4]
      "let l:visable_after_str = l:strs[5]

      let g:lightline_buffer_status_info.before = l:before_str
      let g:lightline_buffer_status_info.after = l:after_str

      if 0 != g:lightline_buffer_debug_info
        let g:lightline_buffer_status_info.info = l:max_part_len
        let g:lightline_buffer_status_info.info .= '<>' . &columns . '-' .
            \ g:lightline_buffer_reservelen
      endif
    endif

  else
    let g:lightline_buffer_status_info.before = l:before_str
    let g:lightline_buffer_status_info.after = l:after_str

    if 0 != g:lightline_buffer_debug_info
      let g:lightline_buffer_status_info.info = '=' . &columns . '-' .
          \ g:lightline_buffer_reservelen
    endif
  endif

  " debug only
  "let g:lightline_buffer_status_info.info = l:visable_before_str_len . '+' .
  "    \ l:visable_current_str_len . '+' . l:visable_after_str_len . '+' .
  "    \ g:lightline_buffer_reservelen . '~' . &columns
  "let g:lightline_buffer_status_info.before =
  "    \ s:shorten_left(l:before_str, l:visable_before_str_len - 14,
  "    \ l:visable_before_str_len, -1)
  "let g:lightline_buffer_status_info.after =
  "    \ s:shorten_right(l:after_str, l:visable_after_str_len - 14,
  "    \ l:visable_after_str_len, -1)
  let l:line = l:before_str . '[' . l:current_str . ']' . l:after_str

  " lazy recalc
  "echo 'g:last_current_bufnr: ' . g:last_current_bufnr .
  "    \ ', l:current_bufnr: ' . l:current_bufnr
  "let g:last_current_bufnr = l:current_bufnr

  return l:line
endfunction

function! lightline#buffer#bufferinfo()
  call lightline#buffer#bufferline()
  if exists('g:lightline_buffer_status_info.info')
    return g:lightline_buffer_status_info.info
  endif
  return ''
endfunction

function! lightline#buffer#bufferbefore()
  call lightline#buffer#bufferline()
  if exists('g:lightline_buffer_status_info.before')
    return g:lightline_buffer_status_info.before
  endif
  return ''
endfunction

function! lightline#buffer#bufferafter()
  call lightline#buffer#bufferline()
  if exists('g:lightline_buffer_status_info.after')
    return g:lightline_buffer_status_info.after
  endif
  return ''
endfunction

function! lightline#buffer#buffercurrent()
  call lightline#buffer#bufferline()
  if exists('g:lightline_buffer_status_info.current')
    return g:lightline_buffer_status_info.current
  endif
  return ''
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

function! lightline#buffer#clickbuf(minwid, clicks, button, modifiers) abort
  " clickable buffers
  " works only in NeoVim with has('tablineat')

  " debug only
  "echo 'lightline#buffer#clickbuf()'
  "echo 'num: ' . a:minwid
  "echo 'clicks: ' . a:clicks
  "echo 'button: ' . a:button
  "echo 'modifiers: ' . a:modifiers
  "let g:res = 'lightline#buffer#clickbuf(' . a:minwid . ', '
  "    \ . a:clicks . ', ' . a:button . ', ' . a:modifiers . ')'
  "echo g:res

  " single mouse button click without modifiers pressed
  if a:clicks == 1 && a:modifiers !~# '[^ ]'
    if a:button is# 'l'  " left button - switch to buffer
      silent execute 'buffer' a:minwid
    elseif a:button is# 'm'  " middle button - delete buffer
      silent execute 'bdelete' a:minwid
    endif
  endif
endfunction

function! LightlineBufferEcho()
  echo g:lightline_buffer_status_info.before . '[' .
      \ g:lightline_buffer_status_info.current . ']' .
      \ g:lightline_buffer_status_info.after
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

