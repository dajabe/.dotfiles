local function show_mode()
  local mode_map = {
    ['n'] = 'N',
    ['no'] = 'OP',
    ['nov'] = 'OP',
    ['noV'] = 'OP',
    ['no\22'] = 'OP',
    ['niI'] = 'N',
    ['niR'] = 'N',
    ['niV'] = 'N',
    ['nt'] = 'N',
    ['ntT'] = 'N',
    ['v'] = 'V',
    ['vs'] = 'V',
    ['V'] = 'VL',
    ['Vs'] = 'VL',
    ['\22'] = 'VB',
    ['\22s'] = 'VB',
    ['s'] = 'S',
    ['S'] = 'SL',
    ['\19'] = 'SB',
    ['i'] = 'I',
    ['ic'] = 'I',
    ['ix'] = 'I',
    ['R'] = 'R',
    ['Rc'] = 'R',
    ['Rx'] = 'R',
    ['Rv'] = 'VR',
    ['Rvc'] = 'VR',
    ['Rvx'] = 'VR',
    ['c'] = 'C',
    ['cv'] = 'EX',
    ['ce'] = 'EX',
    ['r'] = 'R',
    ['rm'] = 'M',
    ['r?'] = 'C',
    ['!'] = 'SH',
    ['t'] = 'T',
  }

  local mode = vim.api.nvim_get_mode().mode
  return mode_map[mode] or mode
end

local git_blame = require 'gitblame'
-- I might want to return to truncating blame messages but for now we'll leave it out
local function truncate_message(message, max_length)
  if #message > max_length then
    return string.sub(message, 1, max_length) .. '...'
  else
    return message
  end
end

local function show_blame()
  local blame_info = git_blame.get_current_blame_text()
  return truncate_message(blame_info, 100)
end

local function format_branch_name(branch_name)
  if branch_name:match '.-/sc-%d+/' then
    return branch_name:match '([^/]+/sc-%d+)'
  elseif branch_name:match '.-/' then
    return branch_name:match '.-/([^/]+)$'
  else
    return branch_name
  end
end

local function show_branch()
  local branch
  if vim.fn.exists ':Gbranch' == 2 then
    branch = vim.fn['fugitive#head']()
  else
    branch = vim.fn.system('git branch --show-current'):gsub('%s+', '')
  end
  return truncate_message(format_branch_name(branch), 20)
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'nightfly',
        component_separators = { left = '  ~', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { show_mode },
        lualine_b = { { show_branch, icon = '' }, 'diff', { 'diagnostics', padding = 1 } },
        -- lualine_b = { 'branch', 'diff', { 'diagnostics', padding = 1 } },
        lualine_c = { { 'filename', path = 1 }, { show_blame, cond = git_blame.is_blame_text_available } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
