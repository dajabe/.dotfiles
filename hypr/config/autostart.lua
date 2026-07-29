hl.on("hyprland.start", function()
  -- Prefer using systemctl --user for app startups
  -- hl.exec_cmd("systemctl --user start hyprpolkitagent")
  -- hl.exec_cmd("/usr/bin/waybar")
  hl.exec_cmd("/opt/1Password/1password --silent")
end)
