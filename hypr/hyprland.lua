require("config.monitors")
require("config.autostart")
require("config.appearance")
require("config.input")
require("config.workspaces")
require("config.keybindings")

-- local v = require("config.vars")

---------------------------
--- ENVIRONMENT VARIABLES -
---------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- NVIDIA proprietary driver
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")


--------------------
--- WINDOW RULES ---
--------------------

hl.window_rule({
    name = "suppress-maximize-events",

    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",

    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})
