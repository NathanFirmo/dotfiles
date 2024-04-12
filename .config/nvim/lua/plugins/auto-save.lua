return {
  'okuuva/auto-save.nvim',
  event = { 'InsertEnter' },
  opts = {
    debounce_delay = 135,
    execution_message = {
      enabled = false,
    },
  },
}
