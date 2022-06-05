local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

map('n', 'fd', ':PrettierAsync<CR>')

vim.g['prettier#quickfix_enabled'] = '1'
vim.g['prettier#config#single_quote'] = 'true'
vim.g['prettier#config#trailing_comma'] = 'es5'
vim.g['prettier#config#semi'] = 'false'
