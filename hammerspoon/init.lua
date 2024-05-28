-- map used functions to easier to reach variables
local hotkey = require 'hs.hotkey'
local dialog = require 'hs.dialog'
local alert = require 'hs.alert'
local clipboard = require 'hs.pasteboard'

local function typeTextToClipboard()
  local button, inputText = dialog.textPrompt('Copy Text to Clipboard', '', '', 'OK', 'Cancel')

  if button == 'OK' then
    clipboard.setContents(inputText)
    alert.show 'Text copied to clipboard!'
  end
end

-- Hotkey setup
-- Hyper modifier - { "cmd", "alt", "ctrl", "shift" }
-- Meh modifier - { "alt", "ctrl", "shift" }
hotkey.bind({ 'cmd', 'alt', 'ctrl', 'shift' }, 'T', typeTextToClipboard)
hotkey.bind({ 'alt', 'ctrl', 'shift' }, '=', hs.reload)

-- Show a message that Hammerspoon has loaded the configuration
alert.show(' Hammerspoon config loaded! ', {
  strokeWidth = 1,
  fillColor = { hex = '#1b1d29', alpha = 0.85 },
  radius = 10,
  atScreenEdge = 0,
  textSize = 14,
  textFont = 'Monoid Nerd Font',
})
