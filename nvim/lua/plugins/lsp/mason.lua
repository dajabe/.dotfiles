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
    automatic_enable = false,
  }

  for server_name, server_config in pairs(mason_servers) do
    vim.lsp.config(server_name, server_config)
    vim.lsp.enable(server_name)
  end
end

function M.get_mason_servers()
  return mason_servers
end

return M
