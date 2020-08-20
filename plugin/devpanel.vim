" =============================================================================
" File:			devpanel.vim
" Description:	manage an ide based window environment with other plugins
" Author:		David Hegland <darth.gerbil@gmail.com>
" License:		vim license
" Website:		https://github.com/raven42/devpanel-vim
" Version:		1.0
" Note:			this plugin uses NERDTree and Tagbar
" =============================================================================

if exists('g:loaded_devpanel')
	finish
endif

" Basic init {{{1

if v:version < 800
	echohl WarningMsg
	echomsg 'DevPanel: Vim version is too old. DevPanel requires at least 8.0'
	echohl None
	finish
endif

function! s:init_var(var, value) abort
	if !exists('g:devpanel_' . a:var)
		execute 'let g:devpanel_' . a:var . ' = ' . string(a:value)
	endif
endfunction

function! s:setup_options() abort

	let options = {
				\ 'use_lightline'		: 1,
				\ 'use_terminal'		: 0,
				\ 'use_flake8'			: 1,
				\ 'use_nerdtree'		: 1,
				\ 'use_tagbar'			: 1,
				\ 'show_line_num'		: 1,
				\ 'auto_open'			: 1,
				\ 'auto_open_files'		: '*.c,*.cpp,*.h,*.py,*.vim',
				\ 'open_min_width'		: 100,
				\ 'terminal_size'		: 10,
				\ 'panel_min'			: 40,
				\ 'panel_max'			: 80,
				\ 'user_defined_size'	: 0,
				\ }

	for [opt, val] in items(options)
		call s:init_var(opt, val)
	endfor

	execute ':autocmd VimEnter ' . g:devpanel_auto_open_files . ' DevPanelOpen'
endfunction

call s:setup_options()

augroup DevPanelResizeGroup
	autocmd!
	autocmd VimResized * call devpanel#DevPanelResize()
augroup END

command! -nargs=0 DevPanelOpen		call devpanel#DevPanelOpen()
command! -nargs=0 DevPanelClose		call devpanel#DevPanelClose()
command! -nargs=0 DevPanel			call devpanel#DevPanelToggle()
command! -nargs=0 DevPanelToggle	call devpanel#DevPanelToggle()
