local set = vim.opt

vim.g.mapleader = ' '
set.clipboard:append('unnamedplus')
set.nu = true
set.wrap = true
set.tabstop = 2       
set.softtabstop = 2   
set.shiftwidth = 2   
set.laststatus = 3
set.expandtab = true       
set.smarttab  = true       
set.smartindent = true     
set.hidden = true          
set.incsearch = true       
set.ignorecase = true
set.smartcase = true
set.scrolloff = 12
set.signcolumn= 'yes'
set.cmdheight = 1
set.updatetime = 100
set.encoding = 'UTF-8'
set.backup = false
set.writebackup = false
set.splitright = true
set.splitbelow = true
set.autoread = true
set.guicursor = 'i:block'
set.swapfile = false
set.termguicolors = true

vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber') -- Disable numbers on terminal buffer
vim.cmd([[au BufNewFile,BufRead *.yaml.gotmpl setf yaml]])
