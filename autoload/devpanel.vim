" =============================================================================
" file:			devpanel.vim
" description:	manage an ide based window environment with other plugins
" author:		david hegland <darth.gerbil@gmail.com>
" license:		vim license
" website:		https://github.com/raven42/devpanel-vim
" version:		1.0
" note:			this plugin uses nerdtree and tagbar
" =============================================================================

function! devpanel#DevPanelMarkWindow() abort
	let w:devpanel_marked_window = 1
endfunction

function! devpanel#DevPanelActivateMarkedWindow()
	for window in range(1, winnr('#'))
		execute window . 'wincmd w'
		if exists('w:devpanel_marked_window')
			unlet w:devpanel_marked_window
			call tagbar#Update()
			call lightline#update()
			return
		endif
	endfor
endfunction

function! devpanel#DevPanelOpen() abort
	if winwidth(0) < 100
		return
	endif
	if (!exists('t:dev_panel_open'))
		let t:dev_panel_open = 0
	endif
	if (t:dev_panel_open == 0)
		set number
		let t:dev_panel_open = 1
		call devpanel#DevPanelMarkWindow()
		call devpanel#DevPanelSizeUpdate()
		if $GIT_ROOT != ""
			silent NERDTree ${GIT_ROOT}/vobs/projects/springboard/fabos/
			silent NERDTreeFind
		else
			silent NERDTree %
		endif
		silent TagbarOpen
		"echom 'Activating marked window...'
		call devpanel#DevPanelActivateMarkedWindow()

		" If we have flake8, and if this is a python file, run flake8
		if &filetype ==# 'python'
			call devpanel#DevPanelMarkWindow()
			call flake8#Flake8()
			let w:flake8_window = 1
			call devpanel#DevPanelActivateMarkedWindow()
		endif

		" Open terminal window
		" terminal ++rows=15
		redraw!
	endif
endfunction

function! devpanel#DevPanelClose() abort
	if (!exists('t:dev_panel_open'))
		let t:dev_panel_open = 0
	endif
	if (t:dev_panel_open == 1)
		set nonumber
		let t:dev_panel_open = 0
		silent NERDTreeClose
		silent TagbarClose
	endif
endfunction

function! devpanel#DevPanelToggle() abort
	if (!exists('t:dev_panel_open'))
		let t:dev_panel_open = 0
	endif
	if (t:dev_panel_open == 1)
		silent call devpanel#DevPanelClose()
	else
		silent call devpanel#DevPanelOpen()
	endif
endfunction

function! devpanel#DevPanelSizeUpdate() abort
	let g:tagbar_height = winheight(0) / 2
	let g:NERDTreeWinSize = winwidth(0) > 150 ? 50 : winwidth(0) / 3
	redraw!
endfunction

let g:loaded_devpanel = 1
