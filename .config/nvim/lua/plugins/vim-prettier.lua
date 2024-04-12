return {
  'prettier/vim-prettier',

  config = function()
    vim.api.nvim_set_keymap('n', 'fd', ':PrettierAsync<CR>', { noremap = true, silent = true })

    vim.g['prettier#quickfix_enabled'] = '1'
    vim.g['prettier#config#single_quote'] = 'true'
    vim.g['prettier#config#trailing_comma'] = 'es5'
    vim.g['prettier#config#semi'] = 'false'
  end
}
