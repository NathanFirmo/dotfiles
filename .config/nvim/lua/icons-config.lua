require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  sql = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  },
   svg = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  },
  ico = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  },
   vim = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  },
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  },
  sh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "sh"
  },
  js = {
    icon = "",
    color = "#FFE51E",
    cterm_color = "65",
    name = "sh"
  },
  git = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "sh"
  },
  gitignore = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "sh"
  },
  gitkeep = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "sh"
  },
  sh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "sh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
require("nvim-web-devicons").set_default_icon('', '#6d8086')
