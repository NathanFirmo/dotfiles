return {
  'okuuva/auto-save.nvim',
  lazy = true,
  -- cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
  opts = {
    debounce_delay = 135,
    execution_message = {
      enabled = false,
    },
  },
}
