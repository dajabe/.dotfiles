vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function detect_go_html_tmpl()
  local extension = vim.fn.expand '%:e'
  if extension == 'html' and vim.fn.search '{{' ~= 0 then
    vim.bo.filetype = 'gohtmltmpl'
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead', 'BufNewFile' }, {
  pattern = '*.html',
  callback = detect_go_html_tmpl,
})
