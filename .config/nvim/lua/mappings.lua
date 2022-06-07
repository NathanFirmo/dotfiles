local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

-- Shortcuts for split navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Delete a buffer
map('n', 'çç', ':bd<CR>')

-- Create splits
map('n', 'qq', ':vsplit<CR>')

-- Close splits and others
map('n', 'tt', ':qa!<CR>')

-- Add a comma in the line ends
map('n', '<leader>,', ':%s/$/,<CR>G$xggVGyy:noh<CR>')

-- Replace
map('n', 'rp', ':%s/')

-- Replace across files
map('n', '<Leader>rp', ':windo %s/')

-- Clear find
map('n', '<Leader>cf', ':noh<cr>')

-- Panel Resizing """"""""""
map('n', '<Leader>+', ':exe "resize " . (winheight(0) * 3/2)<CR>')
map('n', '<Leader>-', ':exe "resize " . (winheight(0) * 2/3)<CR>')
map('n', '<Leader>>', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
map('n', '<Leader><', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')
