local utils = require 'plugins.lsp.utils'

return {
  ruby_lsp = utils.create_server_config {
    init_options = {
      formatter = 'rubocop',
      linters = { 'rubocop' },
    },
  },

  rubocop = utils.create_server_config {
    cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    init_options = {
      safeAutocorrect = false,
    },
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            async = false,
            filter = function(c)
              return c.name == 'rubocop'
            end
          })
        end,
      })
    end,
  },

  solargraph = utils.create_server_config {},
}
