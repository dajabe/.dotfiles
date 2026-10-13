local oil = require("oil")

oil.setup({
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      border = "rounded",
      max_width = 0.8,
      max_height = 0.8,
    },
    git = {
      mv = function(_, _)
        return true
      end,
    },
  })

vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open oil file browser floating' })
vim.keymap.set('n', '<leader>oo', '<CMD>Oil<CR>', { desc = 'Open oil file browser in new window' })
vim.keymap.set('n', '<leader>ov', '<CMD>vertical Oil<CR>', { desc = 'Open oil file browser in a vertical pane' })
vim.keymap.set('n', '<leader>oh', '<CMD>belowright Oil<CR>', { desc = 'Open oil file browser in a horizontal pane' })
vim.keymap.set("n", "<Esc>", oil.close)

vim.keymap.set("n", "<C-y>", function()
  local entry = oil.get_cursor_entry()
  local dir = oil.get_current_dir()
  local path = dir .. entry.name
  vim.fn.setreg(vim.v.register, path)
end)
