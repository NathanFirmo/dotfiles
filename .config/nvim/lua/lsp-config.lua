-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gtd', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>fd', vim.lsp.buf.formatting, bufopts)
end

local lspconfig = require('lspconfig')
local util = require "lspconfig/util"

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = util.root_pattern("package.json"),
}

lspconfig.denols.setup {
  on_attach = on_attach,
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
}

-- Comentando implementação para golang, que não vou usar por enquanto
-- lspconfig.gopls.setup {
--     cmd = {"gopls", "serve"},
--     capabilities = capabilities,
--     on_attach = on_attach,
--     filetypes = {"go", "gomod"},
--     root_dir = util.root_pattern("go.work", "go.mod", ".git"),
--     settings = {
--       gopls = {
--         analyses = {
--           unusedparams = true,
--         },
--         staticcheck = true,
--       },
--     },
-- }

-- function OrgImports(wait_ms)
--   local params = vim.lsp.util.make_range_params()
--   params.context = {only = {"source.organizeImports"}}
--   local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
--   for _, res in pairs(result or {}) do
--     for _, r in pairs(res.result or {}) do
--       if r.edit then
--         vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
--       else
--         vim.lsp.buf.execute_command(r.command)
--       end
--     end
--   end
-- end

-- To get your imports ordered on save, like goimports does
vim.cmd[[ autocmd BufWritePre *.go lua OrgImports(1000) ]]

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
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
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' }
  },
}

