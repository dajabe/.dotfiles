return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters = {
      rubocop = {
        prepend_args = { '--autocorrect-all' },
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      bash = { 'shfmt' },
      sh = { 'shfmt' },
      -- ruby = { { 'rubocop' } },
      javascript = { 'prettier' },
      -- Conform can also run multiple formatters sequentially
      --
      -- python = { "isort", "black" },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
  },
}
