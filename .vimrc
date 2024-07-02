" .vimrc (also sourced by nvim)

" Use spaces instead of tabs
set expandtab

" Number of spaces that a <Tab> in the file counts for
set tabstop=4

" Number of spaces to use for each step of (auto)indent
set shiftwidth=4

" Number of spaces that a <Tab> counts for while performing editing operations
set softtabstop=4

" Show line numbers
set number

" Show relative line numbers
set relativenumber

" Highlight the screen line of the cursor with CursorLine
set cursorline

" Enable mouse support in all modes
set mouse=a

" Disable backup files
set nobackup
set nowritebackup

" Enable persistent undo
set undofile

" Ignore case when searching
set ignorecase

" Override ignorecase if search pattern contains uppercase letters
set smartcase

" Incremental search
set incsearch

" Highlight search results
set hlsearch

" Set command-line height to 2 lines
set cmdheight=2

" Enable automatic indentation
set autoindent

" Enable smart indentation
set smartindent

" Split windows to the right
set splitright

" Split windows below
set splitbelow

" Faster completion
set updatetime=300

" Use the system clipboard
set clipboard=unnamedplus

" Set a colorscheme
"colorscheme lunaperche
"colorscheme zaibatsu
"colorscheme slate
"highlight Normal guibg=NONE ctermbg=NONE

" Change the default mapleader
let mapleader=" "
