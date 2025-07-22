local M = {}

function M.show_messages_picker()
  local messages = vim.fn.execute 'messages'
  local lines = vim.split(messages, '\n')

  -- Filter out empty lines
  local filtered_lines = {}
  for _, line in ipairs(lines) do
    if line:match '%S' then
      table.insert(filtered_lines, line)
    end
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Messages',
      finder = require('telescope.finders').new_table {
        results = filtered_lines,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      },
      sorter = require('telescope.config').values.generic_sorter {},
      attach_mappings = function(_, map)
        map('i', '<CR>', function(prompt_bufnr)
          local selection = require('telescope.actions.state').get_selected_entry()
          require('telescope.actions').close(prompt_bufnr)
          vim.fn.setreg('*', selection.value)
          -- vim.notify('Copied to clipboard: ' .. selection.value:sub(1, 50) .. '...')
        end)
        return true
      end,
    })
    :find()
end

function M.show_messages_scratch()
  local messages = vim.fn.execute 'messages'
  local lines = vim.split(messages, '\n')

  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Set buffer options for scratch buffer
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'vim')

  -- Set the lines in the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Open in a floating window
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Messages ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Set window-local keymaps for easy closing
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
end

return M
