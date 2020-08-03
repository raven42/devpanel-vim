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
	echomsg 'DevPanel: Vim version is too old. DevPanel requires at least 8.0
	echohl None
	finish
endif

augroup DevPanelSession
	autocmd!
	autocmd VimResized * call DevPanelResize
augroup END

command! -nargs=0 DevPanel			call devpanel#DevPanelOpen()
command! -nargs=0 DevPanelClose		call devpanel#DevPanelClose()
command! -nargs=0 DevPanelToggle	call devpanel#DevPanelToggle()
