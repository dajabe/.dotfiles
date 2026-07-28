hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("/usr/bin/waybar")
    hl.exec_cmd("/opt/1Password/1password --silent")
end)

