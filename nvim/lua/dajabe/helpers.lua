local M = {}

M.is_prettier_installed = function()
  return vim.fn.executable 'prettier' == 1 or vim.fn.executable 'prettierd' == 1
end

M.project_file_exists = function(root_dir, filepath)
  return vim.fn.filereadable(root_dir .. '/' .. filepath) == 1
end

return M
