return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-live-grep-args.nvim' },
  keys = {
    { 'ff', '<cmd>Telescope find_files find_command=rg,--hidden,--files <CR>', noremap = true, silent = true, mode = "n" },
    { 'fg', ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', noremap = true, silent = true, mode = "n" },
    { 'fb', '<cmd>Telescope buffers<CR>', noremap = true, silent = true, mode = "n" },
  },
  config = function()
    vim.g.theme_switcher_loaded = true
    require("telescope").setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        prompt_prefix = "    ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = { ".git", "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
          n = { ["q"] = require("telescope.actions").close },
          i = {
            ["<c-d>"] = "delete_buffer",
          }
        },
      },
      extensions_list = { "themes", "terms", "live_grep_args" },
    })
    pcall(function()
      for _, ext in ipairs(options.extensions_list) do
        telescope.load_extension(ext)
      end
    end)
  end,
}
