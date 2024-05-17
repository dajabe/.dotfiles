return {
  'f-person/git-blame.nvim',
  config = function()
    require('gitblame').setup {
      display_virtual_text = 0,
      delay = 0,
      date_format = '%Y.%m.%d',
      message_when_not_committed = '  !!!',
    }
  end,
}
