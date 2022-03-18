call plug#begin()
" Themes """""
Plug 'sainnhe/sonokai'
" AirLine """""
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
" NerdTree """""
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Patterns and produtivity
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'dense-analysis/ale'
Plug 'ianks/vim-tsx'
Plug 'puremourning/vimspector'
Plug 'thaerkh/vim-workspace'
Plug 'mg979/vim-visual-multi'
Plug 'preservim/nerdcommenter'
Plug 'mattn/emmet-vim'
" Coc """""""""""
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
Plug 'sheerun/vim-polyglot'
if (has("nvim"))
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
endif
call plug#end()

" Global Sets """"""""
filetype plugin on
set clipboard+=unnamedplus
syntax on            " Enable syntax highlight
set nu               " Enable line numbers
set tabstop=2        " Show existing tab with 4 spaces width
set softtabstop=2    " Show existing tab with 4 spaces width
set shiftwidth=2    " When indenting with '>', use 4 spaces width
set expandtab        " On pressing tab, insert 4 spaces
set smarttab         " insert tabs on the start of a line according to shiftwidth
set smartindent      " Automatically inserts one extra level of indentation in some cases
set hidden           " Hides the current buffer when a new file is openned
set incsearch        " Incremental search
set ignorecase       " Ingore case in search
set smartcase        " Consider case if there is a upper case character
set scrolloff=8      " Minimum number of lines to keep above and below the cursor
set colorcolumn=160  " Draws a line at the given line to keep aware of the line size
set signcolumn=yes   " Add a column on the left. Useful for linting
set cmdheight=2      " Give more space for displaying messages
set updatetime=100   " Time in miliseconds to consider the changes
set encoding=utf-8   " The encoding should be utf-8 to activate the font icons
set nobackup         " No backup files
set nowritebackup    " No backup files
set splitright       " Create the vertical splits to the right
set splitbelow       " Create the horizontal splits below
set autoread         " Update vim after file update from outside
set mouse=a          " Enable mouse support
filetype on          " Detect and set the filetype option and trigger the FileType Event
filetype plugin on   " Load the plugin file for the file type, if any
filetype indent on   " Load the indent file for the file type, if any

" Auto cmd """"""""
" My Anotations """"
" Use CTRL N inside a word to select it and have multiple cursors in your
" file

" Remaps """"""""""
" Map Leader """""
let mapleader="\<space>"

" Source config """""""""
nmap <leader>! :source ~/dotfiles/.config/nvim/init.vim<cr>
nmap <leader>@ :vsplit ~/dotfiles/.config/nvim/init.vim<cr>

" Copy from Clipboard """"
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
nmap tt :qa<CR>

" Add a comma in the line ends
nmap <leader>, :%s/$/,<CR>G$xggVGyy:noh<CR>

" Acess command mode
nmap <leader>\ :!<space>

" Replace
nmap <Leader>rp :%s/

" Clear find
nmap <Leader>cf :noh<cr>

"
"
" Emmet """"""""""""""""""
let g:user_emmet_leader_key=','
let g:user_emmet_install_global = 0
autocmd FileType html,css,vue,ts,ts,js,jsx EmmetInstall



" Panel Resizing """"""""""
nnoremap <silent><Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent><Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent><Leader>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent><Leader>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>



" Prettier """"""""""""""
" Formatting selected code.
xmap <leader>fd <Plug>(Prettier)
nmap <leader>fd <Plug>(Prettier)
" when running at every change you may want to disable quickfix
let g:prettier#quickfix_enabled = 0
autocmd TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yaml,*.html PrettierAsync



" Vimspector
 let g:vimspector_enable_mappings = 'HUMAN'
" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval
nmap <Leader>sd :call vimspector#Launch()<CR>
nmap <Leader>cb :call vimspector#ClearBreakpoints()<CR>
nmap <Leader>ev :VimspectorEval<space>
nmap <Leader>kd :call vimspector#Stop()<CR>



" " Themes """""""""""""""
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let g:sonokai_style = 'espresso'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0
colorscheme sonokai



" AirLine """""""""""""""""
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme = 'sonokai'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'



" Tmux AirLine """""""""""
let g:tmuxline_preset = {
      \'c'    : '#H',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a',
      \'y'    : '%R'}
"
let g:tmuxline_theme = {
    \   'c'    : [ 244, 236 ],
    \   'x'    : [ 244, 236 ],
    \   'y'    : [ 253, 239 ],
    \   'win'  : [ 103, 236 ],
    \   'cwin' : [ 236, 103 ],
    \   'bg'   : [ 244, 236 ],
    \ }



" NerdTree """"""""""""""""""
nmap <C-a> :NERDTreeToggle<CR>
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif



" vim-workspace """""""""""""
let g:workspace_autosave_always = 1



" ALE """"""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\   'yaml': ['prettier'],
\   'json': ['prettier'],
\}

let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\}
let g:ale_fix_on_save = 0



" Telescope """"""""""""""
if (has("nvim"))
    nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
endif



" Coc Of Completion """""""
let g:coc_global_extensions = ['coc-pairs', 'coc-json', 'coc-tsserver', 'coc-git']
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>



" Coc-git """""""""""""
" navigate chunks of current buffer
nmap <Leader>pc <Plug>(coc-git-prevchunk)
nmap <Leader>nc <Plug>(coc-git-nextchunk)
" Adicionar alterações ao staging
nmap <leader>ss :CocCommand git.chunkStage<cr>
" Desfazer alterações
nmap <leader>uu :CocCommand git.chunkUndo<cr>

" List all presets
nnoremap <space>el :CocList explPresets


" Nerd Commenter
" [count]<leader>c<space> |NERDCommenterToggle|
" Create default mappings
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
