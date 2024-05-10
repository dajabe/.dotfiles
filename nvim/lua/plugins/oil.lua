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
      mv = function(d, s)
        return true
      end,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
