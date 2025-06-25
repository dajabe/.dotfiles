local utils = require 'plugins.lsp.utils'

return {
  pylsp = utils.create_server_config {
    settings = {
      pylsp = {
        plugins = {
          black = { enabled = true },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          pylint = { enabled = true, executable = 'pylint' },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
        },
      },
    },
  },
}
