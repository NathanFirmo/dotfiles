local fn = vim.fn
-- Baixar automaticamente o packer caso ele não esteja instalado
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- Core
  use 'wbthomason/packer.nvim'
  -- Apearence
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'catppuccin/nvim', as = "catppuccin" }
  use 'nvim-lualine/lualine.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', commit = '48a3da710369688df80beb2847dabbbd02e2180e', lock = true}
  use 'nvim-tree/nvim-web-devicons'
  -- Produtivity
  use 'max397574/better-escape.nvim'
  use 'akinsho/git-conflict.nvim'
  use 'numToStr/Comment.nvim'
  use 'Pocco81/auto-save.nvim'
  use 'windwp/nvim-autopairs'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 
      {'nvim-lua/plenary.nvim'},
      { "nvim-telescope/telescope-live-grep-args.nvim" }
    }
  }
  use 'kyazdani42/nvim-tree.lua' 
  use 'lewis6991/gitsigns.nvim'
  use 'windwp/nvim-ts-autotag'
  use 'norcalli/nvim-colorizer.lua' -- Highlight hex colors
  use 'potamides/pantran.nvim'
  use 'rest-nvim/rest.nvim'
  -- Formatters
  use 'prettier/vim-prettier'
  -- Parsers and language servers
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'onsails/lspkind.nvim'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'hrsh7th/cmp-buffer' -- Suporte ao Buffer no autocomplete
  if packer_bootstrap then
    require('packer').sync()
  end
end)
