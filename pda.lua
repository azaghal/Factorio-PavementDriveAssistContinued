-- Copyright (2017) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly. 
-- Provided under MIT license. See license.txt for details. 
-- This is the main logic script. For configuration options see config.lua.

require "math"
require "modgui"
require "config"

pda = {}

local function notification(txt, force)
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
    global.players_in_vehicles = global.players_in_vehicles or {}
    global.offline_players_in_vehicles = global.offline_players_in_vehicles or {}
    global.playertick = global.playertick or 0
    global.mod_compatibility = nil
    global.last_score = global.last_score or {}
    --global.last_scan = global.last_scan or {{},{}}
    global.emergency_brake_active = global.emergency_brake_active or {}
end

-- fired if a player enters or leaves a vehicle
function pda.on_player_driving_changed_state(event)
    local player = game.players[event.player_index]
    -- put player at last position in list of players in vehicles
    -- only allow certain vehicles (i.e. no trains)
    if (player.vehicle ~= nil) and player.vehicle.valid and player.vehicle.type == "car" and vehicle_blacklist[player.vehicle.name] == nil then 
        -- insert player (or multiple instances of the same player, if benchmark_level > 1) in list
        for i = 1, benchmark_level do
            table.insert(global.players_in_vehicles, player.index)
        end
    else
        -- remove player from list. 
        for i=#global.players_in_vehicles, 1, -1 do
            if global.players_in_vehicles[i] == player.index then
                -- reset emergency brake state and scores (i.e. if the vehicle got destroyed, its no longer necessary)
                global.emergency_brake_active[player.index] = false
                global.last_score[player.index] = 0
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
end

-- some (including this) mod was modified, added or removed from the game  
function pda.on_configuration_changed(data)
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
end

-- converts Factorios meter per tick to floored integer kilometer per hour (used for GUI interaction)
local function mpt_to_kmph(mpt)
    return math.floor(mpt * 60 * 60 * 60 / 1000 + 0.5)
end

local function kmph_to_mpt(kmph)
    return ((kmph * 1000) / 60 / 60 / 60)
end

-- if the player presses the respective key, this event is fired to toggle the current state of cruise control
function pda.toggle_cruise_control(event)
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
end

-- if the player presses the respective key, this event is fired to show/set the current cruise control limit
function pda.set_cruise_control_limit(event)
    local player = game.players[event.player_index]
    if (technology_required and player.force.technologies["Arci-pavement-drive-assistant"].researched or technology_required == false) and global.mod_compatibility then
        if cruise_control_allowed then
            -- open the gui if its not already open, otherwise close it
            if not player.gui.center.pda_cc_limit_gui_frame then
                modgui.create_cc_limit_gui(player)
                -- if cruise control is active, load the current limit
                if global.cruise_control[player.index] == true then
                    player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text = mpt_to_kmph(global.cruise_control_limit[player.index])
                else
                    player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text = ""
                end
            else
                player.gui.center.pda_cc_limit_gui_frame.destroy()
            end
        end
    end
end

-- handle gui interaction
function pda.on_gui_click(event)
    local player = game.players[event.player_index]    
    if event.element.name == "pda_cc_limit_gui_close" then
        player.gui.center.pda_cc_limit_gui_frame.destroy()
    elseif event.element.name == "pda_cc_limit_gui_confirm" then
        -- check if input is a valid number
        if tonumber(player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text) ~= nil then        
            global.cruise_control_limit[player.index] = kmph_to_mpt(player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text)
            -- check for negative values
            if global.cruise_control_limit[player.index] < 0 then
                global.cruise_control_limit[player.index] = -global.cruise_control_limit[player.index]
            end
            -- set value to max speed limit, if active
            if (hard_speed_limit > 0) and (global.cruise_control_limit[player.index] > hard_speed_limit) then
                global.cruise_control_limit[player.index] = hard_speed_limit
            elseif global.cruise_control_limit[player.index] > (299792458 / 60) then 
                -- FTL travel on planetary surfaces should be avoided:
                global.cruise_control_limit[player.index] = 299792458 / 60
            end
            global.cruise_control[player.index] = true
            if verbose then 
                player.print({"DA-cruise-control-active", mpt_to_kmph(global.cruise_control_limit[player.index])})
            end
        end
        player.gui.center.pda_cc_limit_gui_frame.destroy()
    end
