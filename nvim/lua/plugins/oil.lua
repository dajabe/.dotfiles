return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 10,
      max_width = 100,
      max_height = 100,
    },
    git = {
      mv = function(_, _)
        return true
      end,
    },
    keymaps = {
      ['<Esc>'] = { callback = 'actions.close', mode = 'n' },
      -- ['<C-y>'] = { callback = 'actions.yank_entry', mode = 'n' },
      ['<C-y>'] = {
        callback = function()
          local oil = require 'oil'
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          vim.fn.setreg(vim.v.register, path)
        end,
        mode = 'n',
      },
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
