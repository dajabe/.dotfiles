return {
  'andrewferrier/wrapping.nvim',
  config = function()
    require('wrapping').setup {
      softener = { markdown = 5 },
    }
  end,
}
