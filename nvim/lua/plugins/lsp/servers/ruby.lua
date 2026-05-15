local utils = require 'plugins.lsp.utils'

return {
  ruby_lsp = utils.create_server_config {
    init_options = {
      formatter = 'none',
      linters = {},
    },
  },

  rubocop = utils.create_server_config {
    cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    init_options = {
      safeAutocorrect = false,
    },
    on_attach = function(client, bufnr)
      client.server_capabilities.documentRangeFormattingProvider = false

      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('rubocop-lsp-format-' .. bufnr, { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            async = false,
            filter = function(c)
              return c.name == 'rubocop'
            end,
          }
        end,
      })
    end,
  },

  solargraph = utils.create_server_config {
    init_options = { formatting = false },
    settings = {
      solargraph = {
        diagnostics = false,
        formatting = false,
      },
    },
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
}
