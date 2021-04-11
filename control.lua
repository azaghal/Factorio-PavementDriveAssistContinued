-- Copyright (2017) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly. 
-- Provided under MIT license. See license.txt for details. 
-- This is the main logic script. For configuration options see config.lua.

require "math"
require "config"

function notification(txt, force)
-- used to output texts to whole forces or all players
    if force ~= nil then
        force.print(txt)
    else
        for k, p in pairs (game.players) do
            game.players[k].print(txt)
        end
    end
end

local function check_compatibility()
-- check if any of the present mods matches a mod in the incompatibility list
    for mod, version in pairs(game.active_mods) do
        if mod_incompatibility_list[mod] then 
            return false
        end
    end
    return true
end

local function incompability_detected()
-- prints out which incompatible mods have been detected
    for mod, version in pairs(game.active_mods) do
        if mod_incompatibility_list[mod] then 
            notification({"DA-mod-incompatibility-notification", {"DA-prefix"}, mod, version})
            -- most likely: Vehicle Snap. If true, then tell the player why this mod is incompatible to PDA
            if mod == "VehicleSnap" then notification({"DA-mod-incompatibility-reason-vecsnap", {"DA-prefix"}}) end
            notification({"DA-mod-incompatibility-advice", {"DA-prefix"}, "Pavement-Drive-Assist"})      
        end
    end
end

local function init_global()
-- get or init persistent vars
    global = global or {}
    global.drive_assistant = global.drive_assistant or {}
    global.cruise_control = global.cruise_control or {}
    global.cruise_control_limit = global.cruise_control_limit or {}
    global.cruise_control_forward = global.cruise_control_forward or {} 
    global.players_in_vehicles = global.players_in_vehicles or {}
    global.playertick = global.playertick or 0
    global.mod_compatibility = nil
    global.last_score = global.last_score or {}
    global.emergency_brake_active = global.emergency_brake_active or {}
end

script.on_event(defines.events.on_player_driving_changed_state, function(event)
-- fired if a player enters a vehicle
    local player = game.players[event.player_index]
    -- put player at last position in list of players in vehicles
    -- only allow certain vehicles (i.e. no trains)
    if (player.vehicle ~= nil) and player.vehicle.valid and player.vehicle.type == "car" and vehicle_blacklist[player.vehicle.name] == nil then 
        -- insert player (or multiple instances of the same player, if benchmark_level > 1) in list
        for i = 1, benchmark_level do
            table.insert(global.players_in_vehicles, event.player_index)
        end
    else
        -- remove player from list. 
        for i=#global.players_in_vehicles, 1, -1 do
            if global.players_in_vehicles[i] == event.player_index then
                table.remove(global.players_in_vehicles, i)
            end
        end
        -- reset emergency brake
        global.emergency_brake_active[event.player_index] = false
    end
    if #global.players_in_vehicles > 0 then
        if debug then
            for i=1, #global.players_in_vehicles, 1 do
                notification(tostring(i..".: Player index"..global.players_in_vehicles[i].." ("..game.players[players_in_vehicles[i]].name..")"))
            end
        end
    else
        if debug then
            notification("List empty.")
        end
    end
end)

script.on_configuration_changed(function(data)
-- some (including this) mod was modified, added or removed from the game    
    init_global()
    if data.mod_changes ~= nil and data.mod_changes["PavementDriveAssist"] ~= nil and data.mod_changes["PavementDriveAssist"].old_version == nil then
        -- anounce installation
        notification({"DA-notification-midgame-update", {"DA-prefix"}, data.mod_changes["PavementDriveAssist"].new_version})
    elseif data.mod_changes ~= nil and data.mod_changes["PavementDriveAssist"] ~= nil and data.mod_changes["PavementDriveAssist"].old_version ~= nil then
        -- anounce update
        local oldver = data.mod_changes["PavementDriveAssist"].old_version
        local newver = data.mod_changes["PavementDriveAssist"].new_version
        notification({"DA-notification-new-version", {"DA-prefix"}, oldver, newver})
    elseif data.mod_changes ~= nil then
        -- some other mod was added, removed or modified. Check, if this mod is or was incompatible with PDA
        global.mod_compatibility = check_compatibility()
        if global.mod_compatibility == false then
            incompability_detected()
        end
    end
end)

-- converts Factorios meter per tick to floored integer kilometer per hour (used for GUI interaction)
local function mpt_to_kmph(mpt)
    return math.floor(mpt * 60 * 60 * 60 / 1000 + 0.5)
end

