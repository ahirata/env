execute pathogen#infect()
syntax on
filetype plugin indent on
set expandtab tabstop=2 shiftwidth=2
autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType R set commentstring=#\ %s

set background=dark
colorscheme solarized

"" folding: za
set foldmethod=indent
set foldlevel=99

