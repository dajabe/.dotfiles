local M = {}

-- LSP exclusion configuration
local lsp_exclusions = {
  filetypes = {
    'gitcommit',
    'gitrebase',
    'help',
    'man',
    'qf',
    'oil',
  },

  buffer_patterns = {
    '%.git/',
    'COMMIT_EDITMSG',
    'MERGE_MSG',
    'TAG_EDITMSG',
    'git%-rebase%-todo',
  },

  env_variables = {
    'NVIM_NO_LSP',
  },
}

function M.should_setup_lsp()
  -- Check filetype exclusions
  local current_filetype = vim.bo.filetype
  if vim.tbl_contains(lsp_exclusions.filetypes, current_filetype) then
    return false
  end

  -- Check buffer name patterns
  local bufname = vim.api.nvim_buf_get_name(0)
  for _, pattern in ipairs(lsp_exclusions.buffer_patterns) do
    if bufname:match(pattern) then
      return false
    end
  end

  -- Check environment variable exclusions
  for _, env_var in ipairs(lsp_exclusions.env_variables) do
    if os.getenv(env_var) then
      return false
    end
  end

  return true
end

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
