local utils = require 'plugins.lsp.utils'
local util = require 'lspconfig/util'

return {
  ruby_lsp = utils.create_server_config {
    vscode = true,
    filetypes = { 'ruby', 'eruby' },
    settings = {
      rubocop = {
        use_bundler = true,
        auto_correct = true,
        auto_correct_all = true,
      },
    },
  },

  solargraph = utils.create_server_config {
    root_dir = util.root_pattern('Gemfile', '.git') and util.root_pattern 'solargraph.yml',
  },
}
