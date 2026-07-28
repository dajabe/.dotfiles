local v = require("config.vars")

-- HDMI-A-1: right monitor
hl.workspace_rule({
    workspace = "1",
    default_name = "web",
    monitor = "HDMI-A-1",
    default = true,
    on_created_empty = v.browser,
})

hl.workspace_rule({
    workspace = "2",
    default_name = "shell",
    monitor = "HDMI-A-1",
    on_created_empty = v.terminal,
})

hl.workspace_rule({
    workspace = "3",
    monitor = "HDMI-A-1",
})

hl.workspace_rule({
    workspace = "4",
    monitor = "HDMI-A-1",
})

-- DP-2: left monitor
hl.workspace_rule({
    workspace = "5",
    default_name = "music",
    monitor = "DP-2",
    default = true,
})

for workspace = 6, 9 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        monitor = "DP-2",
    })
end
