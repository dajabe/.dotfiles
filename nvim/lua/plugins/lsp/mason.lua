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

  -- First setup the servers directly with lspconfig
  local lspconfig = require('lspconfig')
  for server_name, server_config in pairs(mason_servers) do
    lspconfig[server_name].setup(server_config)
  end

  -- Then setup mason-lspconfig just for ensuring packages are installed
  -- We delay this to avoid the automatic setup issues
  vim.defer_fn(function()
    require('mason-lspconfig').setup {
      ensure_installed = vim.tbl_keys(mason_servers),
      automatic_installation = false,
      handlers = nil, -- Explicitly set handlers to nil to disable automatic setup
    }
  end, 100)
end

function M.get_mason_servers()
  return mason_servers
end

return M
