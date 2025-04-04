local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

-- Shortcuts for split navigation ----------------------
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Use H, J, K, L to navigation on Insert Mode ---
map('i', '<C-h>', '<Esc>i')
map('i', '<C-j>', '<Esc>jli')
map('i', '<C-k>', '<Esc>kli')
map('i', '<C-l>', '<Esc>lli')
map('i', '<C-a>', '<Esc>:NvimTreeToggle<CR>i')

-- Remap backspace and delete on Insert Mode -------------
map('i', '<C-s>', '<BS>')
map('i', '<C-d>', '<Del>')

-- Open Lazy UI ---------------------------------------
map('n', '<leader>L', ':Lazy<CR>')

-- Use CTRL + v to paste on Insert Mode -------------
map('i', '<C-v>', '<Esc>pa')

-- Close panel ----------------------------------------
map('n', 'çç', ':x<CR>')

-- Delete buffer ----------------------------------------
map('n', 'PP', ':bd<CR>')

-- Create splits --------------------------------------
map('n', 'qq', ':vsplit<CR>')

-- Back to previous buffer --------------------------------------
map('n', '<Leader>bb', ':b#<CR>')
-- 
-- Close all buffers --------------------------------------
map('n', 'QQ', ':bufdo bd<CR>')

-- Close all ------------------------------------------
map('n', 'tt', ':qa!<CR>')

-- Add a comma in the line ends ----------------------
map('n', '<leader>,', ':%s/$/,<CR>G$xggyG:noh<CR>')

-- Replace ------------------------------------------
map('n', 'rp', ':%s/')
map('v', 'rp', ':s/')

-- Clear find ----------------------------------------
map('n', '<Leader>cf', ':noh<cr>')

-- Stay in indent mode -------------------------------
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Ignore black characters when going to the end oof line --
map('n', '$', 'g_')
map('v', '$', 'g_')

-- Format Json --------------------------------------
map('n', '<Leader>fj', ':e temp-file.json<CR>ggvGp:PrettierAsync<CR>')
map('n', '<Leader>cj', 'ggyG:bd!<CR>:! rm temp-file.json<CR><CR>')

-- Panel Resizing ----------------------------------
map('n', '<Leader>+', ':exe "resize " . (winheight(0) * 3/2)<CR>')
map('n', '<Leader>-', ':exe "resize " . (winheight(0) * 2/3)<CR>')
map('n', '<Leader>>', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
map('n', '<Leader><', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')

-- Exec last comand line command --------------------
map('n', '<C-\\>', '@:')

-- These are to cancel the default behavior of d, D, c, C, s, S and x
-- to put the text they delete in the default register.
-- Note that this means e.g. "ad won't copy the text into
-- register a anymore.  You have to explicitly yank it.
-- and reselect and re-yank any text that is pasted in visual mode
-- map('n', 'c', '"_c')
-- map('v', 'c', '"_c')
-- map('n', 'C', '"_C')
-- map('v', 'C', '"_C')
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
map('t', '<C-a>', '<C-\\><C-n>:NvimTreeToggle<CR>')
map('t', '<C-s>', '<C-\\><C-n>:b#<CR>')
map('t', '<C-x>', '<C-\\><C-n>:bd!<CR>')
map('n', '<C-s>', ':edit term://zsh<CR>')
map('n', '<C-t>', ':lua cypress()<CR>')

function _G.cypress()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local match = buf_path:match("apps/e2e/([^/]+)/")
  
  if not match then
    print("Could not determine project name from buffer path.")
    return
  end
  
  local project_name = (match:find("api") and "" or "ui-") .. match .. "-e2e"

  vim.cmd("vsplit term://nx e2e " .. project_name .. " --headed --no-exit --skip-nx-cache")
end
