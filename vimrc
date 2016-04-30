" get from https://github.com/tjennings/dotfiles/blob/master/.vimrc
" see ryanb/vim
" see janus
" see https://github.com/jgreet/dotfiles/blob/master/.vimrc
" see https://github.com/coderholic/config/blob/master/.vimrc

call pathogen#infect()
syntax on             " Enable syntax highlighting
"filetype plugin indent on
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set nu
let g:Powerline_symbols = 'fancy'

"imap ;; <Esc>
"inoremap jj <ESC>
"noremap ; :
"noremap : ;
" http://vim.wikia.com/wiki/Avoid_the_escape_key
"nnoremap <Tab> <Esc>
"vnoremap <Tab> <Esc>gV
"onoremap <Tab> <Esc>
"inoremap <Tab> <Esc>`^
"inoremap <Leader><Tab> <Tab>
"
"set nocompatible      " We're running Vim, not Vi!
