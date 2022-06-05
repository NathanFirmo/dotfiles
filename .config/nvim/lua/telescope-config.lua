local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

-- Keymappings
map('n', 'ff', '<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files <cr>')
map('n', 'fg', '<cmd>Telescope live_grep<cr>')
map('n', 'fb', '<cmd>Telescope buffers<cr>')
