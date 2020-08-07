" =============================================================================
" file:			devpanel.vim
" description:	manage an ide based window environment with other plugins
" author:		david hegland <darth.gerbil@gmail.com>
" license:		vim license
" website:		https://github.com/raven42/devpanel-vim
" version:		1.0
" note:			this plugin uses nerdtree and tagbar
" =============================================================================

" devpanel#DevPanelMarkWindow() {{{1
function! devpanel#DevPanelMarkWindow() abort
	let w:devpanel_marked_window = 1
endfunction

" devpanel#DevPanelActivateMarkedWindow() {{{1
function! devpanel#DevPanelActivateMarkedWindow(...)
	if a:0 == 1
		let clear_flag = a:1
	else
		let clear_flag = 1
	endif
	if !exists('w:devpanel_marked_window')
		for window in range(1, winnr('#'))
			if exists('w:devpanel_terminal')
				call feedkeys("\<C-\><C-N>")
			endif
			execute window . 'wincmd w'
			if exists('w:devpanel_marked_window')
				if s:config.use_tagbar
					call tagbar#Update()
				endif
				if s:config.use_lightline
					call lightline#update()
				endif
				break
			endif
		endfor
	endif
	if clear_flag && exists('w:devpanel_marked_window')
		unlet w:devpanel_marked_window
	endif
endfunction

" devpanel#DevPanelOpen() {{{1
function! devpanel#DevPanelOpen() abort
	if winwidth(0) < 100
		return
	endif
	if (!exists('t:devpanel_state'))
		let t:devpanel_state = 0
	endif
	if (t:devpanel_state == 0)
		let t:devpanel_state = 1
		if s:config.show_line_num
			set number
		endif
		call devpanel#DevPanelMarkWindow()
		call devpanel#DevPanelSizeUpdate()
		if s:config.use_nerdtree
			silent NERDTree
		endif
		if s:config.use_tagbar
			silent TagbarOpen
		endif
		call devpanel#DevPanelActivateMarkedWindow(0)

		" If we have flake8, and if this is a python file, run flake8
		if &filetype ==# 'python'
			call flake8#Flake8()
			let w:flake8_window = 1
		endif

		if s:config.use_terminal
			" Open terminal window
			let cmd = 'terminal ++rows=' . s:config.terminal_size
			echom 'running cmd=' . cmd
			execute cmd
		endif
		call devpanel#DevPanelActivateMarkedWindow()
		redraw!
	endif
endfunction

" devpanel#DevPanelClose() {{{1
function! devpanel#DevPanelClose() abort
	if (!exists('t:devpanel_state'))
		let t:devpanel_state = 0
	endif
	if (t:devpanel_state == 1)
		if s:config.show_line_num
			set nonumber
		endif
		let t:devpanel_state = 0
		if s:config.use_nerdtree
			silent NERDTreeClose
		endif
		if s:config.use_tagbar
			silent TagbarClose
		endif
	endif
endfunction

" devpanel#DevPanelToggle() {{{1
function! devpanel#DevPanelToggle() abort
	if (!exists('t:devpanel_state'))
		let t:devpanel_state = 0
	endif
	if (t:devpanel_state == 1)
		silent call devpanel#DevPanelClose()
	else
		silent call devpanel#DevPanelOpen()
	endif
endfunction

" devpanel#DevPanelSizeUpdate() {{{1
function! devpanel#DevPanelSizeUpdate() abort
	let g:tagbar_height = winheight(0) / 2
	let g:NERDTreeWinSize = winwidth(0) > s:config.window_max ? s:config.window_min : winwidth(0) / 3
	redraw!
endfunction

let s:config = {
			\ 'use_nerdtree':	1,
			\ 'use_tagbar':		1,
			\ 'use_lightline':	1,
			\ 'use_terminal':	0,
			\ 'show_line_num':	1,
			\ 'terminal_size':	10,
			\ 'window_min':		50,
			\ 'window_max':		150,
\}

let g:loaded_devpanel = 1
