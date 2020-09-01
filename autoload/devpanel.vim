" =============================================================================
" File:			devpanel.vim
" Description:	manage an ide based window environment with other plugins
" Author:		David Hegland <darth.gerbil@gmail.com>
" License:		vim license
" Website:		https://github.com/raven42/devpanel-vim
" Version:		1.0
" Note:			This plugin uses nerdtree and tagbar
" =============================================================================

" s:DevPanelMarkWindow() {{{1
function! s:DevPanelMarkWindow() abort
	let w:devpanel_marked_window = 1
endfunction

" s:DevPanelActivateMarkedWindow() {{{1
function! s:DevPanelActivateMarkedWindow(...)
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
				if g:devpanel_use_tagbar
					call tagbar#Update()
				endif
				if g:devpanel_use_lightline
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

" s:DevPanelSizeUpdate() {{{1
function! s:DevPanelSizeUpdate() abort
	let def_panel_width = winwidth(0) / 3
	let def_panel_height = winheight(0) / 2
	if g:devpanel_user_defined_size
		return
	endif
	if g:devpanel_use_tagbar
		let g:tagbar_height = def_panel_height
		let g:tagbar_width =
					\ def_panel_width > g:devpanel_panel_max ? g:devpanel_panel_max : 
					\ def_panel_width < g:devpanel_panel_min ? g:devpanel_panel_min :
					\ def_panel_width
		let g:tagbar_position = 'rightbelow'
		let g:tagbar_previewwin_pos = 'botright'
	endif
	if g:devpanel_use_nerdtree
		let g:NERDTreeWinSize =
					\ def_panel_width > g:devpanel_panel_max ? g:devpanel_panel_max : 
					\ def_panel_width < g:devpanel_panel_min ? g:devpanel_panel_min :
					\ def_panel_width
	endif
endfunction

" devpanel#DevPanelOpen() {{{1
function! devpanel#DevPanelOpen() abort
	if winwidth(0) < g:devpanel_open_min_width && g:devpanel_auto_open == 1
		return
	endif
	if (!exists('t:devpanel_state'))
		let t:devpanel_state = 0
	endif
	if (t:devpanel_state == 0)
		let t:devpanel_state = 1
		if g:devpanel_show_line_num
			set number
		endif
		call s:DevPanelMarkWindow()
		call s:DevPanelSizeUpdate()
		if g:devpanel_use_nerdtree
			silent NERDTree
		endif
		if g:devpanel_use_tagbar
			silent TagbarOpen
		endif
		call s:DevPanelActivateMarkedWindow(0)

		" If we have flake8, and if this is a python file, run flake8
		if &filetype ==# 'python'
			call flake8#Flake8()
			let w:flake8_window = 1
		endif

		if g:devpanel_use_terminal
			" Open terminal window
			let cmd = 'terminal ++rows=' . g:devpanel_terminal_size
			execute cmd
		endif
		call s:DevPanelActivateMarkedWindow()
		redraw!
	endif
endfunction

" devpanel#DevPanelClose() {{{1
function! devpanel#DevPanelClose() abort
	if (!exists('t:devpanel_state'))
		let t:devpanel_state = 0
	endif
	if (t:devpanel_state == 1)
		if g:devpanel_show_line_num
			set nonumber
		endif
		let t:devpanel_state = 0
		if g:devpanel_use_nerdtree
			silent NERDTreeClose
		endif
		if g:devpanel_use_tagbar
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

" devpanel#DevPanelResize() {{{1
function! devpanel#DevPanelResize() abort
	call s:DevPanelSizeUpdate()
	redraw!
endfunction

let g:loaded_devpanel = 1