-- if the player presses the respective key, this event is fired to toggle the current state of cruise control
script.on_event("toggle_cruise_control", function(event)
    local player = game.players[event.player_index]
    if (technology_required and player.force.technologies["Arci-pavement-drive-assistant"].researched or technology_required == false) and global.mod_compatibility then
        if cruise_control_allowed then
            if (global.cruise_control[event.player_index] == nil or global.cruise_control[event.player_index] == false) and player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" and vehicle_blacklist[player.vehicle.name] == nil then 
                global.cruise_control[event.player_index] = true
                -- set cruise control speed limit
                global.cruise_control_limit[event.player_index] = player.vehicle.speed
                -- check for reverse gear
                if player.vehicle.speed < 0 then
                    global.cruise_control_limit[event.player_index] = -global.cruise_control_limit[event.player_index]
                end
                if verbose then 
                    player.print({"DA-cruise-control-active", mpt_to_kmph(global.cruise_control_limit[event.player_index])})
                end
            else
                global.cruise_control[event.player_index] = false
                if verbose then
                    player.print({"DA-cruise-control-inactive"})
                end
            end
        else
            player.print({"DA-cruise-control-not-allowed"})
        end
    end
end)

-- if the player presses the respective key, this event is fired to toggle the current state of the driving assistant
script.on_event("toggle_drive_assistant", function(event)
    local player = game.players[event.player_index]
    if (technology_required and player.force.technologies["Arci-pavement-drive-assistant"].researched or technology_required == false) and global.mod_compatibility then 
        if (global.drive_assistant[event.player_index] == nil or global.drive_assistant[event.player_index] == false) then 
            -- check if the vehicle is blacklisted
            if player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" and vehicle_blacklist[player.vehicle.name] ~= nil then
                player.print({"DA-vehicle-blacklisted"})
            else
                global.drive_assistant[event.player_index] = true
                if verbose then 
                    player.print({"DA-drive-assistant-active"})
                end
            end
        else
            global.drive_assistant[event.player_index] = false
            if verbose then
                player.print({"DA-drive-assistant-inactive"})
            end
        end
    end
end)

-- adjusts the orientation of the car the player is driving to follow paved tiles
local function manage_drive_assistant(event, index)
    local player = game.players[index]
		if player.riding_state.direction == defines.riding.direction.straight and math.abs(player.vehicle.speed) > minspeed then
			local car = player.vehicle
			local dir = car.orientation
            local newdir = 0
			
			local dirr = dir + lookangle
			local dirl = dir - lookangle
			
			-- scores for straight, right and left (@sillyfly)
			local ss,sr,sl = 0,0,0
			
			local vs = {math.sin(2*math.pi*dir), -math.cos(2*math.pi*dir)}
			local vr = {math.sin(2*math.pi*dirr), -math.cos(2*math.pi*dirr)}
			local vl = {math.sin(2*math.pi*dirl), -math.cos(2*math.pi*dirl)}
			
			local px = player.position['x'] or player.position[1]
			local py = player.position['y'] or player.position[2]
			local sign = (car.speed > 0 and 1) or -1
			
			local sts = {px, py}
			local str = {px + sign*vs[2]*eccent, py - sign*vs[1]*eccent}
			local stl = {px -sign*vs[2]*eccent, py + sign*vs[1]*eccent}
            
            -- linearly increases start and length of the scanned area if the car is very fast
            local lookahead_start_hs = 0 
            local lookahead_length_hs = 0  
                
            if car.speed > highspeed then 
                local speed_factor = car.speed / highspeed
                lookahead_start_hs = math.floor (hs_start_extension * speed_factor + 0.5)
                lookahead_length_hs = math.floor (hs_length_extension * speed_factor + 0.5)
            end
			
            -- calculate scores within the scanning area in front of the vehicle (@sillyfly)
			for i=lookahead_start + lookahead_start_hs,lookahead_start + lookahead_length + lookahead_length_hs do
				local d = i*sign
				local rst = player.surface.get_tile(str[1] + vs[1]*d, str[2] + vs[2]*d).name
				local lst = player.surface.get_tile(stl[1] + vs[1]*d, stl[2] + vs[2]*d).name
				local rt = player.surface.get_tile(px + vr[1]*d, py + vr[2]*d).name
				local lt = player.surface.get_tile(px + vl[1]*d, py + vl[2]*d).name
				
				ss = ss + (((scores[rst] or 0) + (scores[lst] or 0))/2.0)
				sr = sr + (scores[rt] or 0)
				sl = sl + (scores[lt] or 0)
			end
			
			if debug then
				player.print("x:" .. px .. "->" .. px+vs[1]*(lookahead_start + lookahead_length) .. ", y:" .. py .. "->" .. py+vs[2]*(lookahead_start + lookahead_length))
				player.print("S: " .. ss .. " R: " .. sr .. " L: " .. sl)
			end
            
            -- check if the score indicates that the vehicle leaved paved area
            global.last_score[index] = global.last_score[index] or 0
            local ts = ss+sr+sl
            if ts < global.last_score[index] and ts == 0 and not global.emergency_brake_active[index] then
                -- warn the player and activate emergency brake
                if alert then
                    player.surface.create_entity({name = "pda-warning-1", position = player.position})
                elseif verbose then
                    player.print({"DA-road-departure-warning"})                
                end
                player.riding_state = {acceleration = defines.riding.acceleration.braking, direction = player.riding_state.direction}
                global.emergency_brake_active[index] = true                           
            end
			global.last_score[index] = ts
            
            -- set new direction depending on the scores (@sillyfly)
			if sr > ss and sr > sl then
				newdir = dir + (changeangle*sr*2)/(sr+ss)
			elseif sl > ss and sl > sr then
				newdir = dir - (changeangle*sl*2)/(sl+ss)
			else
                newdir = dir
            end
            
			-- Snap car to nearest 1/64 to avoid oscillation (@GotLag)
			car.orientation = math.floor(newdir * 64 + 0.5) / 64		
            
		elseif player.riding_state.direction ~= defines.riding.direction.straight then
            global.last_score[index] = 0
        end
