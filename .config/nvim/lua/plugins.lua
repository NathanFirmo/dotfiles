local fn = vim.fn
-- Baixar automaticamente o packer caso ele não esteja instalado
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

--[[
  PLUGINS QUE FALTAM
    * Auto pairs OK
    * Prettier OK
    * Language server / Code completion
--]]

return require('packer').startup(function(use)
  -- Core
  use 'wbthomason/packer.nvim' -- Isso é essencial
  -- Aparência
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'catppuccin/nvim', as = "catppuccin" }
  -- Produtividade
  use {'akinsho/toggleterm.nvim', tag = 'v1.*'}
  use 'numToStr/Comment.nvim'
  use 'Pocco81/AutoSave.nvim'
  use 'windwp/nvim-autopairs'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'kyazdani42/nvim-tree.lua' 
  use 'lewis6991/gitsigns.nvim'
  -- Formatadores
  use 'prettier/vim-prettier'
  -- Parsers e language servers
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'hrsh7th/cmp-buffer' -- Suporte ao Buffer no autocomplete
  use 'windwp/nvim-ts-autotag'
  -- use 'glepnir/lspsaga.nvim'
  if packer_bootstrap then
    require('packer').sync()
  end
end)
