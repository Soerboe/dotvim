" vimrc - configuration file for Vim (GVim)
"
" Author: Soerboe <>
"
" Plugins:
"   - AutoComplPop
"   - autotag
"   - c.vim
"   - git-vim
"   - Sessionman
"   - tabular
"
" Shortcuts:
" <leader> is ','
"   - F12      = clear search highlighting
"   - ',l'     = show invisible characters
"   - '-'      = comment out region
"   - '_'      = uncomment region
"   - ',trail' = delete trailing white spaces in file
"   - 'gb'     = go back to previous open buffer
"   - 'gt'     = go to tag under cursor
"   - 'glt'    = get a list of matching tags
"   - 'gn/gp'  = go to next/previous matching tag
"   - ':Vrc'   = open .vimrc
"
"   (see bottom for filetype specific shortcuts)

" Use Vim settings
set nocompatible

" Load the autotag plugin
so ~/.vim/plugin/autotag.vim

" Misc. config options
set autochdir                       " cd to dir of current file
set autoindent                      " automatically indent
set autoread                        " automatically re-read when file is changed
set backspace=indent,eol,start      " allow backspacing over everything in insert mode
set backup                          " keep a backup file
set cindent                         " use C style indenting
set confirm                         " ask to save file when issuing a command
set nocursorline                    " don't show highlighted cursor line
set expandtab                       " convert tabs to spaces
set formatoptions+=ro               " keep indenting block comments
set hidden                          " change buffer without saving
set history=500                     " keep 100 lines of command line history
set hlsearch                        " highlighted search
set ignorecase                      " case insensitive
set incsearch                       " do incremental searching
set laststatus=2                    " use status bar
set lazyredraw                      " lazy screen redraw (faster)
set linespace=0                     " don't insert any extra space betweens rows
set listchars=tab:>\ ,trail:-       " show tabs and trailing spaces
set mouse=a                         " enable mouse
set nocopyindent                    " follow previous indent level
set noerrorbells                    " no noise, please
set novisualbell                    " blink on error
set nowrap                          " no line wrapping
set number                          " show line numbers
set ruler                           " show the cursor position all the time
set shiftround                      " be clever with tabs
set shiftwidth=4                    " used with autoindenting
set showcmd                         " show current command
set showmatch                       " show matching parenthesis
set showmode                        " show current mode (insert etc.)
set smartindent                     " indenting
set smarttab                        " indenting
set softtabstop=4                   " insert four spaces for tab
set statusline=%<%f\ (%L\ lines)\ %{GitBranch()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P       " custom statusline
set tags=./tags;/                   " load a tags file located somewhere in the path
set wildignore=*.o,*.obj,*.bak,*.jpg,*.gif,*.png,*.gch,*.class,*~ " ignore file extensions with tab
set wildmode=longest,list,full      " sets tab completition to something resonable
set wildmenu                        " turns on tab completition menu
syntax on                           " turn on syntax hightlighting

" Varibles
let mapleader = ","                 " set <Leader> character ('\' is default)
let g:netrw_liststyle=3             " Use tree-mode as default view in file browser

" GUI options
if has("gui_running")
        set guifont=Monospace\ 10   " set GUI font
        colorscheme camomod
endif

" Toogle 'set list' to show invisible characters
nmap <leader>l :set list!<CR>

" Clear highlighted search with F12
nnoremap <F12> :noh<return><esc>

" Remove trailing whitespaces
nmap <leader>trail :call RunCmdAndPreserveState("%s/\\s\\+$//e")<CR>

" Go back to previous open buffer
nmap <silent> gb <C-^>

" Go to tag under cursor
map <silent> gt <C-]> 

" Get a list of matching tags
map <silent> glt g<C-]>

" Go to next/prev matching tag
map <silent> gn :tnext<cr>
map <silent> gp :tprev<cr>

command! -nargs=* Vrc e ~/.vimrc     " shortcut to open .vimrc

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" Filetype-specific autocommands.
" Most importantly: Comment in and out lines using - and _ respectively.
" The different FileTypes can be found in /usr/share/vim/vim70/filetype.vim

filetype plugin indent on           " Enable file type detection.
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
    autocmd FileType java    abbr psvm public static void main(String[] args) {
    autocmd FileType java    abbr sop System.out.print(
    autocmd FileType java    abbr sopl System.out.println(

    " Automatically source
    autocmd BufWritePost   ~/.vimrc  :source %
    autocmd BufWritePost   ~/.bashrc :!source %

    " Commenting blocks of code with "-" and uncomment with "_".
    autocmd FileType *                let b:comment_leader = '# '
    autocmd FileType c,cpp,java       let b:comment_leader = '// '
"     autocmd FileType sh,python,make   let b:comment_leader = '# '
"     autocmd FileType conf,fstab       let b:comment_leader = '# '
    autocmd FileType tex              let b:comment_leader = '% '
    autocmd FileType vim              let b:comment_leader = '" '
    noremap <silent> - :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    noremap <silent> _ :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

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

