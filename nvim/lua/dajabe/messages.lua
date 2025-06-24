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

return M

