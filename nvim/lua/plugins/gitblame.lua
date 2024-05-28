return {
  'f-person/git-blame.nvim',
  config = function()
    require('gitblame').setup {
      -- display_virtual_text = 0,
      date_format = '%Y.%m.%d',
      virtual_text_column = 100,
    }
    vim.g.gitblame_set_extmark_options = {
      priority = 1,
    }
  end,
}
