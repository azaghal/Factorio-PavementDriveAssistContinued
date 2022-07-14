-- Copyright (c) 2019 Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

-- This is the gui design script. The design was heavily inspired by @GotLag's "Renamer".

local cruise_control_limit_gui = {}


--- Opens dialog for setting cruise control limit.
--
-- @param player LuaPlayer Player for which to open the dialog.
--
function cruise_control_limit_gui.build(player)
    local frame = player.gui.center.add
    {
        type="frame",
        name="pda_cc_limit_gui_frame",
        caption= {"DA-gui-label-set-cruise-control"}
    }
    frame.add
    {
        type = "button",
        name = "pda_cc_limit_gui_close",
        caption = " X ",
        style = "Arci-pda-gui-style"
    }
    frame.add
    {
        type = "textfield",
        name = "pda_cc_limit_gui_textfield",
        numeric = true
    }
    frame.add
    {
        type = "label",
        name = "pda_cc_limit_gui_label",
        caption= {"DA-gui-label-kmh"}
    }
    frame.add
    {
      type = "button",
      name = "pda_cc_limit_gui_confirm",
      caption = "OK",
      style = "Arci-pda-gui-style"
    }

    -- Make the created/opened frame as top one upon creation (so user
    -- can close it by pressing Escape key).
    player.opened = frame
end


return cruise_control_limit_gui
