-- Copyright (c) 2022 Branko Majic

local cruise_control_limit_gui = require("scripts.gui.cruise_control_limit")
local pda = require("scripts.pda")

local shortcuts = {}


--- Event handler for activating shortcuts.
--
-- @param event EventData Event data passed-on by the game engine.
--
function shortcuts.on_lua_shortcut(event)
    local player = game.players[event.player_index]
    local shortcut = event.prototype_name

    if shortcut == "pda-cruise-control-toggle" then
        pda.toggle_cruise_control(player)
    elseif shortcut == "pda-drive-assistant-toggle" then
        pda.toggle_drive_assistant(player)
    elseif shortcut == "pda-set-cruise-control-limit" then
        cruise_control_limit_gui.on_set_cruise_control_limit(event)
    end
end


return shortcuts
