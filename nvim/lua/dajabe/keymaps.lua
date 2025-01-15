-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- This is how kickstart nvim gets rid of highlighting after exiting search
-- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Set shortcut to launch Oil a netrw replacement
vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open oil file browser floating' })
vim.keymap.set('n', '<leader>oo', '<CMD>Oil<CR>', { desc = 'Open oil file browser in new window' })
vim.keymap.set('n', '<leader>ov', '<CMD>vertical Oil<CR>', { desc = 'Open oil file browser in a vertical pane' })
vim.keymap.set('n', '<leader>oh', '<CMD>belowright Oil<CR>', { desc = 'Open oil file browser in a horizontal pane' })

-- multiline editing
-- vim.keymap.set('v', '<leader>s', [[:s/\(.*\)/\1<Left><Left>]])

-- Paste contents of clipboard over current selection
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Copy the the current file path to clipboard
vim.keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('*', vim.fn.expand '%')
end, { desc = 'Copy current file path to system clipboard' })

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.jump(1, { severity = vim.diagnostic.severity.ERROR }), { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>q', ':qa<CR>', { desc = '[Q]uit [A]ll windows if no changes made' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
