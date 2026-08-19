local v = require("config.vars")
local u = require("config.utils")
local mainMod = v.mainMod

-- Applications and window management
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(v.terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(v.browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(v.fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(v.menu))

hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({
    action = "toggle",
}))

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SLASH", hl.dsp.layout("togglesplit"))

hl.bind(
    mainMod .. " + M",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1"
            .. " && hyprshutdown"
            .. " || hyprctl dispatch 'hl.dsp.exit()'"
    )
)

--- Workspace
for workspace = 1, 10 do
    local key = workspace % 10

    hl.bind(
      mainMod .. " + " .. key,
      hl.dsp.focus({
          workspace = workspace,
      })
    )

    hl.bind(
      mainMod .. " + SHIFT + " .. key,
      hl.dsp.window.move({
          workspace = workspace,
      })
    )
end

-- Scratchpad
hl.bind(
    mainMod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)

hl.bind(
    mainMod .. " + SHIFT + S",
    hl.dsp.window.move({
        workspace = "special:magic",
    })
)

-- Calculator scratchpad
hl.bind(
    mainMod .. " + A",
    hl.dsp.workspace.toggle_special("qalculate")
)

-- Scroll through existing workspaces
hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({
        workspace = "e+1",
    })
)

hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({
        workspace = "e-1",
    })
)


---------------------
--- MOUSE BINDS -----
---------------------

hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
    }
)

hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
    }
)


----------------------
--- AUDIO CONTROLS ---
----------------------

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ),
    {
        locked = true,
        repeating = true,
    }
)


--------------------------
--- BRIGHTNESS CONTROLS --
--------------------------

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set 10%+"),
    {
        locked = true,
        repeating = true,
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 10%-"),
    {
        locked = true,
        repeating = true,
    }
)


---------------------
--- MEDIA CONTROLS --
---------------------

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true,
    }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
    }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true,
    }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true,
    }
)

---------------------
--- FOCUS MOVEMENT --
---------------------

local focusBinds = {
    left = "left",
    H = "left",

    right = "right",
    L = "right",

    up = "up",
    K = "up",

    down = "down",
    J = "down",
}

for key, direction in pairs(focusBinds) do
    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({
            direction = direction,
        })
    )
end

