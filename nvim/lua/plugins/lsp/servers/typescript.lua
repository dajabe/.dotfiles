local utils = require 'plugins.lsp.utils'
local util = require 'lspconfig/util'
local helpers = require 'dajabe.helpers'

return {
  denols = utils.create_server_config {
    single_file_support = false,
    root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
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
    root_dir = function(fname)
      return util.root_pattern 'tsconfig.json'(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
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
    filetypes = {
      'javascript',
      'typescript',
    },
    on_new_config = function(_, new_root_dir)
      local is_deno = utils.config_file_exists(new_root_dir, { 'deno.json', 'deno.jsonc' })
      if is_deno then
        return false
      end
    end,
  },

  volar = utils.create_server_config {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
  },

  eslint = utils.create_server_config {
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
  },
}
