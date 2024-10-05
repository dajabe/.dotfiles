-- Set per language lsp fallback options, defaults to true
local lsp_fallback = setmetatable({
  ruby = 'always',
}, {
  __index = function()
    return true
  end,
})

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      bash = { 'shfmt' },
      sh = { 'shfmt' },
      javascript = { 'prettier' },
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
