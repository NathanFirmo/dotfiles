return {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  config = true,
  dependencies = { 
    'onsails/lspkind.nvim', 
    'hrsh7th/cmp-nvim-lsp', 
    'hrsh7th/cmp-buffer', 
    'saadparwaiz1/cmp_luasnip' 
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          symbol_map = {
            Text = "  (text)",
            Method = "  (method)",
            Function = "  (function)",
            Constructor = "  (constructor)",
            Field = "  (field)",
            Variable = " (var)",
            Class = "  (class)",
            Interface = " (interface)",
            Module = " (module)",
            Property = " (property)",
            Unit = " (unit)",
            Value = "  (value)",
            Enum = " (enum)",
            Keyword = " (keyword)",
            Snippet = " (snippet)",
            Color = " (color)",
            File = " (file)",
            Reference = " (reference)",
            Folder = " (folder)",
            EnumMember = "  (enum)",
            Constant = " (const)",
            Struct = " (struct)",
            Event = " (event)",
            Operator = " (operator)",
            TypeParameter = " (type)",
          },
          before = function (entry, vim_item)
            return vim_item
          end
        })
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = {
        { name = "nvim_lsp", group_index = 1 },
        { name = 'buffer', group_index = 1 },
        { name = 'luasnip', group_index = 1 },
      },
    }
  end
}
