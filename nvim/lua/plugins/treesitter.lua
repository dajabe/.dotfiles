return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- Treesitter should not be lazy loaded
    build = ':TSUpdate',
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'html',
          'lua',
          'markdown',
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
