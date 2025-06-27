-- return {
--   'folke/tokyonight.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'tokyonight-night'
--     vim.cmd.hi 'Comment gui=none'
--     vim.cmd [[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]]
--   end,
-- }
return {
  'vague2k/vague.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('vague').setup {
      vim.cmd.colorscheme 'vague',
    }
  end,
}