end

-- check if vehicle speed needs to be adjusted (only if cruise control is active)
-- wont do anything if player stands still or is braking
local function manage_cruise_control(event, index)
    local player = game.players[index]
    local speed = player.vehicle.speed
	if speed ~= 0 and player.riding_state.acceleration ~= defines.riding.acceleration.braking then
        if math.abs(speed) > global.cruise_control_limit[index] then
            if speed > 0 then
                player.vehicle.speed = global.cruise_control_limit[index]
            -- check for reverse gear
            else
                player.vehicle.speed = -global.cruise_control_limit[index]
            end
        elseif speed > 0 and speed < global.cruise_control_limit[index] * minspeed_tolerance then
            player.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = player.riding_state.direction}
        end
    end
end

script.on_init(function(data)
-- on game start 
    init_global()    
    if global.mod_compatibility == false then
        incompability_detected()
    end
    -- if no tech is needed, disable the tech for all forces
    for k, f in pairs (game.forces) do
        f.technologies["Arci-pavement-drive-assistant"].enabled = technology_required
    end
end)

script.on_event(defines.events.on_tick, function(event)
-- Main routine (remember the api and the "no heavy code in the on_tick event" advice? ^^) 
-- Proceed only if there aren't any incompatible mods
    if global.mod_compatibility ~= nil and global.mod_compatibility == true then
        -- Process every n-th player in vehicles (n = driving_assistant_tickrate)
        -- Exception: Process "cruise control" every tick to gain maximum acceleration
        if global.playertick < driving_assistant_tickrate then 
            global.playertick = global.playertick + 1
        else 
            global.playertick = 1
        end
        for i=1, #global.players_in_vehicles, 1 do
            local p = global.players_in_vehicles[i]
            if hard_speed_limit > 0 then
            -- check if a vehicle is faster than the global speed limit
                local speed = game.players[p].vehicle.speed
                if speed > 0 and speed > hard_speed_limit then
                    game.players[p].vehicle.speed = hard_speed_limit
                elseif speed < 0 and speed < -hard_speed_limit then
                -- reverse
                    game.players[p].vehicle.speed = -hard_speed_limit
                end
            end
            -- check if emergency brake is active
            if global.emergency_brake_active[p] then
                if game.players[p].riding_state.acceleration == (defines.riding.acceleration.accelerating) or game.players[p].vehicle.speed == 0 then
                    global.emergency_brake_active[p] = false
                else 
                    game.players[p].riding_state = {acceleration = defines.riding.acceleration.braking, direction = game.players[p].riding_state.direction}
                end
            elseif cruise_control_allowed and global.cruise_control[p] then 
                manage_cruise_control(event, p)
            end
        end
        -- process driving assistant
        for i=global.playertick, #global.players_in_vehicles, driving_assistant_tickrate do
            if #global.players_in_vehicles >= i and global.drive_assistant[global.players_in_vehicles[i]] then
                manage_drive_assistant(event, global.players_in_vehicles[i])
            end
        end        
    elseif global.mod_compatibility == nil then 
        global.mod_compatibility = check_compatibility()
        if global.mod_compatibility == false then
            incompability_detected()            
        end
    end
end)

