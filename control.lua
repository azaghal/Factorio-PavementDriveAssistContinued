-- Copyright (2020) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Provided under MIT license. See license.txt for details.
-- This is the control script. For configuration options see config.lua.

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

-- if the player presses the return key, this event is fired to set the current cruise control limit
script.on_event("set_cruise_control_limit_ok", function(event)
    pda.set_cruise_control_limit_ok(event)
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

-- if the runtime configuration of this mod is changed during gameplay
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    pda.on_settings_changed(event)
end)

-- if an sign is placed by the player or a robot
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built}, function(event)
    pda.on_placed_sign(event)
end)

script.on_event({defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.script_raised_destroy}, function(event)
    pda.on_sign_removed(event)
end)

-- if a shortcut button is pressed
script.on_event(defines.events.on_lua_shortcut, function(event)
	pda.on_lua_shortcut(event)
end)

-- Main routine
script.on_event(defines.events.on_tick, function(event)
    pda.on_tick(event)
end)
