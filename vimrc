" vimrc - configuration file for Vim (GVim)
"
" Author: Soerboe <>
"
" Plugins:
"   AutoComplPop
"   autotag
"   c.vim
"   l9
"   pathogen
"   Sessionman
"   syntastic
"   tabular
"   Tagbar

" Let Pathogen handle plugins
call pathogen#infect() 

" Shortcuts:
"   \f              = format a paragraph
"   \h              = toogle highlight search
"   \l              = show invisible characters
"   \bd             = ':bd' without closing window (using plugin bclose.vim)
"   \trail          = delete trailing white spaces in file
"   -               = comment out region
"   _               = uncomment region
"   gb              = go back to previous open buffer
"   gt              = go to tag under cursor
"   glt             = get a list of matching tags
"   gn/gp           = go to next/previous matching tag
"   \ca             = copy all to clipboard
"   \sa             = select all
"   tt              = toggle taglist window
"   Enter           = Insert newline after cursor in normal mode
"   Shift-Enter     = Insert newline before cursor in normal mode
"   :Vrc            = open .vimrc
"
"   (see bottom for filetype specific shortcuts)

" Use Vim settings
set nocompatible

" Misc. config options
set autochdir                       " cd to dir of current file
" set autoindent                      " automatically indent
set autoread                        " automatically re-read when file is changed
set backspace=indent,eol,start      " allow backspacing over everything in insert mode
" set backup                          " keep a backup file
" set cindent                         " use C style indenting
set confirm                         " ask to save file when issuing a command
set nocursorline                    " don't show highlighted cursor line
set expandtab                       " convert tabs to spaces
set formatoptions=tw                " keep indenting block comments
set hidden                          " change buffer without saving
set history=500                     " keep 500 lines of command line history
" set hlsearch                        " highlighted search
set ignorecase                      " case insensitive
set infercase                       " autocomplete case insensitiveness
set incsearch                       " do incremental searching
set laststatus=2                    " use status bar
set lazyredraw                      " lazy screen redraw (faster)
set linespace=0                     " don't insert any extra space betweens rows
set listchars=tab:>\ ,trail:-       " show tabs and trailing spaces
set mouse=a                         " enable mouse
" set nocopyindent                    " follow previous indent level
set noerrorbells                    " no noise, please
set novisualbell                    " blink on error
set nrformats-=octal                " handle number with leading zeros as decimal
set wrap                            " line wrapping
set number                          " show line numbers
set ruler                           " show the cursor position all the time
set shiftround                      " round indent to shiftwidth
set shiftwidth=4                    " used with autoindenting
set showcmd                         " show current command
set showmatch                       " show matching parenthesis
set showmode                        " show current mode (insert etc.)
" set smartindent                     " indenting
" set smarttab                        " indenting
set softtabstop=4                   " insert four spaces for tab
set tabstop=4
set statusline=%<%f\ (%L\ lines)\ %{GitBranch()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P       " custom statusline
set tags=./tags;/                   " load a tags file located somewhere in the path
set textwidth=80
set wildignore=*.o,*.obj,*.bak,*.gch,*.class,*~ " ignore file extensions with tab
set wildmode=longest,list,full      " sets tab completition to something resonable
set wildmenu                        " turns on tab completition menu
syntax on                           " turn on syntax hightlighting

" Varibles
" let mapleader = ","                 " set <Leader> character ('\' is default)
let g:netrw_liststyle=3             " Use tree-mode as default view in file browser

" check which OS vim is running on
let OS='linux'
if has("win32")
    let OS='win'
else
    let osname=substitute(system('uname'), '\n', '', '')
    if osname =~ 'Darwin' || osname =~ 'Mac'
        let OS='mac'
    endif
endif

" GUI options
if has("gui_running")
    " set GUI font
    if (OS=~'mac')
        set guifont=Menlo\ Regular:h11
    elseif (OS=~'win')
        set guifont=Courier\ New
    else
        set guifont=Monospace\ 9
    endif

    set guioptions+=b           " turn on horizontal scrollbar
    colorscheme camomod
endif

" Turn off arrow keys to break bad habit
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Make Y consistent with C and D. See :help Y.
nnoremap Y y$

" Toogle highlight search
nmap <leader>h :set hlsearch!<CR>

" Toogle 'set list' to show invisible characters
nmap <leader>l :set list!<CR>

" Remove trailing whitespaces
nmap <leader>trail :call RunCmdAndPreserveState("%s/\\s\\+$//e")<CR>

" Go back to previous buffer
nmap <silent> gb <C-^>

" Go to tag under cursor
nmap <silent> gt <C-]> 

" Get a list of matching tags
nmap <silent> glt g<C-]>

