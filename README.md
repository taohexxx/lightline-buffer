# lightline-buffer

A buffer plugin for [lightline.vim](https://github.com/itchyny/lightline.vim)

![lightline-buffer](http://taohex.github.io/lightline-buffer/images/lightline-buffer.png)

## Main Features

*	:star2: Clickable buffer switching

*	:pencil2: Show tab info and buffer info in tabline

*	:left_right_arrow: Support using left / right arrow key for quickly switching buffer

*	:mag: Auto-folding for long buffer name

*	:triangular_ruler: Scrollable when tabline length overflow screen

## Usage

1.	Make sure you've already installed [lightline.vim](https://github.com/itchyny/lightline.vim)

2.	Add this repo to your favorite vim plugin manager

	If you are using [Dein.vim](https://github.com/Shougo/dein.vim) (recommended)

	```vim
	call dein#add('taohex/lightline-buffer')
	```

	If you are using [NeoBundle](https://github.com/Shougo/neobundle.vim)

	```vim
	NeoBundle 'taohex/lightline-buffer'
	```

3.	Add this block to your init.vim (for neovim) or .vimrc (for vim)

	```vim
	set hidden  " allow buffer switching without saving
	set showtabline=2  " always show tabline

	" use lightline-buffer in lightline
	let g:lightline = {
		\ 'tabline': {
			\ 'left': [ [ 'bufferinfo' ], [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
			\ 'right': [ [ 'close' ], ],
			\ },
		\ 'component_expand': {
			\ 'buffercurrent': 'lightline#buffer#buffercurrent',
			\ 'bufferbefore': 'lightline#buffer#bufferbefore',
			\ 'bufferafter': 'lightline#buffer#bufferafter',
			\ },
		\ 'component_type': {
			\ 'buffercurrent': 'tabsel',
			\ 'bufferbefore': 'raw',
			\ 'bufferafter': 'raw',
			\ },
		\ 'component_function': {
			\ 'bufferinfo': 'lightline#buffer#bufferinfo',
			\ },
		\ }

	" remap arrow keys
	nnoremap <Left> :bprev<CR>
	nnoremap <Right> :bnext<CR>

	" lightline-buffer ui settings
	" replace these symbols with ascii characters if your environment does not support unicode
	let g:lightline_buffer_logo = ' '
	let g:lightline_buffer_readonly_icon = ''
	let g:lightline_buffer_modified_icon = '✭'
	let g:lightline_buffer_git_icon = ' '
	let g:lightline_buffer_ellipsis_icon = '..'
	let g:lightline_buffer_expand_left_icon = '◀ '
	let g:lightline_buffer_expand_right_icon = ' ▶'
	let g:lightline_buffer_active_buffer_left_icon = ''
	let g:lightline_buffer_active_buffer_right_icon = ''
	let g:lightline_buffer_separator_icon = '  '

	" lightline-buffer function settings
	let g:lightline_buffer_show_bufnr = 1
	let g:lightline_buffer_rotate = 0
	let g:lightline_buffer_fname_mod = ':t'
	let g:lightline_buffer_excludes = ['vimfiler']

	let g:lightline_buffer_maxflen = 30
	let g:lightline_buffer_maxfextlen = 3
	let g:lightline_buffer_minflen = 16
	let g:lightline_buffer_minfextlen = 3
	let g:lightline_buffer_reservelen = 20
	```

## Changes

**IMPORTANT**: The `component_expand`, `component_type` and `component_function` settings in the config has been changed. It's NOT compatible with old versions. Please update your config file.

## Examples

[Navim](https://github.com/taohex/navim)

