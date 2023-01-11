require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      {'branch', icon = ''}, 
    },
    lualine_c = {{'filename', path = 1}},
    lualine_x = {},
    lualine_y = {{
      'diagnostics',
      symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
      colored = true,           -- Displays diagnostics status in color if set to true.
      update_in_insert = true, -- Update diagnostics in insert mode.
      always_visible = true,   -- Show diagnostics even if there are none.
    }},
    lualine_z = {'mode'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {
      {'branch', icon = ''}, 
    },
    lualine_c = {{'filename', path = 1}},
    lualine_x = {},
    lualine_y = {{
      'diagnostics',
      symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
      colored = true,           -- Displays diagnostics status in color if set to true.
      update_in_insert = false, -- Update diagnostics in insert mode.
      always_visible = true,   -- Show diagnostics even if there are none.
    }},
    lualine_z = {'mode'}
    },
    tabline = {},
    extensions = {}
  }
