if !has('nvim')
  set nocompatible                    " be iMproved, required
endif
set encoding=utf-8
scriptencoding utf-8

" Install VimPlug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" Install Harlequin theme
if empty(glob('~/.vim/colors/harlequin.vim'))
  !curl -fLo ~/.vim/colors/harlequin.vim --create-dirs https://raw.githubusercontent.com/nielsmadan/harlequin/master/colors/harlequin.vim
endif

" Plugins!!
call plug#begin()

Plug 'tpope/vim-sensible'               " Some sensible settings
Plug 'tpope/vim-sleuth'                 " Autodetect file spacing
Plug 'scrooloose/nerdcommenter'         " Awesome Commenting
Plug 'bronson/vim-trailing-whitespace'  " Display trailing whitespace
Plug 'vim-scripts/auto-pairs-gentle'    " Add brackets automatically
Plug 'vim-scripts/autoswap.vim'         " Handle swap files intelligently
Plug 'vim-scripts/ebnf.vim'             " Handle swap files intelligently
"Plug 'vim-scripts/AutoComplPop'         " Auto Complete Popup
Plug 'sheerun/vim-polyglot'             " Mega language support pack
"Plug 'ervandew/supertab'                " Autocomplete

Plug 'fatih/vim-go'                     " Golang!!

" Autocompletion ultra powerful
if has('nvim')
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2'
else
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2'
endif

" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
Plug 'ncm2/ncm2-cssomni'
Plug 'ncm2/ncm2-pyclang'

call plug#end()

" Autocompletion Settings
autocmd BufEnter * call ncm2#enable_for_buffer()
set shortmess+=c
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
au User Ncm2Plugin call ncm2#register_source({
            \ 'name' : 'css',
            \ 'priority': 9,
            \ 'subscope_enable': 1,
            \ 'scope': ['css','scss'],
            \ 'mark': 'css',
            \ 'word_pattern': '[\w\-]+',
            \ 'complete_pattern': ':\s*',
            \ 'on_complete': ['ncm2#on_complete#delay', 180, 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
            \ })

if !has('nvim')
  set t_Co=256
endif

colorscheme harlequin

set completeopt+=noinsert,menuone,noselect
set number                      " Show line number
set relativenumber              " Show relative line number
set showcmd                     " Show current command
set showmode                    " Show current mode
set wildmode=longest:list,full  " Autocomplete
set wildignore=*.o,*.obj,*~     " Ignore file
set showmatch                   " highlight matching braces
"set autoindent                  " In vim-sensible
"set backspace=indent,eol,start  " In vim-sensible
"set smarttab                    " In vim-sensible
"set incsearch                   " In vim-sensible
"set laststatus=2                " In vim-sensible
"set ruler                       " In vim-sensible
"set wildmenu                    " In vim-sensible
"set expandtab                   " In vim-sleuth
set hlsearch                    " Highlight search
set ignorecase                  " ignore case while searching
set smartcase                   " unless uppercase explicitly mentioned
set smartindent                 " indent smartly
set nowrap                      " Don't wrap text
set scrolloff=5                 " Minimum space on bottom/top of window
set sidescrolloff=7             " Minimum space on side
set sidescroll=1
set list                        " Display hidden chars as defined below
set listchars=tab:▷⋅,trail:⋅,nbsp:+,extends:»,precedes:«
set splitright                  " Open vsp on right

" Function to set cursor postion
function! SetCursorPosition()
  " dont do it when writing a commit log entry
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  else
    call cursor(1,1)
  endif
endfunction
autocmd! BufReadPost * call SetCursorPosition()

" Filetype specific settings
autocmd! filetype svn,*commit*,markdown setlocal spell         " Spell Check
autocmd! filetype svn,*commit*,markdown setlocal textwidth=72  " Looks good
autocmd! filetype make setlocal noexpandtab                    " In Makefiles DO NOT use spaces instead of tabs

set ff=unix

" Easy mistake ; instead of :
nnoremap ; :
vnoremap ; :
" Easily Comment out using NERDCommenter
nmap // <leader>c<space>
vmap // <leader>cs
" Move lines up(-) or down(_)
noremap - ddp
noremap _ ddkP
" Write file as sudo
cnoremap w!! w !sudo tee > /dev/null %

" Display Filename
set statusline=%<%#identifier#
set statusline+=[%f]
set statusline+=%*

" Display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" Display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%y  " FileType
set statusline+=%h  " Help Tag

" Read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

" Modified flag
set statusline+=%#warningmsg#
set statusline+=%m
set statusline+=%*

" Syntastic Error messages
set statusline+=%#warningmsg#
if exists(':SyntasticInfo')
  set statusline+=%{SyntasticStatuslineFlag()}
endif
set statusline+=%*

set statusline+=%=
set statusline+=%-14.(%c%V\ ,\ %l/%L%)\ %P

" Plugin Settings

"inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <sid>"\<Tab>"
"inoremap <silent> <CR> <C-r>=<SID>pumvisible() ? "\<C-y>" : "\<CR>"<CR>
