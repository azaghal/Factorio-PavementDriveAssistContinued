-- Copyright (c) 2016 sillyfly
-- Copyright (c) 2020 Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

local config = require("scripts.config")
local interfaces = require("scripts.interfaces")
local pda = require("scripts.pda")

local cruise_control_limit_gui = require("scripts.gui.cruise_control_limit")
local shortcuts = require("scripts.gui.shortcuts")

-- Shortcut toggling and custom inputs.
script.on_event("set_cruise_control_limit", cruise_control_limit_gui.on_set_cruise_control_limit)
script.on_event("toggle_cruise_control", pda.on_toggle_cruise_control)
script.on_event("toggle_drive_assistant", pda.on_toggle_drive_assistant)
script.on_event(defines.events.on_lua_shortcut, shortcuts.on_lua_shortcut)

-- Data initialisation and configuration changes/updates.
script.on_init(pda.on_init)
script.on_configuration_changed(pda.on_init)
script.on_event(defines.events.on_runtime_mod_setting_changed, pda.on_runtime_mod_setting_changed)

-- Players joing/leaving game and getting in and out of vehicles.
script.on_event(defines.events.on_player_driving_changed_state, pda.on_player_driving_changed_state)
script.on_event(defines.events.on_player_joined_game, pda.on_player_joined_game)
script.on_event(defines.events.on_player_left_game, pda.on_player_left_game)

-- GUI handling (for setting cruise control limt).
script.on_event(defines.events.on_gui_click, cruise_control_limit_gui.on_gui_click)
script.on_event(defines.events.on_gui_closed, cruise_control_limit_gui.on_gui_closed)
script.on_event({defines.events.on_gui_confirmed, "confirm_set_cruise_control_limit"}, cruise_control_limit_gui.on_gui_confirmed)

-- Entity placement and destruction.
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}, pda.on_placed_sign)
script.on_event({defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.script_raised_destroy}, pda.on_sign_removed)

-- Research.
script.on_event(defines.events.on_research_finished, pda.on_research_finished)
script.on_event(defines.events.on_research_reversed, pda.on_research_reversed)
script.on_event(defines.events.on_force_reset, pda.on_research_reversed)

-- Vehicle pathing corrections (main functionality).
script.on_event(defines.events.on_tick, pda.on_tick)

-- Interfaces for interacting with PDA.
remote.add_interface("PDA", interfaces)
