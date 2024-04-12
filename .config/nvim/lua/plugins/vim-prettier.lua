return {
  'prettier/vim-prettier',
  keys = {
    { 'fd', ':PrettierAsync<CR>', noremap = true, silent = true, mode = 'n' }
  },
  config = function()
    vim.g['prettier#quickfix_enabled'] = '1'
    vim.g['prettier#config#single_quote'] = 'true'
    vim.g['prettier#config#trailing_comma'] = 'es5'
    vim.g['prettier#config#semi'] = 'false'
  end
}
