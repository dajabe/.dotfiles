local is_prettier_installed = require('dajabe.helpers').is_prettier_installed

-- Set per language lsp fallback options
local lsp_fallback = setmetatable({
  ruby = 'always',
  typescript = not is_prettier_installed(),
  javascript = not is_prettier_installed(),
  typescriptreact = not is_prettier_installed(),
  javascriptreact = not is_prettier_installed(),
}, {
  __index = function()
    return true
  end,
})

-- Define formatters based on Prettier availability
local js_ts_formatters = is_prettier_installed() and { 'prettierd', 'prettier' } or {}

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      bash = { 'shfmt' },
      sh = { 'shfmt' },
      javascript = js_ts_formatters,
      typescript = js_ts_formatters,
      javascriptreact = js_ts_formatters,
      typescriptreact = js_ts_formatters,
      python = { 'blue' },
    },
    format_on_save = function(buf)
      return {
        timeout_ms = 500,
        lsp_fallback = lsp_fallback[vim.bo[buf].filetype],
      }
    end,
  },
}
