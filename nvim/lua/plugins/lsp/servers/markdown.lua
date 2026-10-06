local utils = require 'plugins.lsp.utils'

return {
  -- Use nvim-lspconfig's default Marksman command, filetypes, and root markers.
  marksman = utils.create_server_config {},
}
