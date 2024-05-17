local Job = require 'plenary.job'

local function get_os_command_output(cmd, cwd)
  if type(cmd) ~= 'table' then
    return {}
  end
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  opts = {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      -- key = function()
      --   local branch
      --
      --   -- use tpope's fugitive for faster branch name resolution if available
      --   if vim.fn.exists '*FugitiveHead' == 1 then
      --     branch = vim.fn['FugitiveHead']()
      --     -- return "HEAD" for parity with `git rev-parse` in detached head state
      --     if #branch == 0 then
      --       branch = 'HEAD'
      --     end
      --   else
      --     -- `git branch --show-current` requires Git v2.22.0+ so going with more
      --     -- widely available command
      --     branch = get_os_command_output({
      --       'git',
      --       'rev-parse',
      --       '--abbrev-ref',
      --       'HEAD',
      --     })[1]
      --   end
      --   if branch then
      --     return vim.loop.cwd() .. '-' .. branch
      --   else
      --     return vim.loop.cwd()
      --   end
      -- end,
    },
  },
  keys = {
    {
      '<leader>a',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'harpoon file',
    },
    {
      '<leader>sh',
      function()
        local harpoon = require 'harpoon'
        local conf = require('telescope.config').values
        local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end

          require('telescope.pickers')
            .new({}, {
              prompt_title = 'Harpoon',
              finder = require('telescope.finders').new_table {
                results = file_paths,
              },
              previewer = conf.file_previewer {},
              sorter = conf.generic_sorter {},
            })
            :find()
        end
        -- harpoon.ui:toggle_quick_menu(harpoon:list())
        toggle_telescope(harpoon:list())
      end,
      desc = 'harpoon quick menu',
    },
    {
      '<leader>h',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'harpoon quick menu',
    },
    {
      '<leader>1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'harpoon to file 1',
    },
    {
      '<leader>2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'harpoon to file 2',
    },
    {
      '<leader>3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'harpoon to file 3',
    },
    {
      '<leader>4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'harpoon to file 4',
    },
    {
      '<leader>5',
      function()
        require('harpoon'):list():select(5)
      end,
      desc = 'harpoon to file 5',
    },
  },
}
