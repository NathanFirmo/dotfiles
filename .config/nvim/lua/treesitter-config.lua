require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or 'all'
  ensure_installed = { 
    'javascript',
    'typescript',
    'tsx',
    'json',
    'yaml',
    'html',
    'css',
    'prisma',
    'c',
    'cpp',
    'lua',
    'go',
    'http',
    'angular'
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- use_languagetree = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { 'c', "rust" },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
    disable = {}
  },
}

vim.cmd('autocmd BufNewFile,BufRead *.yaml.gotmpl set filetype=yaml')
