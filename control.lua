-- Copyright (2017) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly. 
-- Provided under MIT license. See license.txt for details. 
-- This is the control script. For configuration options see config.lua.

require "math"
require "config"
require "modgui"
require "interfaces"
require "pda"


-- fired if a player enters or leaves a vehicle
script.on_event(defines.events.on_player_driving_changed_state, function(event)
    pda.on_player_driving_changed_state(event)
end)

-- some (including this) mod was modified, added or removed from the game  
script.on_configuration_changed(function(data)
    pda.on_configuration_changed(data)
end)

-- if the player presses the respective key, this event is fired to toggle the current state of cruise control
script.on_event("toggle_cruise_control", function(event)
    pda.toggle_cruise_control(event)
end)

-- if the player presses the respective key, this event is fired to show/set the current cruise control limit
script.on_event("set_cruise_control_limit", function(event)
    pda.set_cruise_control_limit(event)
end)

-- handle gui interaction
script.on_event(defines.events.on_gui_click, function(event)
    pda.on_gui_click(event)
end)

-- if the player presses the respective key, this event is fired to toggle the current state of the driving assistant
script.on_event("toggle_drive_assistant", function(event)
    pda.toggle_drive_assistant(event)
end)

-- on game start 
script.on_init(function(data)
    pda.on_init(data)
end)

-- joining players that drove vehicles while leaving the game are in the "offline_players_in_vehicles" list and will be put back to normal
script.on_event(defines.events.on_player_joined_game, function(event)
    pda.on_player_joined_game(event)
end)

-- puts leaving players currently driving a vehicle in the "offline_players_in_vehicles" list
script.on_event(defines.events.on_player_left_game, function(event)
    pda.on_player_left_game(event)
end)

-- Main routine
script.on_event(defines.events.on_tick, function(event)
    pda.on_tick(event)
end)

