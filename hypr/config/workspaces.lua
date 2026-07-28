local v = require("config.vars")

-- DP-2: left / primary monitor
hl.workspace_rule({
    workspace = "1",
    default_name = "web",
    monitor = "DP-2",
    default = true,
    on_created_empty = v.browser,
})

hl.workspace_rule({
    workspace = "2",
    default_name = "shell",
    monitor = "DP-2",
    on_created_empty = v.terminal,
})

hl.workspace_rule({
    workspace = "3",
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = "4",
    monitor = "DP-2",
})

-- HDMI-A-1: right / secondary monitor
hl.workspace_rule({
    workspace = "5",
    default_name = "music",
    monitor = "HDMI-A-1",
    default = true,
})

for workspace = 6, 9 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        monitor = "HDMI-A-1",
    })
end
