return {
  notify = function ()
      local workspace = "thingy"
      -- hl.get_active_workspace()
      -- hl.dsp.workspace.toggle_special()
      hl.exec_cmd("notify-send -a Hyprland -e -t 1000 '" .. workspace .. "'")
  end
}
