-- Copyright (c) 2019 Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

-- This is the gui design script. The design was heavily inspired by @GotLag's "Renamer".

local pda = require("scripts.pda")
local utils = require("scripts.utils")

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


--- Toggles dialog for setting the cruise control limit.
--
-- @param player LuaPlayer Player for which the dialog should be shown.
-- @param limit uint Current limit value to show to user.
--
function cruise_control_limit_gui.toggle(player, limit)
    if not player.gui.center.pda_cc_limit_gui_frame then
        cruise_control_limit_gui.build(player)
        player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text = tostring(limit)
        player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.select_all()
        player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.focus()
    else
        player.gui.center.pda_cc_limit_gui_frame.destroy()
    end
end


--- Returns value of cruise control limit that was provided by the player via dialog.
--
-- @param player LuaPlayer Player for which to retrieve the value.
--
-- @return uint Cruise control limit set by player via dialog.
--
function cruise_control_limit_gui.get_cruise_control_limit(player)
    return math.abs(tonumber(player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text))
end


--- Event handler for player dismissing cruise control limit dialog without confirmation.
--
-- @param event EventData Event data passed-on by the game engine.
--
function cruise_control_limit_gui.on_gui_closed(event)
    if event.element and event.element.name == "pda_cc_limit_gui_frame" then
        cruise_control_limit_gui.toggle(game.players[event.player_index])
    end
end


--- Toggles dialog for setting cruise control limit.
--
-- @param player LuaPlayer Player for which the dialog should be toggled.
--
function cruise_control_limit_gui.on_set_cruise_control_limit(event)
    local player = game.players[event.player_index]

    if pda.is_driver_assistance_technology_available(player) then
        if pda.is_cruise_control_allowed() then
            cruise_control_limit_gui.toggle(player, utils.mpt_to_kmph(global.cruise_control_limit[player.index]))
        end
    end
end


--- Event handler for player clicking on a button.
--
-- @param event EventData Event data passed-on by the game engine.
--
function cruise_control_limit_gui.on_gui_click(event)
    local player = game.players[event.player_index]

    if player.gui.center.pda_cc_limit_gui_frame then
        if event.element.name == "pda_cc_limit_gui_close" then
            player.gui.center.pda_cc_limit_gui_frame.destroy()
        elseif event.element.name == "pda_cc_limit_gui_confirm" then
            local limit = cruise_control_limit_gui.get_cruise_control_limit(player)
            pda.set_cruise_control_limit(player, utils.kmph_to_mpt(limit))
            player.gui.center.pda_cc_limit_gui_frame.destroy()
        end
    end
end


--- Event handler for player confirming cruise control limit change.
--
-- @param event EventData Event data passed-on by the game engine.
--
function cruise_control_limit_gui.on_gui_confirmed(event)
    local player = game.players[event.player_index]

    if player.opened and player.opened.name == "pda_cc_limit_gui_frame" then
        local limit = cruise_control_limit_gui.get_cruise_control_limit(player)
        pda.set_cruise_control_limit(player, utils.kmph_to_mpt(limit))
        player.gui.center.pda_cc_limit_gui_frame.destroy()
    end
end


return cruise_control_limit_gui
