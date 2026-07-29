local parsers = {
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
}

local filetypes = {
  'bash',
  'c',
  'dockerfile',
  'eruby',
  'html',
  'javascript',
  'javascriptreact',
  'lua',
  'markdown',
  'python',
  'ruby',
  'typescript',
  'typescriptreact',
  'vim',
  'vimdoc',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- Treesitter should not be lazy loaded
    cond = vim.fn.executable 'tree-sitter' == 1,
    build = ':TSUpdate',
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

      local treesitter = require 'nvim-treesitter'
      treesitter.setup { install_dir = vim.fn.stdpath('data') .. '/site' }
      treesitter.install(parsers):wait(300000)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dajabe-treesitter', { clear = true }),
        pattern = filetypes,
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)

          if vim.bo[event.buf].filetype ~= 'yaml' then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
