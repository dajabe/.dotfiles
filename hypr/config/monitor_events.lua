local function routeWorkspaces()
    -- The script briefly waits for Hyprland's monitor state to settle and
    -- serializes calls caused by several events arriving together.
    hl.exec_cmd("$HOME/.config/hypr/scripts/route-workspaces")
end

-- Reconcile both existing workspaces and workspaces created later in a session.
hl.on("hyprland.start", routeWorkspaces)
hl.on("monitor.added", routeWorkspaces)
hl.on("monitor.removed", routeWorkspaces)
hl.on("monitor.layout_changed", routeWorkspaces)
hl.on("workspace.created", routeWorkspaces)
hl.on("config.reloaded", routeWorkspaces)
