local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

-- Go to the middle of the line ------------------------
map('n', 'gm', ':call cursor(0, len(getline(\'.\'))/2)<CR>')

-- Shortcuts for split navigation ----------------------
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Close panel ----------------------------------------
map('n', 'çç', ':x<CR>')

-- Create splits --------------------------------------
map('n', 'qq', ':vsplit<CR>')

-- Close all ------------------------------------------
map('n', 'tt', ':qa!<CR>')

-- Add a comma in the line ends ----------------------
map('n', '<leader>,', ':%s/$/,<CR>G$xggyG:noh<CR>')

-- Replace ------------------------------------------
map('n', 'rp', ':%s/')

-- Replace across files ------------------------------
map('n', '<Leader>ro', ":vimgrep /search_term/gj **/*")
map('n', '<Leader>rp', ":cfdo %s/foo/bar/gc | update")

-- Clear find ----------------------------------------
map('n', '<Leader>cf', ':noh<cr>')

-- Stay in indent mode -------------------------------
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Format Json --------------------------------------
map('n', '<Leader>fj', ':e temp-file.json<CR>ggvGp:PrettierAsync<CR>')
map('n', '<Leader>cj', 'ggyG:bd!<CR>:! rm temp-file.json<CR><CR>')

-- Panel Resizing ----------------------------------
map('n', '<Leader>+', ':exe "resize " . (winheight(0) * 3/2)<CR>')
map('n', '<Leader>-', ':exe "resize " . (winheight(0) * 2/3)<CR>')
map('n', '<Leader>>', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
map('n', '<Leader><', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')

-- These are to cancel the default behavior of d, D, c, C, s, S and x
-- to put the text they delete in the default register.
-- Note that this means e.g. "ad won't copy the text into
-- register a anymore.  You have to explicitly yank it.
-- and reselect and re-yank any text that is pasted in visual mode
map('n', 'c', '"_c')
map('v', 'c', '"_c')
map('n', 'C', '"_C')
map('v', 'C', '"_C')
map('n', 's', '"_s')
map('v', 's', '"_s')
map('n', 'S', '"_S')
map('v', 'S', '"_S')
map('n', 'x', '"_x')
map('v', 'x', '"_x')
map('x', 'p', 'pgvy')

-- Terminal --------------------------------------
map('t', '<C-h>', '<C-\\><C-n><C-w>h')
map('t', '<C-n>', '<C-\\><C-n>')
map('t', '<C-s>', '<C-\\><C-n>:b#<CR>')
map('t', '<C-x>', '<C-\\><C-n>:bd!<CR>')
map('n', '<C-s>', ':edit term://zsh<CR>')
map('n', '<Leader>j', ':lua nxJest()<CR>')
map('n', '<Leader>jw', ':lua nxJestWatch()<CR>')

function _G.nxJest()
  local filepath = vim.fn.expand('%')
  local api = string.gsub(string.gsub(filepath, '/home/nathan/Trabalho/Workspace/incentive.me/apps/api/', ''), '/.*', '')

  local command = 'edit term://nx test api-' .. api .. ' --all'
  local teste = string.gsub(filepath, '/home/nathan/Trabalho/Workspace/incentive.me/app', '')
  vim.cmd(command)
end

function _G.nxJestWatch()
  local filepath = vim.fn.expand('%')
  local api = string.gsub(string.gsub(filepath, '/home/nathan/Trabalho/Workspace/incentive.me/apps/api/', ''), '/.*', '')

  local command = 'vsplit term://nx test api-' .. api .. ' --all --watch'
  vim.cmd(command)
end
