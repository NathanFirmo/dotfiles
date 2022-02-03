" Global Sets """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
set clipboard+=unnamedplus

" Copy from Clipboard """"""""""""""""""""""""""""
map <C-c> "+y
map <C-x> "+d

" Shortcuts for split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Adding an empty line below, above and below with insert
nmap op o<Esc>k
nmap oi O<Esc>j
nmap oo A<CR>

nmap mm :bn<CR>
nmap nn :bp<CR>

" Delete a buffer
nmap çç :bd<CR>

" Create splits
nmap ff :vsplit<CR>

" Close splits and others
nmap tt :q<CR>

" Add a comma in the line ends
nmap <leader>, :%s/$/,<CR>G$xVGyy