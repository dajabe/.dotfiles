return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local fzf_lua = require 'fzf-lua'

    -- Custom function to perform fuzzy search on file contents
    local function fuzzy_line_search()
      fzf_lua.fzf_exec('rg --line-number --no-heading --color=always --smart-case .', {
        actions = {
          ['default'] = function(selected)
            local parts = vim.split(selected[1], ':', { plain = true })
            local file = parts[1]
            local line = tonumber(parts[2])
            vim.cmd('edit ' .. file)
            vim.api.nvim_win_set_cursor(0, { line, 0 })
          end,
        },
        fzf_opts = {
          ['--delimiter'] = ':',
          ['--nth'] = '3..',
          ['--tiebreak'] = 'index',
          ['--ansi'] = '',
        },
        previewer = 'builtin',
        prompt = 'Fuzzy Line Search> ',
      })
    end

    -- Set up fzf-lua with custom configuration
    fzf_lua.setup {
      -- Your existing fzf-lua configuration options can go here
    }

    -- Set up the keybinding for fuzzy line search
    vim.api.nvim_set_keymap('n', '<leader>fl', [[<cmd>lua require('fzf-lua').fuzzy_line_search()<CR>]], { noremap = true, silent = true })

    -- Add the custom fuzzy_line_search function to fzf-lua
    fzf_lua.fuzzy_line_search = fuzzy_line_search
  end,
}
