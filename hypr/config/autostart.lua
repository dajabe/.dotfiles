hl.on("hyprland.start", function()
    -- hl.exec_cmd("systemctl --user start hyprpolkitagent")
    -- wayle is launched by the user service
    -- hl.exec_cmd("wayle shell")
    hl.exec_cmd("/opt/1Password/1password --silent")
end)

