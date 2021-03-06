" Load plugins with Vundle
source ~/.vimplugins

source ~/.vimmappings 
source ~/.vimsnippets
source ~/.vimfunctions

let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux"
	set clipboard=unnamedplus
endif	
if !v:shell_error && s:uname == "Darwin"
	set clipboard=unnamed
endif	

" Sends backups out of the working directory
" Removes the current directory from the backup directory list (to keep the ~ backups out of your working directories).
" Save backups to ~/tmp, or to /tmp if that's not possible.
set backupdir-=.
set backupdir^=~/tmp,/tmp
set directory-=.
set directory^=~/tmp,/tmp

" FINDING FILES:
" Setup for searching down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
" Display all matching files when we tab complete
set wildmenu
set wildmode=list:longest,full 
set wildignore+=**/node_modules/** 
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd

" Relative line numbers
set number relativenumber

" Turned of for safety
" Modelines allow you to set variables specific to a file. By default, the first and last five lines are read by vim for variable settings. 
set modelines=0

" Syntax highlighting
syntax enable

" Blink cursor on error instead of beeping (grr)
set visualbell

" Longer timeout
set timeoutlen=1000 " timeoutlen is used for mapping delays
set ttimeoutlen=0 " ttimeoutlen is used for key code delays

" Adding spell check to complete
set complete=.,w,b,u,t,i,kspell " k is for dictionary, kspell for dictionary only when spell is enabled

" Encoding
set encoding=utf-8

" Whitespace
set wrap " Activate soft wrap
set linebreak " To don't break in words
set nolist " Needed for linebreak with list activated
set showbreak=↳\ \ \ 
set textwidth=0
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Visualize tabs and newlines
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 

" Cursor
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
" See terminal-options help regarding the following
let &t_SI.="\e[5 q" " Blinking vertical line in insert mode
let &t_EI.="\e[2 q" " Blinking block in normal mode
let &t_SR.="\e[4 q" " Steady underline in replace mode
runtime! macros/matchit.vim

" Setup netrw file explorer
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ 
set statusline+=%{GitInfo()}
set statusline+=\ 
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
set statusline+=%#PmenuSel#
set statusline+=\ %{toupper(g:currentmode[mode()])} 
set statusline+=\ 

" Last line
set noshowmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Color scheme (terminal)
set t_Co=256
set background=dark
colorscheme industry

let g:vimwiki_list = [{'path': '~/dotfiles//vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

au BufRead,BufNewFile *vim* set filetype=vim

" Rebuild spell files
for d in glob('~/.vim/spell/*.add', 1, 1)
    if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
        exec 'mkspell! ' . fnameescape(d)
    endif
endfor
