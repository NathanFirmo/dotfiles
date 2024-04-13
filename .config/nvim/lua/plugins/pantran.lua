return {
  'potamides/pantran.nvim',
  keys = {
    { 'tr', ':Pantran<CR>', noremap = true, silent = true, mode = "n" },
  },
  opts = {
    default_engine = "google"
  }
}
