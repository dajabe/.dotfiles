return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- Treesitter should not be lazy loaded
    build = ':TSUpdate',
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
    },
    config = function()
      local query = require 'vim.treesitter.query'

      local function first_capture_node(match, capture_id)
        local capture = match[capture_id]
        if type(capture) == 'table' then
          return capture[1]
        end

        return capture
      end

      local markdown_info_string_aliases = {
        ex = 'elixir',
        pl = 'perl',
        sh = 'bash',
        ts = 'typescript',
      }

      -- nvim-treesitter's current directive still assumes the pre-0.12 capture
      -- shape. Neovim 0.12 passes captures as node lists.
      query.add_directive('set-lang-from-info-string!', function(match, _, source, directive, metadata)
        local node = first_capture_node(match, directive[2])
        if not node then
          return
        end

        local injection_alias = vim.treesitter.get_node_text(node, source):lower()
        metadata['injection.language'] = vim.filetype.match { filename = 'a.' .. injection_alias }
          or markdown_info_string_aliases[injection_alias]
          or injection_alias
      end, { force = true })

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'html',
          'lua',
          'markdown',
          'markdown_inline',
          'vim',
          'vimdoc',
          'ruby',
          'embedded_template',
          'dockerfile',
          'javascript',
          'typescript',
          'python',
        },
        auto_install = true,
        highlight = {
          enable = true,
          -- Disable vim syntax highlighting to prevent conflicts
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
          disable = { 'yaml' }, -- YAML has better indentation with Vim's built-in engine
        },
        endwise = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            scope_incremental = '<S-CR>',
            node_decremental = '<BS>',
          },
        },
      }
    end,
  },
}
