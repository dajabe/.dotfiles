-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set shortcut to launch Oil a netrw replacement
vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open oil file browser floating' })
vim.keymap.set('n', '<leader>oo', '<CMD>Oil<CR>', { desc = 'Open oil file browser in new window' })
vim.keymap.set('n', '<leader>ov', '<CMD>vertical Oil<CR>', { desc = 'Open oil file browser in a vertical pane' })
vim.keymap.set('n', '<leader>oh', '<CMD>belowright Oil<CR>', { desc = 'Open oil file browser in a horizontal pane' })

-- Paste contents of clipboard over current selection
vim.keymap.set('x', '<leader>p', [["_dp]])
vim.keymap.set('x', '<leader>P', [["_dP]])

-- Copy the the current file path to clipboard
vim.keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('*', vim.fn.expand '%')
end, { desc = 'Copy current file path to system clipboard' })

-- Show messages in Telescope picker
vim.keymap.set('n', '<leader>ce', function()
  require('dajabe.messages').show_messages_picker()
end, { desc = 'Show messages in Telescope picker' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>Q', ':qa<CR>', { desc = '[Q]uit [A]ll windows if no changes made' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
