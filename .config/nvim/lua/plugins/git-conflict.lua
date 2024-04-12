return {
  'akinsho/git-conflict.nvim', 
  version = "*",
  lazy = true,
  opts = {},
  keys = { 
    { "gkc", ":GitConflictChooseOurs<CR>", mode = "n" },
    { "gki", ":GitConflictChooseTheirs<CR>", mode = "n" },
    { "gkb", ":GitConflictChooseBoth<CR>", mode = "n" },
    { "gkn", ":GitConflictChooseNone<CR>", mode = "n" }, 
    { "]x", ":GitConflictNextConflict<CR>", mode = "n" }, 
    { "[x", ":GitConflictPrevConflict<CR>", mode = "n" }, 
    { "gx", ":GitConflictListQf<CR>", mode = "n" }, 
  },
}
