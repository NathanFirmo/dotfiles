local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

-- Source config """""""""
-- nmap <leader>! :source ~/dotfiles/.config/nvim/init.vim<cr>
map('n', '<leader>!', ':source ~/dotfiles/.config/nvim/init.vim<cr>')
-- nmap <leader>@ :vsplit ~/dotfiles/.config/nvim/init.vim<cr>
map('n', '<leader>@', ':vsplit ~/dotfiles/.config/nvim/init.vim<cr>')

-- Shortcuts for split navigation
-- map <C-h> <C-w>h
map('n', '<C-h>', '<C-w>h')
-- map <C-j> <C-w>j
map('n', '<C-j>', '<C-w>j')
-- map <C-k> <C-w>k
map('n', '<C-k>', '<C-w>k')
-- map <C-l> <C-w>l
map('n', '<C-l>', '<C-w>l')

-- Navigate between buffers

-- nmap mm :bn<CR>
map('n', 'mm', ':bn<CR>')
-- nmap nn :bp<CR>
map('n', 'nn', ':bp<CR>')

-- Delete a buffer
-- nmap çç :bd<CR>
map('n', 'çç', ':bd<CR>')

-- Create splits
-- nmap qq :vsplit<CR>
map('n', 'qq', ':vsplit<CR>')

-- Close splits and others
-- nmap tt :qa<CR>
map('n', 'tt', ':qa<CR>')

-- Add a comma in the line ends
-- nmap <leader>, :%s/$/,<CR>G$xggVGyy:noh<CR>
map('n', '<leader>,', ':%s/$/,<CR>G$xggVGyy:noh<CR>')

-- Replace
-- nmap rp :%s/
map('n', 'rp', ':%s/')

-- Replace across files
-- nmap <Leader>rp :windo %s/
map('n', '<Leader>rp', ':windo %s/')

-- Clear find
-- nmap <Leader>cf :noh<cr>
map('n', '<Leader>cf', ':noh<cr>')

-- Panel Resizing """"""""""
-- nnoremap <silent><Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
map('n', '<Leader>+', ':exe "resize " . (winheight(0) * 3/2)<CR>')
-- nnoremap <silent><Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
map('n', '<Leader>-', ':exe "resize " . (winheight(0) * 2/3)<CR>')
-- nnoremap <silent><Leader>> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
map('n', '<Leader>>', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
-- nnoremap <silent><Leader>< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
map('n', '<Leader><', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')
