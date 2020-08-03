" =============================================================================
" file:			devpanel.vim
" description:	manage an ide based window environment with other plugins
" author:		david hegland <darth.gerbil@gmail.com>
" license:		vim license
" website:		https://github.com/raven42/devpanel-vim
" version:		1.0
" note:			this plugin uses nerdtree and tagbar
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
