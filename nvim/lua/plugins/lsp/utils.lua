local M = {}

function M.config_file_exists(root_dir, config_files)
  local helpers = require 'dajabe.helpers'
  for config_file in pairs(config_files) do
    if helpers.project_file_exists(root_dir, config_file) then
      return true
    end
  end
  return false
end

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  return capabilities
end

function M.create_server_config(server_config)
  local config = server_config or {}
  config.capabilities = vim.tbl_deep_extend('force', {}, M.get_capabilities(), config.capabilities or {})
  return config
end

function M.load_servers()
  local servers_path = vim.fn.stdpath 'config' .. '/lua/plugins/lsp/servers'
  local server_files = vim.fn.globpath(servers_path, '*.lua', false, true)
  local lspconfig = require 'lspconfig'

  for _, file in ipairs(server_files) do
    local server_name = vim.fn.fnamemodify(file, ':t:r')
    local ok, server_config = pcall(require, 'plugins.lsp.servers.' .. server_name)

    if ok and type(server_config) == 'table' then
      -- Each server file returns a table with server names as keys
      for name, config in pairs(server_config) do
        if type(config) == 'table' and config.capabilities then
          lspconfig[name].setup(config)
        end
      end
    end
  end
end

return M
