local map = function(mode, key, command)
  vim.api.nvim_set_keymap(mode, key, command, { noremap = true, silent = true })
end

require'nvim-tree'.setup {
  view = {
    adaptive_size = true,
  },
  live_filter = {
    prefix = "[FILTER]: ",
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
      webdev_colors = false,
      show = {
        file = false,
        folder = true,
        folder_arrow = false,
        git = true
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "", -- 
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

map('n', '<C-a>', ':NvimTreeToggle<CR>')
