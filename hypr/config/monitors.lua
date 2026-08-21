-- Left monitor
hl.monitor({
    output = "DP-2",
    mode = "2560x1440@59.951",
    position = "0x0",
    scale = 1,
})

-- Right monitor
hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@59.951",
    position = "2560x0",
    scale = 1,
})

-- Laptop monitor
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- Fallback for any additional monitors
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})


