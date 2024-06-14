-- map used functions to easier to reach variables
local hotkey = require 'hs.hotkey'
local dialog = require 'hs.dialog'
local clipboard = require 'hs.pasteboard'
local geo = require 'hs.geometry'

local function alert(message)
  hs.alert.show(message, {
    strokeWidth = 1,
    fillColor = { hex = '#1b1d29', alpha = 0.85 },
    radius = 10,
    atScreenEdge = 0,
    textSize = 14,
    textFont = 'Monoid Nerd Font',
  })
end

local function sleep(deciseconds)
  hs.timer.usleep(deciseconds * 100000)
end

local function typeTextToClipboard()
  local button, inputText = dialog.textPrompt('Copy Text to Clipboard', '', '', 'OK', 'Cancel')

  if button == 'OK' then
    clipboard.setContents(inputText)
    alert 'Text copied to clipboard!'
  end
end

local function showWindowInfo()
  local win = hs.window.frontmostWindow()
  if win then
    local frame = win:frame()
    local app = win:application()
    local bundleID = app:bundleID()

    local infoString = string.format('%s\n%s - %s\n%d x %d\n%s', win:title(), app:name(), app:path(), frame.w, frame.h, bundleID)
    alert(infoString)
    clipboard.setContents(bundleID)
  else
    alert 'No active window found.'
  end
end

local function cascadeWindows()
  local screen = hs.screen.mainScreen()
  local screenFrame = screen:frame()
  local allWindows = hs.window.allWindows()
  local x, y
  -- set cascading offsets
  local xOffsetChrome, yOffsetChrome = 180, 90
  local xOffsetOther, yOffsetOther = 80, 50
  -- Set window sizes
  local chromeWidth, chromeHeight = 2040, 1200
  local otherWidth, otherHeight = 1600, 1000

  -- Separate Chrome windows from other windows
  local chromeWindows, otherWindows = {}, {}
  for _, win in ipairs(allWindows) do
    if win:screen() == screen then
      if win:application():name() == 'Google Chrome' then
        table.insert(chromeWindows, win)
      else
        table.insert(otherWindows, win)
      end
    end
  end

  -- Sort other windows reverse order to get notion below postman
  table.sort(otherWindows, function(a, b)
    return a:title() > b:title()
  end)

  -- cascade chrome windows from top right to bottom left
  for i, win in ipairs(chromeWindows) do
    if i == 1 then
      x = screenFrame.w - chromeWidth
      y = 20
    end
    if win:isStandard() then
      win:setSize(geo.size(chromeWidth, chromeHeight))
      win:setTopLeft(geo.point(x, y))
      y = y + yOffsetChrome
      x = x - xOffsetChrome
      sleep(1)
    end
  end

  -- cascade all other windows in the reverse direction
  for i, win in ipairs(otherWindows) do
    if i == 1 then
      x = 0
      y = screenFrame.h - otherHeight
    end
    if win:isStandard() then
      win:setSize(geo.size(otherWidth, otherHeight))
      win:setTopLeft(geo.point(x, y))
      y = y - yOffsetOther
      x = x + xOffsetOther
      sleep(1)
    end
  end
end

-- Hotkey setup
-- Hyper modifier - { "cmd", "alt", "ctrl", "shift" }
-- Meh modifier - { "alt", "ctrl", "shift" }
hotkey.bind({ 'cmd', 'alt', 'ctrl', 'shift' }, 'T', typeTextToClipboard)
hotkey.bind({ 'alt', 'ctrl', 'shift' }, '=', hs.reload)
hotkey.bind({ 'alt', 'ctrl', 'shift' }, 'C', cascadeWindows)
hotkey.bind({ 'cmd', 'alt', 'ctrl', 'shift' }, 'I', showWindowInfo)

-- Show a message that Hammerspoon has loaded the configuration
alert ' Hammerspoon config loaded! '
