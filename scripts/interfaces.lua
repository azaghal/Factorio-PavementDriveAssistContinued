-- Copyright (c) 2016 sillyfly
-- Copyright (c) 2017 Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

-- This is the interface script.

local pda = require("pda")
local config = require("config")

local interfaces = {}


--- Retrieves state of cruise control for specified player.
--
-- @param id uint|string Player identifier.
--
-- @return bool true if cruise control is active for a player, false otherwise.
--
function interfaces.get_state_of_cruise_control(id)
    local player = game.players[id]
    return global.cruise_control[player.index]
end


--- Enables/disables cruise control for specified player.
--
-- @param id uint|string Player identifier.
-- @param state bool State of cruise control.
--
function interfaces.set_state_of_cruise_control(id, state)
    local player = game.players[id]
    if state then
        pda.enable_cruise_control(player)
    else
        pda.disable_cruise_control(player)
    end
end


--- Retrieves cruise control limit.
--
-- @param id uint|string Player identifier.
--
-- @return uint Currently set cruise control limit for the player.
--
function interfaces.get_cruise_control_limit(id)
    local player = game.players[id]
    return global.cruise_control_limit[player.index]
end


--- Sets cruise control limit for a player.
--
-- @param id uint|string Player identifier.
-- @param limit uint New cruise control limit.
--
function interfaces.set_cruise_control_limit(id, limit)
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


--- Retrieves state of driving assistant for specified player.
--
-- @param id uint|string Player identifier.
--
function interfaces.get_state_of_driving_assistant(id)
    local player = game.players[id]
    return global.drive_assistant[player.index]
end


--- Enables/disables driving assistant for specified player.
--
-- @param id uint|string Player identifier.
-- @param state bool State of cruise control.
--
function interfaces.set_state_of_driving_assistant(id, state)
    local player = game.players[id]

    if state then
        pda.enable_drive_assistant(player)
    else
        pda.disable_drive_assistant(player)
    end
end

return interfaces
