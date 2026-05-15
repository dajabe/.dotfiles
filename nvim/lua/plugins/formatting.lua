local is_prettier_installed = require('dajabe.helpers').is_prettier_installed

-- Set per language LSP formatting options.
local lsp_format = setmetatable({
  ruby = 'never',
  typescript = is_prettier_installed() and 'never' or 'fallback',
  javascript = is_prettier_installed() and 'never' or 'fallback',
  typescriptreact = is_prettier_installed() and 'never' or 'fallback',
  javascriptreact = is_prettier_installed() and 'never' or 'fallback',
}, {
  __index = function()
    return 'fallback'
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
      markdown = { 'markdownfmt' },
    },
    format_on_save = function(buf)
      return {
        timeout_ms = 500,
        lsp_format = lsp_format[vim.bo[buf].filetype],
      }
    end,
  },
}
