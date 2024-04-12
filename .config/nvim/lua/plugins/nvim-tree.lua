return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { "<C-a>", ":NvimTreeToggle<CR>", noremap = true, silent = true, mode = "n" },
  },
  opts = {
    view = {
      adaptive_size = true,
    },
    live_filter = {
      prefix = "    ",
      always_show_folders = false,
    },
    renderer = {
      indent_markers = {
        enable = true,
        icons = {
          corner = "└ ",
          edge = "│ ",
          item = "│ ",
          none = "  ",
        },
      },
      icons = {
        webdev_colors = true,
        show = {
          file = true,
          folder = true,
          folder_arrow = false,
          git = true
        },
        glyphs = {
          git = {
            unstaged = "",
            staged = "",
            unmerged = "",
            renamed = "➜",
            untracked = "",
            deleted = "",
            ignored = "◌",
          },
        },
      },
      special_files = {},
    },
    update_focused_file = {
      enable = true,
      update_cwd = false,
      ignore_list = {},
    },
    diagnostics = {
      enable = true,
      show_on_dirs = false,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
  }
}
