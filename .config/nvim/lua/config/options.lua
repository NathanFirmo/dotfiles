local set = vim.opt

vim.g.mapleader = ' ' -- Use space as leader key
set.clipboard:append('unnamedplus') -- Copiar e colar texto da área de tranferência
set.nu = true -- Use absolute numbers
set.wrap = true -- Enable line wrap
set.tabstop = 2        -- Show existing tab with 2 spaces width
set.softtabstop = 2    -- Show existing tab with 2 spaces width
set.shiftwidth = 2    -- When indenting with '>', use 2 spaces width
set.laststatus = 3 -- Use global status bar
set.expandtab = true        -- On pressing tab, insert 4 spaces
set.smarttab  = true        -- insert tabs on the start of a line according to shiftwidth
set.smartindent = true      -- Automatically inserts one extra level of indentation in some cases
set.hidden = true           -- Hides the current buffer when a new file is openned
set.incsearch = true        -- Incremental search
set.ignorecase = true       -- Ingore case in search
set.smartcase = true        -- Consider case if there is a upper case character
set.scrolloff = 12      -- Minimum number of lines to keep above and below the cursor
set.signcolumn= 'yes'   -- Add a column on the left. Useful for linting
set.cmdheight = 1      -- Give more space for displaying messages
set.updatetime = 100   -- Time in miliseconds to consider the changes
set.encoding = 'UTF-8'   -- The encoding should be utf-8 to activate the font icons
set.backup = false         -- No backup files
set.writebackup = false    -- No backup files
set.splitright = true       -- Create the vertical splits to the right
set.splitbelow = true       -- Create the horizontal splits below
set.autoread = true         -- Update vim after file update from outside
set.guicursor = 'i:block' -- Use block format in cursor
set.swapfile = false -- Disable swap file

vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber') -- Disable numbers on terminal buffer
