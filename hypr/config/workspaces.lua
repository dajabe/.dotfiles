local v = require("config.vars")

 hl.config({
     binds = {
         hide_special_on_workspace_change = true,
     },
 })

-- Workspace placement is handled dynamically by scripts/route-workspaces.
-- Keeping these rules monitor-independent makes them safe on a single display.
hl.workspace_rule({
    workspace = "1",
    default_name = "web",
    default = true,
    on_created_empty = v.browser,
})

hl.workspace_rule({
    workspace = "2",
    default_name = "shell",
    on_created_empty = v.terminal,
})

hl.workspace_rule({
    workspace = "3",
})

hl.workspace_rule({
    workspace = "4",
})

hl.workspace_rule({
    workspace = "5",
    default_name = "music",
    default = true,
})

for workspace = 6, 9 do
    hl.workspace_rule({
        workspace = tostring(workspace),
    })
end

hl.workspace_rule({
    workspace = "special:qalculate",
    on_created_empty = "qalculate-gtk",
})
