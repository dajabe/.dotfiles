-- map used functions to easier to reach variables
local hotkey = require 'hs.hotkey'
local dialog = require 'hs.dialog'
local clipboard = require 'hs.pasteboard'
local geo = require 'hs.geometry'

-- Helpers
local function CreateStore()
  local store = {
    data = {},
  }

  function store:add(id, data)
    self.data[id] = data
  end

  function store:clear(id)
    self.data[id] = nil
  end

  function store:get(id)
    return self.data[id]
  end

  return store
end

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

-- Actions
local WindowFrames = CreateStore() -- Store for tracking window frame sizes

local function typeTextToClipboard()
  local focusedApp = hs.application.frontmostApplication()
  local button, inputText = dialog.textPrompt('Copy Text to Clipboard', '', '', 'OK', 'Cancel')

  if button == 'OK' then
    clipboard.setContents(inputText)
    alert 'Text copied to clipboard!'
  end

  focusedApp:activate()
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

local function maximizeWindow()
  local win = hs.window.focusedWindow()
  local winId = win:id()
  local screenFrame = win:screen():frame()
  local gutter = 10

  if WindowFrames:get(winId) then
    win:setFrame(WindowFrames:get(winId), 0)
    WindowFrames:clear(winId)
  else
    WindowFrames:add(winId, win:frame())
    local newFrame = {
      x = screenFrame.x + gutter,
      y = screenFrame.y,
      w = screenFrame.w - gutter * 2,
      h = screenFrame.h - gutter,
    }
    win:setFrame(newFrame, 0)
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
    local winId = win:id()
    if i == 1 then
      x = screenFrame.w - chromeWidth
      y = 20
    end
    if win:isStandard() then
      win:setSize(geo.size(chromeWidth, chromeHeight), 0)
      WindowFrames:clear(winId) -- Clear size from store
      win:setTopLeft(geo.point(x, y))
      y = y + yOffsetChrome
      x = x - xOffsetChrome
      sleep(1)
    end
  end

  -- cascade all other windows in the reverse direction
  for i, win in ipairs(otherWindows) do
    local winId = win:id()
    if i == 1 then
      x = 0
      y = screenFrame.h - otherHeight
    end
    if win:isStandard() then
      win:setSize(geo.size(otherWidth, otherHeight))
      WindowFrames:clear(winId) -- Clear size from store
      win:setTopLeft(geo.point(x, y))
      y = y - yOffsetOther
      x = x + xOffsetOther
      sleep(1)
    end
  end
end

-- Hotkey setup
HyperMod = { 'cmd', 'alt', 'ctrl', 'shift' }
MehMod = { 'alt', 'ctrl', 'shift' }
hotkey.bind(HyperMod, 'T', typeTextToClipboard)
hotkey.bind(HyperMod, 'I', showWindowInfo)
hotkey.bind(MehMod, '=', hs.reload)
hotkey.bind(MehMod, 'C', cascadeWindows)
hotkey.bind(MehMod, 'F', maximizeWindow)

-- Show a message that Hammerspoon has loaded the configuration
alert ' Ready to hammer spoons '
