
function! devpanel#DevPanelMarkWindow()
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

function! devpanel#DevPanelOpen()
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
	endif
endfunction

function! devpanel#DevPanelClose()
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

function! devpanel#DevPanelToggle()
	if (!exists('t:dev_panel_open'))
		let t:dev_panel_open = 0
	endif
	if (t:dev_panel_open == 1)
		silent call devpanel#DevPanelClose()
	else
		silent call devpanel#DevPanelOpen()
	endif
endfunction

function! devpanel#DevPanelSizeUpdate()
	let g:tagbar_height = winheight(0) / 2
	let g:NERDTreeWinSize = winwidth(0) > 150 ? 50 : winwidth(0) / 3
	redraw!
endfunction