end

-- if the player presses the respective key, this event is fired to toggle the current state of the driving assistant
function pda.toggle_drive_assistant(event)
    local player = game.players[event.player_index]
    local drvassist = global.drive_assistant[player.index]
    if (technology_required and player.force.technologies["Arci-pavement-drive-assistant"].researched or technology_required == false) and global.mod_compatibility then 
        if (drvassist == nil or drvassist == false) then 
            -- check if the vehicle is blacklisted
            if player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" then
                if vehicle_blacklist[player.vehicle.name] ~= nil then
                    player.print({"DA-vehicle-blacklisted"})
                else
                    drvassist = true
                    if verbose then 
                        player.print({"DA-drive-assistant-active"})
                    end
                end
            end
        else
            drvassist = false
            if verbose then
                player.print({"DA-drive-assistant-inactive"})
            end
        end
        global.drive_assistant[player.index] = drvassist
    end    
end

-- adjusts the orientation of the car the player is driving to follow paved tiles
local function manage_drive_assistant(index)
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
			
        --local last_scan = global.last_scan[player.index]
        --local new_scan = {{},{}}
        -- calculate scores within the scanning area in front of the vehicle (@sillyfly)
        -- commented out areas: Intended to cache scanned tiles to avoid multiple scans. Downside: This is apparently 5%-10% slower than accessing the raw tile data on each tick. 
        for i=lookahead_start + lookahead_start_hs,lookahead_start + lookahead_length + lookahead_length_hs do
			local d = i*sign
            local rstx = str[1] + vs[1]*d
            local rsty = str[2] + vs[2]*d
            local lstx = stl[1] + vs[1]*d
            local lsty = stl[2] + vs[2]*d
            local rtx = px + vr[1]*d
            local rty = py + vr[2]*d
            local ltx = px + vl[1]*d
            local lty = py + vl[2]*d                     
			local rst = --[[(last_scan ~= nil and last_scan[rstx] ~= nil and last_scan[rstx][rsty]) or]] scores[player.surface.get_tile(rstx, rsty).name]
			local lst = --[[(last_scan ~= nil and last_scan[lstx] ~= nil and last_scan[lstx][lsty]) or]] scores[player.surface.get_tile(lstx, lsty).name]
			local rt = --[[(last_scan ~= nil and last_scan[rtx] ~= nil and last_scan[rtx][rty]) or]] scores[player.surface.get_tile(rtx, rty).name]
			local lt = --[[(last_scan ~= nil and last_scan[ltx] ~= nil and last_scan[ltx][lty]) or]] scores[player.surface.get_tile(ltx, lty).name]
            
            ss = ss + (((rst or 0) + (lst or 0))/2.0)
			sr = sr + (rt or 0)
			sl = sl + (lt or 0)
            
            --[[
            new_scan[rstx] = (new_scan ~= nil and new_scan[rstx]) or {}
            new_scan[rstx][rsty] = rst
            new_scan[lstx] = (new_scan ~= nil and new_scan[lstx]) or {}
            new_scan[lstx][lsty] = lst
            new_scan[rtx] = (new_scan ~= nil and new_scan[rtx]) or {}
            new_scan[rtx][rty] = rt
            new_scan[ltx] = (new_scan ~= nil and new_scan[ltx]) or {}
            new_scan[ltx][lty] = lt
            ]]
 		end
        --global.last_scan[player.index] = new_scan
		if debug then
			player.print("x:" .. px .. "->" .. px+vs[1]*(lookahead_start + lookahead_length) .. ", y:" .. py .. "->" .. py+vs[2]*(lookahead_start + lookahead_length))
			player.print("S: " .. ss .. " R: " .. sr .. " L: " .. sl)
		end
            
        -- check if the score indicates that the vehicle leaved paved area
        local ls = global.last_score[index] or 0
        local ts = ss+sr+sl
        
        if ts < ls and ts == 0 and not global.emergency_brake_active[index] then
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
local function manage_cruise_control(index)
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

