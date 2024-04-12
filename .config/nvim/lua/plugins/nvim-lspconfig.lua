return {
  'neovim/nvim-lspconfig',
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },
  event = "VeryLazy",
  config = function()
    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<C-i>', ':lua vim.lsp.buf.format({ async = false })<CR>', { noremap = true, silent = true })

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'gtd', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    end

    local lspconfig = require('lspconfig')
    local util = require "lspconfig/util"

    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Language servers
    lspconfig.tsserver.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = util.root_pattern("package.json"),
    }

    lspconfig.cssls.setup {
      capabilities = capabilities,
      root_dir = util.root_pattern("package.json"),
    }

    lspconfig.prismals.setup {
      capabilities = capabilities,
    }

    lspconfig.dockerls.setup {
      capabilities = capabilities,
    }

    lspconfig.html.setup {
      capabilities = capabilities,
    }

    lspconfig.jsonls.setup {
      capabilities = capabilities,
    }

    lspconfig.yamlls.setup {
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =  "/*.k8s.yaml" ,
            ["http://json.schemastore.org/kustomization"] =  "kustomization.yaml" ,
            ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta8.json"] =  "skaffold.yaml",
          },
        },
      }
    }

    lspconfig.clangd.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    lspconfig.bashls.setup {
      capabilities = capabilities,
    }

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = true,
      severity_sort = false,
    })

    local signs = { Error = "", Warn = " ", Hint = " ", Info = " " }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end
}
