# Hyprland monitor roles brief

## Problem

The current Hyprland workspace routing is based on physical monitor names or layout position. That is brittle across laptop, docked, desktop, and hotplug states because Hyprland does not have a primary monitor concept and connector names can change depending on docks, ports, or boot order.

The desired behaviour is consistent and repeatable workspace placement across different monitor setups without hard-coding workspace policy directly to connector names like `DP-1`, `DP-2`, or `HDMI-A-1`.

## Goal

Create a small monitor-role abstraction layer in the Hyprland Lua configuration.

Physical monitors should be resolved into logical roles:

- `primary`
- `secondary`
- `tertiary`

Workspace behaviour should then target roles rather than physical connector names.

```text
Physical monitors
       ↓
Monitor identity resolver
       ↓
Remembered monitor-set profile
       ↓
Role assignment
       ↓
Workspace policy
       ↓
Workspace routing
```

## Desired behaviour

### One monitor

All numbered workspaces remain usable on the only connected monitor.

```text
primary -> workspaces 1-10
```

### Two monitors

Workspaces are split predictably by role.

```text
primary   -> workspaces 1-5
secondary -> workspaces 6-10
```

### Three monitors

This can be added later, but the intended shape is:

```text
primary   -> workspaces 1-5
secondary -> workspaces 6-10
tertiary  -> workspaces 11-15
```

Initial implementation can ignore richer 3+ monitor behaviour until the 1- and 2-monitor cases are stable.

## Key design principles

- Master config should remain the preferred baseline.
- Laptop support should be achieved through adaptable role resolution, not laptop-only forks.
- Prefer monitor identity/description/EDID-style information over connector names.
- Connector names may be used as a fallback or tie-breaker.
- Keep monitor identification, role assignment, and workspace policy separate.
- Avoid global Lua variables; modules should return tables/functions.
- Prefer native Hyprland Lua APIs over external scripts where practical.
- Special workspaces should not be routed unless explicitly configured.
- Behaviour should be deterministic after reboot, config reload, and monitor hotplug.

## Proposed modules

### `monitor_identity.lua`

Responsible for turning Hyprland monitor objects into stable monitor identities.

Preferred identity fields, in order:

1. make/model/serial if available
2. description
3. connector name as fallback

It should expose functions such as:

```lua
identify_monitor(monitor)
fingerprint_monitor(monitor)
fingerprint_monitor_set(monitors)
```

The monitor-set fingerprint should be order-independent, e.g. by sorting monitor fingerprints before hashing/joining.

### `monitor_profiles.lua`

Committed defaults for shared behaviour.

Contains:

- role names
- default fallback strategy
- default workspace policy
- optional known monitor preferences that are safe to share

This file should not contain machine-local learned state.

### Machine-local profile store

Local remembered monitor states should live outside git, for example:

```text
~/.local/state/hypr/monitor-profiles.lua
```

or:

```text
~/.local/state/hypr/monitor-profiles.json
```

This store records monitor-set fingerprints and preferred role mappings for each machine.

Example conceptual state:

```lua
return {
  profiles = {
    ["set-id"] = {
      name = "laptop at desk",
      monitors = {
        ["monitor-fingerprint-a"] = "primary",
        ["monitor-fingerprint-b"] = "secondary",
      },
      workspace_policy = "two-monitor",
    },
  },
}
```

### `monitor_roles.lua`

Responsible for assigning roles to currently connected monitors.

Flow:

1. identify connected monitors
2. fingerprint current monitor set
3. load matching machine-local profile if present
4. apply remembered role assignments if available
5. otherwise fall back to deterministic default rules

Fallback rules might be:

1. one monitor: assign `primary`
2. known monitor preference from shared config
3. laptop panel preference if configured
4. physical layout order
5. connector name as final tie-breaker

### `workspace_policy.lua`

Responsible for mapping roles to workspace ranges.

Initial policy:

```lua
one_monitor = {
  primary = { 1, 10 },
}

two_monitor = {
  primary = { 1, 5 },
  secondary = { 6, 10 },
}
```

Later policy:

```lua
three_monitor = {
  primary = { 1, 5 },
  secondary = { 6, 10 },
  tertiary = { 11, 15 },
}
```

### `workspace_router.lua`

Responsible for applying the resolved role/policy output to Hyprland.

It should:

- get monitors via `hl.get_monitors()` or verified equivalent
- resolve roles
- calculate target monitor for each numbered workspace
- move existing workspaces with Hyprland dispatchers
- listen to relevant monitor/workspace events
- debounce hotplug/config reload events

Expected events:

```lua
hl.on("hyprland.start", route)
hl.on("monitor.added", route)
hl.on("monitor.removed", route)
hl.on("monitor.layout_changed", route)
hl.on("workspace.created", route)
hl.on("config.reloaded", route)
```

The router should eventually replace the external `hypr/scripts/route-workspaces` shell script if Lua proves reliable.

## Hyprland APIs to verify before implementation

The installed Hyprland version exposes symbols for:

- `hl.get_monitors`
- `hl.get_monitor`
- `hl.get_active_monitor`
- `hl.get_monitor_at`
- `hl.get_monitor_at_cursor`
- `hl.workspace_rule`
- `hl.on`

Relevant events appear to include:

- `hyprland.start`
- `monitor.added`
- `monitor.removed`
- `monitor.focused`
- `monitor.layout_changed`
- `workspace.created`
- `workspace.move_to_monitor`
- `config.reloaded`

Before implementation, inspect actual return shapes from `hl.get_monitors()` in the current Hyprland Lua runtime, especially fields for:

- connector name
- description
- make/model/serial
- x/y position
- enabled/focused state

## Remembered monitor states

The system should be able to remember different physical setups.

Examples:

```text
Laptop alone:
eDP-1 -> primary

Laptop + home monitor:
external monitor -> primary
eDP-1            -> secondary

Laptop + docked office monitors:
left external  -> primary
right external -> secondary
eDP-1          -> tertiary or active but unused for automatic ranges
```

A remembered setup should be keyed by the set of connected monitor fingerprints, not by connector order.

When a known setup is detected, its remembered role assignment should override fallback rules.

When an unknown setup is detected, first implementation can use fallback roles and optionally notify/log the detected fingerprints for manual profile creation.

## Open questions

- When laptop `eDP-1` and one external are connected, should the external or laptop panel be default `primary` for unknown setups?
- Should unknown setups auto-create draft local profiles, or only log/notify?
- Should local state be Lua or JSON?
- How should duplicate identical monitors be disambiguated if serial numbers are unavailable?
- Should the first implementation actively route workspaces immediately, or initially run in debug/logging mode?
- Should Hyprland notifications be used when an unknown monitor setup is detected?

## Incremental implementation plan

1. Add debug helper to inspect `hl.get_monitors()` output.
2. Build monitor identity/fingerprint module.
3. Build role resolver with no persistence.
4. Build workspace policy module for one and two monitors.
5. Build Lua workspace router alongside the existing shell script.
6. Test reboot, reload, hotplug, laptop-only, and two-monitor states.
7. Add machine-local profile loading.
8. Add optional unknown-profile notification/debug output.
9. Remove external shell script once Lua routing is reliable.
10. Add 3-monitor policy after the simpler cases are stable.
