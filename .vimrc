
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

set background=dark

" Set a colorscheme
"colorscheme lunaperche
"colorscheme zaibatsu
"colorscheme slate
"highlight Normal guibg=NONE ctermbg=NONE

" Change the default mapleader
let mapleader=" "

" Netrw settings

" Sync current dir and browsing dir
let g:netrw_keepdir = 0

" Set split size to 25%
let g:netrw_winsize = 25

" Hide banner (use I to toggle)
let g:netrw_banner = 1      " Set to 0 to not show

" Hide dotfiles by default
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Recursively copy dirs
let g:netrw_localcopydircmd = 'cp -r'

" Highlight marked files
hi! link netrwMarkFile Search

" Keymappings for netrw
"function! NetrwMapping()
"    nmap <buffer> h -^                       " Go up
"    nmap <buffer> l <CR>                     " Open file / cd
"
"    nmap <buffer> . gh                       " Toggle dotfiles
"    nmap <buffer> P <C-w>z                   " Close preview window
"
"    nmap <buffer> L <CR>:Lexplore<CR>        " Open file and close netrw
"    nmap <buffer> <Leader>dd :Lexplore<CR>   " Close netrw
"
"    nmap <buffer> <TAB> mf                   " Toggle mark on file
"    nmap <buffer> <S-TAB> mF                 " Unmark all files in current buf
"    nmap <buffer> <Leader><TAB> mu           " Remove all marks on all files
"
"    nmap <buffer> fe R                       " Rename file
"    nmap <buffer> fc mc                      " Copy marked files      
"    nmap <buffer> fC mtmc                    " Mark, move cursor, and copy
"    nmap <buffer> fx mm                      " Move marked files
"    nmap <buffer> fX mtmm                    " Same a fC but for moving files
"    nmap <buffer> f; mx                      " Run commands on marked files
"    " Show list of all marked files
"    nmap <buffer> fl :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
"
"    nmap <buffer> bb mb                      " Create bookmark
"    nmap <buffer> bd mB                      " Remove most recent bookmark
"    nmap <buffer> bl gb                      " Jump to most recent bookmark
"endfunction
"
"augroup netrw_mapping
"    autocmd!
"    autocmd filetype netrw call NetrwMapping()
"augroup END
