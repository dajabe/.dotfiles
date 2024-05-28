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

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local custom_fname = require('lualine.components.filename'):extend()
    local highlight = require 'lualine.highlight'
    local default_status_colors = { saved = '#122c08', modified = '#8b7300' }

    function custom_fname:init(options)
      custom_fname.super.init(self, options)
      self.options.path = 1
      self.status_colors = {
        saved = highlight.create_component_highlight_group({ bg = default_status_colors.saved }, 'filename_status_saved', self.options),
        modified = highlight.create_component_highlight_group({ bg = default_status_colors.modified }, 'filename_status_modified', self.options),
      }
      if self.options.color == nil then
        self.options.color = ''
      end
    end

    function custom_fname:update_status()
      local data = custom_fname.super.update_status(self)
      data = highlight.component_format_highlight(vim.bo.modified and self.status_colors.modified or self.status_colors.saved) .. data
      return data
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'nightfly',
        component_separators = { left = '', right = '' },
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
        lualine_b = { 'branch', 'diff', { 'diagnostics', padding = 1 } },
        -- lualine_b = { 'branch', 'diff', { 'diagnostics', padding = 1 } },
        lualine_c = { { custom_fname } },
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