function pda.on_init(data)
--script.on_init(function(data)
-- on game start 
    init_global()    
    if global.mod_compatibility == false then
        incompability_detected()
    end
    -- if no tech is needed, disable the tech for all forces
    for k, f in pairs (game.forces) do
        f.technologies["Arci-pavement-drive-assistant"].enabled = technology_required
    end
end

function pda.on_player_joined_game(event)
--script.on_event(defines.events.on_player_joined_game, function(event)
-- joining players that drove vehicles while leaving the game are in the "offline_players_in_vehicles" list and will be put back to normal
    local p = event.player_index
    if debug then 
        notification(tostring("on-joined triggered by player "..p)) 
        notification(tostring("connected players: "..#game.connected_players))
        notification(tostring("players in offline_mode: "..#global.offline_players_in_vehicles))
    end
    if global.offline_players_in_vehicles == nil then
        global.offline_players_in_vehicles = {}
    end
    -- safety check (important for first player connecting to a game)
    -- if players are still in the "players_in_vehicles" list despite the fact they are not online then they will be put in offline mode
    if #game.connected_players == 1 then
        for i=#global.players_in_vehicles, 1, -1 do
            local offline = true
            for j=1, #game.connected_players, 1 do
                if global.players_in_vehicles[i] == game.connected_players[j].index then
                    offline = false
                end
            end
            if offline then
                table.insert(global.offline_players_in_vehicles, global.players_in_vehicles[i])
                table.remove(global.players_in_vehicles, i)                
            end
        end
    end
    -- set player back to normal
    for i=#global.offline_players_in_vehicles, 1, -1 do
        if debug then notification(tostring(i..". test - is offline player "..global.offline_players_in_vehicles[i].." now online player: "..p.." ?")) end
        if global.offline_players_in_vehicles[i] == p then
            table.insert(global.players_in_vehicles, p)
            table.remove(global.offline_players_in_vehicles, i)
        end    
    end
    if debug then notification(tostring("num players now in offline_mode: "..#global.offline_players_in_vehicles)) end
end

function pda.on_player_left_game(event)
--script.on_event(defines.events.on_player_left_game, function(event)
-- puts leaving players currently driving a vehicle in the "offline_players_in_vehicles" list
    local p = event.player_index
    if debug then notification(tostring("on-left triggered by player "..p)) end
    for i=#global.players_in_vehicles, 1, -1 do
        if global.players_in_vehicles[i] == p then
            table.insert(global.offline_players_in_vehicles, p)
            table.remove(global.players_in_vehicles, i)
        end
    end
end

function pda.on_tick(event)
--script.on_event(defines.events.on_tick, function(event)
-- Main routine (remember the api and the "no heavy code in the on_tick event" advice? ^^) 
-- Proceed only if there aren't any incompatible mods
    if global.mod_compatibility ~= nil and global.mod_compatibility == true then
        -- Process every n-th player in vehicles (n = driving_assistant_tickrate)
        -- Exception: Process "cruise control" every tick to gain maximum acceleration
        local ptick = global.playertick
        local pinvec = #global.players_in_vehicles
        
        if ptick < driving_assistant_tickrate then 
            ptick = ptick + 1
        else 
            ptick = 1
        end           
        -- process cruise control, check for hard_speed_limit and emergency_brake_active (every tick)
        for i=1, pinvec, 1 do
            local p = global.players_in_vehicles[i]
            -- if vehicle == nil don't process the player (i.e. if the character bound to the player changed)
            if game.players[p].vehicle == nil then
                return
            end
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
                manage_cruise_control(p)
            end
        end
        -- process driving assistant (every "driving_assistant_tickrate" ticks)
        for i=ptick, pinvec, driving_assistant_tickrate do
            -- if vehicle == nil don't process the player
            if game.players[global.players_in_vehicles[i]].vehicle == nil then
                return
            end
            if (pinvec >= i) and global.drive_assistant[global.players_in_vehicles[i]] then
                manage_drive_assistant(global.players_in_vehicles[i])
            end
        end
        global.playertick = ptick
    elseif global.mod_compatibility == nil then 
        global.mod_compatibility = check_compatibility()
        if global.mod_compatibility == false then
            incompability_detected()            
        end
    end
end