" Go to next/prev matching tag
nmap <silent> gn :tnext<cr>
nmap <silent> gp :tprev<cr>

" Select the whole file
nmap <leader>sa gg<S-v>G
" Copy the whole file to clipboard
nmap <leader>ca gg<S-v>G"+y

" Reformat a paragraph
nmap <leader>f gwip

nmap <leader>tt :TagbarToggle<cr>

nnoremap <CR> o<Esc>
nnoremap <S-CR> O<Esc>

" ---------------
"
" PLUGINS
"
" ---------------
let g:syntastic_mode_map = { 'mode': 'active',
	\ 'active_filetypes': [],
	\ 'passive_filetypes': [] }
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_error_symbol = 'E'
let g:syntastic_warning_symbol = 'W'

" shortcut to open .vimrc
if (OS=~'win')
    command! -nargs=* Vrc e ~/vimfiles/vimrc
else
    command! -nargs=* Vrc e ~/.vimrc
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Filetype-specific autocommands.
" The different FileTypes can be found in /usr/share/vim/vim70/filetype.vim

filetype plugin indent on           " Enable file type detection and indentation
augroup vimrc_filetype
    autocmd!
    autocmd FileType make    setlocal softtabstop=0 noexpandtab shiftwidth=8 " Makefiles need real tabs

    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

    " Replace common statements in java
    autocmd FileType java    abbr doc /** <CR>@param <CR>@param <CR>@return <CR>/<ESC>4kA
    autocmd FileType java    abbr sop System.out.print("");<esc>2hi
    autocmd FileType java    abbr sopl System.out.println("");<esc>2hi
    autocmd FileType java    abbr sopf System.out.printf("");<esc>2hi
    autocmd FileType java    abbr psvm public static void main(String[] args) {<CR>}<esc>O

    " Turn on folding for selected filetypes
"     autocmd Syntax c,cpp,vim,xml,html,java,css,php,python,tex setlocal foldmethod=indent
"     autocmd Syntax c,cpp,vim,xml,html,java,css,php,python,tex normal zR
    
    " Turn on spell checking for text files
    autocmd Syntax tex,txt setlocal spell

    " Set formating options for programming
    autocmd Syntax c,cpp,xml,html,java,css,php,python setlocal nowrap textwidth=0 formatoptions=

    " Set 2 spaces for C++ files
    autocmd Syntax cpp setlocal shiftwidth=2 softtabstop=2

    " Automatically source
    if (OS=~'win')
        autocmd BufWritePost   ~/vimfiles/vimrc  :source %
    else
        autocmd BufWritePost   ~/.vimrc  :source %
    endif
    autocmd BufWritePost   ~/.bashrc :!source %

    " Commenting blocks of code with "-" and uncomment with "_".
    autocmd FileType *                let b:comment_leader = '# '
    autocmd FileType c,cpp,java,javascript       let b:comment_leader = '// '
"     autocmd FileType sh,python,make   let b:comment_leader = '# '
"     autocmd FileType conf,fstab       let b:comment_leader = '# '
    autocmd FileType tex              let b:comment_leader = '% '
    autocmd FileType vim              let b:comment_leader = '" '
    noremap <silent> - :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> _ :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

    au BufRead,BufNewFile *.css set ft=css syntax=css3
augroup end

function! RunCmdAndPreserveState(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

