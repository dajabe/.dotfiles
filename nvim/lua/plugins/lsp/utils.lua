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

function M.root_with_markers(markers)
  return function(bufnr, on_dir)
    local root_dir = vim.fs.root(bufnr, markers)
    if root_dir then
      on_dir(root_dir)
    end
  end
end

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.general.positionEncodings = { 'utf-16' }
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
  return capabilities
end

function M.create_server_config(server_config)
  local config = server_config or {}
  config.offset_encoding = config.offset_encoding or 'utf-16'
  config.capabilities = vim.tbl_deep_extend('force', {}, M.get_capabilities(), config.capabilities or {})
  return config
end

function M.load_servers()
  local servers_path = vim.fn.stdpath 'config' .. '/lua/plugins/lsp/servers'
  local server_files = vim.fn.globpath(servers_path, '*.lua', false, true)

  for _, file in ipairs(server_files) do
    local server_name = vim.fn.fnamemodify(file, ':t:r')
    local ok, server_config = pcall(require, 'plugins.lsp.servers.' .. server_name)

    if ok and type(server_config) == 'table' then
      -- Each server file returns a table with server names as keys
      for name, config in pairs(server_config) do
        if type(config) == 'table' then
          vim.lsp.config(name, config)
          vim.lsp.enable(name)
        end
      end
    end
  end
end

return M
