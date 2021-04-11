-- Copyright (2017) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly. 
-- Provided under MIT license. See license.txt for details. 
-- This is the interface script. 

require "pda"
require "config"

local pda_interface = {}

function pda_interface.get_state_of_cruise_control(id)
    local player = game.players[id]
    return global.cruise_control[player.index]
end

function pda_interface.set_state_of_cruise_control(id, state)
    local player = game.players[id]
    if ((state == false) or (state == true)) then
        global.cruise_control[player.index] = state
    end
end

function pda_interface.get_cruise_control_limit(id)
    local player = game.players[id]
    return global.cruise_control_limit[player.index]
end

function pda_interface.set_cruise_control_limit(id, limit)
    local player = game.players[id]
    local hard_speed_limit = global.hard_speed_limit
    if tonumber(limit) ~= nil then
        if limit < 0 then 
            limit = -limit 
        end
        if (hard_speed_limit > 0) and (limit > hard_speed_limit) then 
            limit = hard_speed_limit
        end
        global.cruise_control_limit[player.index] = limit
    end
    return limit
end

function pda_interface.get_state_of_driving_assistant(id)
    local player = game.players[id]
    return global.drive_assistant[player.index]
end

function pda_interface.set_state_of_driving_assistant(id, state)
    local player = game.players[id]
    if ((state == false) or (state == true)) then
        global.drive_assistant[player.index] = state
    end
end

remote.add_interface("PDA", pda_interface)