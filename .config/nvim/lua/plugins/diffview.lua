return {
  'sindrets/diffview.nvim',
  event = "VeryLazy",
  keys = {
    { 'gfh', ':DiffviewFileHistory %<CR>', noremap = true, silent = true, mode = 'n' },
    { 'dvo', ':DiffviewOpen<CR>', noremap = true, silent = true, mode = 'n' }
  },
}
