devpanel - Development Panel Window plugin for VIM

This plugin acts as a window manager for integrating the NERDTree and Tagbar plugins together into a more streamlined interface. Using
the recommended configurations as listed in the devpanel-integrations section, the following look can be achieved. The basic layout
using these recommended configurations will appear as the following:

![DevPanelExample](https://user-images.githubusercontent.com/3730811/90820816-97373a80-e2f7-11ea-93ab-c42b1b0e557b.png "DevPanel Example")

## Installation
Vim Packages
```
git clone https://github.com/raven42/devpanel-vim ~/.vim/pack/plugins/start/devpanel-vim
```

## Requirements
This plugin integrates with the following plugins. These must be installed in order to fully use them.

### [NERDTree](https://github.com/preservim/nerdtree)
NERDTree is used as a file browser on the upper left panel.

### [Tagbar](https://github.com/majutsushi/tagbar)
Tagbar is used as a tag browser in the lower left panel.

### [Lightline](https://github.com/itchyny/lightline.vim)
There is a small integration point with lightline to forceably trigger an update upon window creation / movement.

### [Flake8](https://github.com/nvie/vim-flake8)
Flake8 is used as a python syntax checker panel.

> :warning: If you do not wish to use any of these plugins, set one or more of these options
> ```
> let g:devpanel_use_nerdtree = 0
> let g:devpanel_use_tagbar = 0
> let g:devpanel_use_lightline = 0
> let g:devpanel_use_flake8 = 0
> ```

## Usage
By default, devpanel is set to auto-open on specific file types. This can be controlled with the following setting:
```
let g:devpanel_auto_open_files = '*.c,*.cpp,*.h,*.py'
```

Other configurations options are available to specify min / max panel size, and to optionally specify your own window size and position
using the corresponding plugin configurations for NERDTree and Tagbar.

## Configuration
For full list of options and configurations, see the [doc/devpanel.txt](doc/devpanel.txt) help page.

## License
devpanel is distributed under the terms of the Vim license, see the included [LICENSE](LICENSE) file.

## Contributors
DevPanel was originally written by [David Hegland](https://github.com/raven42). Please document
[issues](https://github.com/raven42/devpanel-vim/issues) or submit [pull requests](https://github.com/raven42/devpanel-vim/pulls) on Github.
