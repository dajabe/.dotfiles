local v = require("config.vars")

local function hostname()
    local file = io.open("/etc/hostname", "r")
    if file == nil then
        return ""
    end

    local name = file:read("*l") or ""
    file:close()
    return name
end

local function workspace_monitors()
    -- Keep the fixed desktop layout explicit. Other machines fall back to the
    -- laptop panel so the shared config remains usable when DP-2/HDMI-A-1 do
    -- not exist.
    if hostname() == "tanker" then
        return "DP-2", "HDMI-A-1"
    end

    return "eDP-1", "eDP-1"
end

local primary_monitor, secondary_monitor = workspace_monitors()

hl.config({
    binds = {
        hide_special_on_workspace_change = true,
    },
})

hl.workspace_rule({
    workspace = "1",
    default_name = "web",
    monitor = primary_monitor,
    default = true,
    on_created_empty = v.browser,
})

hl.workspace_rule({
    workspace = "2",
    default_name = "shell",
    monitor = primary_monitor,
    on_created_empty = v.terminal,
})

hl.workspace_rule({
    workspace = "3",
    monitor = primary_monitor,
})

hl.workspace_rule({
    workspace = "4",
    monitor = primary_monitor,
})

hl.workspace_rule({
    workspace = "5",
    default_name = "music",
    monitor = secondary_monitor,
    default = true,
})

for workspace = 6, 9 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        monitor = secondary_monitor,
    })
end

hl.workspace_rule({
    workspace = "special:qalculate",
    on_created_empty = "qalculate-gtk",
})
