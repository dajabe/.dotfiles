local utils = require 'plugins.lsp.utils'
local helpers = require 'dajabe.helpers'

return {
  denols = utils.create_server_config {
    single_file_support = false,
    root_dir = utils.root_with_markers { 'deno.json', 'deno.jsonc' },
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true,
            ['https://cdn.nest.land'] = true,
            ['https://crux.land'] = true,
          },
        },
      },
    },
  },

  ts_ls = utils.create_server_config {
    root_dir = function(bufnr, on_dir)
      if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) then
        return
      end

      local root_dir = vim.fs.root(bufnr, { 'tsconfig.json', 'package.json', 'jsconfig.json' })
      if root_dir then
        on_dir(root_dir)
      end
    end,
    init_options = {
      preferences = {
        disableSuggestions = false,
      },
    },
    settings = {
      typescript = {
        format = {
          enable = false,
        },
      },
      javascript = {
        format = {
          enable = false,
        },
      },
    },
    on_attach = function(client, _)
      if helpers.is_prettier_installed() then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end,
  },

  eslint = utils.create_server_config {
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('eslint-lsp-fix-' .. bufnr, { clear = true }),
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
  },
}
