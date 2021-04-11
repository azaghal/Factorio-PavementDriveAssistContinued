-- Copyright (2019) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly. 
-- Provided under MIT license. See license.txt for details. 
-- This is the gui design script. The design was heavily inspired by @GotLag's "Renamer".

modgui = {}

function modgui.create_cc_limit_gui(player)
    frame = player.gui.center.add
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
        type="textfield",
        name="pda_cc_limit_gui_textfield"
    }
    frame.add
    {
        type="label",
        name="pda_cc_limit_gui_label",
        caption= {"DA-gui-label-kmh"}
    }
    frame.add
    {
      type = "button",
      name = "pda_cc_limit_gui_confirm",
      caption = "OK",
      style = "Arci-pda-gui-style"
    }
  -- end
end