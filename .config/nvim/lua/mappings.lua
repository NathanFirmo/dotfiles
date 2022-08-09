local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

-- Shortcuts for split navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Close panel
map('n', 'çç', ':x<CR>')

-- Create splits
map('n', 'qq', ':split<CR>')

-- Close all
map('n', 'tt', ':qa!<CR>')

-- Add a comma in the line ends
map('n', '<leader>,', ':%s/$/,<CR>G$xggyG:noh<CR>')

-- Replace
map('n', 'rp', ':%s/')

-- Replace across files
map('n', '<Leader>ro', ":vimgrep /search_term/gj **/*")
map('n', '<Leader>rp', ":cfdo %s/foo/bar/gc | update")

-- Clear find
map('n', '<Leader>cf', ':noh<cr>')

-- Stay in indent mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Format Json
map('n', '<Leader>fj', ':e temp-file.json<CR>p:PrettierAsync<CR>')
map('n', '<Leader>cj', 'ggyG:bd!<CR>:! rm temp-file.json<CR><CR>')

-- Panel Resizing """"""""""
map('n', '<Leader>+', ':exe "resize " . (winheight(0) * 3/2)<CR>')
map('n', '<Leader>-', ':exe "resize " . (winheight(0) * 2/3)<CR>')
map('n', '<Leader>>', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
map('n', '<Leader><', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')
