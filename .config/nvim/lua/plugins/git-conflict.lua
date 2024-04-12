return {
  'akinsho/git-conflict.nvim', 
  version = "*",
  lazy = true,
  config = function()
    require('git-conflict').setup()
    local map = function(mode, key, command)
      vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
    end

    map('n', 'gkc', ':GitConflictChooseOurs<CR>')
    map('n', 'gki', ':GitConflictChooseTheirs<CR>')
    map('n', 'gkb', ':GitConflictChooseBoth<CR>')
    map('n', 'gkn', ':GitConflictChooseNone<CR>')
    map('n', ']x', ':GitConflictNextConflict<CR>')
    map('n', '[x', ':GitConflictPrevConflict<CR>')
    map('n', 'gx', ':GitConflictListQf<CR>')
  end
}
