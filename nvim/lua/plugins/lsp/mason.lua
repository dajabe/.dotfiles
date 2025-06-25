local M = {}
local utils = require 'plugins.lsp.utils'

local mason_servers = {
  lua_ls = utils.create_server_config {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = {
            '${3rd}/luv/library',
            unpack(vim.api.nvim_get_runtime_file('', true)),
          },
        },
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },

  csharp_ls = utils.create_server_config {},
}

function M.setup()
  require('mason').setup()

  require('mason-lspconfig').setup {
    ensure_installed = vim.tbl_keys(mason_servers),
    automatic_installation = true,
    handlers = {
      function(server_name)
        local server_config = mason_servers[server_name] or {}
        require('lspconfig')[server_name].setup(server_config)
      end,
    },
  }
end

function M.get_mason_servers()
  return mason_servers
end

return M
