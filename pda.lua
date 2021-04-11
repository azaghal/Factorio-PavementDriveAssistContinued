-- Copyright (2019) Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly. 
-- Provided under MIT license. See license.txt for details. 

require "modgui"
require "config"

pda = {}

-- used to output texts to whole forces or all players
local function notification(txt, force)
    if force ~= nil then
        force.print(txt)
    else
        for k, p in pairs (game.players) do
            game.players[k].print(txt)
        end
    end
end

--[[ currently not necessary
local function check_compatibility()
-- check if any of the present mods matches a mod in the incompatibility list
    for mod, version in pairs(game.active_mods) do
        if mod_incompatibility_list[mod] then 
            return false
        end
    end
    return true
end]]

--[[ currently not necessary
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
]]

-- converts Factorios meter per tick to floored integer kilometer per hour (used for GUI interaction)
local function mpt_to_kmph(mpt)
    return math.floor(mpt * 60 * 60 * 60 / 1000 + 0.5)
end

local function kmph_to_mpt(kmph)
    return ((kmph * 1000) / 60 / 60 / 60)
end

-- get or init persistent vars
local function init_global()
    global = global or {}
    global.drive_assistant = global.drive_assistant or {}
    global.cruise_control = global.cruise_control or {}
    global.cruise_control_limit = global.cruise_control_limit or {}
    global.imposed_speed_limit = global.imposed_speed_limit or {}
    global.players_in_vehicles = global.players_in_vehicles or {}
    global.offline_players_in_vehicles = global.offline_players_in_vehicles or {}
    global.playertick = global.playertick or 0
    --global.mod_compatibility = nil --currently not necessary
    global.last_score = global.last_score or {}
    --global.last_scan = global.last_scan or {{},{}}
    global.emergency_brake_active = global.emergency_brake_active or {}
    global.cruise_control_brake_active = global.cruise_control_brake_active or {}
    global.min_speed = global.min_speed or kmph_to_mpt(settings.global["PDA-setting-assist-min-speed"].value) or 0.1
    global.hard_speed_limit = global.hard_speed_limit or kmph_to_mpt(settings.global["PDA-setting-game-max-speed"].value) or 0
    global.highspeed = global.highspeed or kmph_to_mpt(settings.global["PDA-setting-assist-high-speed"].value) or 0.5
    global.driving_assistant_tickrate = global.driving_assistant_tickrate or settings.global["PDA-setting-tick-rate"].value or 2
	global.scores = config.get_scores()
end

-- fired if a player enters or leaves a vehicle
function pda.on_player_driving_changed_state(event)
	--log(serpent.block(global, {maxlevel= 4}))
    -- local player = game.players[event.player_index]
    -- if player.vehicle ~= nil and player.vehicle.valid and    player.vehicle.get_driver() == player then
	local p_id = event.player_index
    local player = game.players[p_id]
    if player ~= nil then
		local car = player.vehicle
        -- put player at last position in list of players in vehicles
        -- conditions: 
        -- 1: the event was triggerd by a real player
        -- 2: the player is within a vehicle
        -- 3: the vehicle is a valid entity
        -- 4: the entered vehicle is of type "car"
        -- 5: the player ist the driver of the vehicle (the return value of "get_driver()" is double checked for type "LuaEntity" and type "LuaPlayer" respectively)
        if car ~= nil and car.valid and car.type == "car" and vehicle_blacklist[car.name] == nil then
		-- if the player entered a valid car...
			local driver = car.get_driver()
			if driver ~= nil and (driver == player or driver.player == player) then
			-- ... and entered as the driver not as a passenger ...
				for i = 1, benchmark_level do
				-- ... then insert player (or multiple instances of the same player, if benchmark_level > 1) in list
					table.insert(global.players_in_vehicles, p_id)
					player.set_shortcut_available("pda-cruise-control-toggle", true)
					player.set_shortcut_available("pda-drive-assistant-toggle", true)
				end
			end
		else
			-- remove player from list. 
			for i=#global.players_in_vehicles, 1, -1 do
				if global.players_in_vehicles[i] == p_id then
					-- reset emergency brake state, imposed speed limit and scores (e.g. if the vehicle got destroyed, its no longer necessary)
					global.emergency_brake_active[p_id] = false
					global.imposed_speed_limit[p_id] = nil
					global.last_score[p_id] = 0
					table.remove(global.players_in_vehicles, i)           
					player.set_shortcut_available("pda-cruise-control-toggle", false)
					player.set_shortcut_available("pda-drive-assistant-toggle", false)					
				end
			end
			-- reset emergency brake
			global.emergency_brake_active[p_id] = false
		end		
		
        if #global.players_in_vehicles > 0 then
            if debug then
                for i=1, #global.players_in_vehicles, 1 do
                    notification(tostring(i..".: Player index"..global.players_in_vehicles[i].." ("..game.players[global.players_in_vehicles[i]].name..")"))
                end
            end
        else
            if debug then
                notification("List empty.")
            end
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
        -- 2.1.2 update
        for index, force in pairs(game.forces) do
            local technologies = force.technologies
            local recipes = force.recipes
            technologies["Arci-pavement-drive-assistant"].reload()
            recipes["pda-road-sign-speed-limit"].reload()
            recipes["pda-road-sign-speed-unlimit"].reload()
            if technologies["Arci-pavement-drive-assistant"].researched then
                recipes["pda-road-sign-speed-limit"].enabled = true
                recipes["pda-road-sign-speed-unlimit"].enabled = true
            end
        end
    elseif data.mod_changes ~= nil then
        -- some other mod was added, removed or modified. Check, if this mod is or was incompatible with PDA
        --currently not necessary
        --[[global.mod_compatibility = check_compatibility()
        if global.mod_compatibility == false then
            incompability_detected()
        end
        ]]
    end
end

-- if the player presses the respective key, this event is fired to toggle the current state of cruise control
function pda.toggle_cruise_control(event)
    local player = game.players[event.player_index]
    if (settings.global["PDA-setting-tech-required"].value and player.force.technologies["Arci-pavement-drive-assistant"].researched or settings.global["PDA-setting-tech-required"].value == false) and player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" and vehicle_blacklist[player.vehicle.name] == nil --[[and global.mod_compatibility]] then
        if settings.global["PDA-setting-allow-cruise-control"].value then
            if (global.cruise_control[event.player_index] == nil or global.cruise_control[event.player_index] == false) then
                global.cruise_control[event.player_index] = true
				player.set_shortcut_toggled("pda-cruise-control-toggle", true)
                -- set cruise control speed limit, but do not, if alt toggle mode active
                if global.cruise_control_limit[event.player_index] == nil or player.mod_settings["PDA-setting-alt-toggle-mode"].value == false then
                    global.cruise_control_limit[event.player_index] = player.vehicle.speed                    
                    -- check for reverse gear
                    if player.vehicle.speed < 0 then
                        global.cruise_control_limit[event.player_index] = -global.cruise_control_limit[event.player_index]
                    end
                else
                    -- slow down the vehicle if the current speed is greater than the cc limit
                    if player.vehicle.speed > global.cruise_control_limit[event.player_index] then
                        global.cruise_control_brake_active[event.player_index] = true
                    end
                end
                if player.mod_settings["PDA-setting-verbose"].value then 
                    player.print({"DA-cruise-control-active", mpt_to_kmph(global.cruise_control_limit[event.player_index])})
                end                
            else
                global.cruise_control[event.player_index] = false
				player.set_shortcut_toggled("pda-cruise-control-toggle", false)
                global.cruise_control_brake_active[event.player_index] = false 
                -- discard the imposed speed limit
                global.imposed_speed_limit[player.index] = nil
                -- reset riding_state to stop acceleration
                game.players[event.player_index].riding_state = {acceleration = defines.riding.acceleration.nothing, direction = game.players[event.player_index].riding_state.direction}
                if player.mod_settings["PDA-setting-verbose"].value then
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
    if (settings.global["PDA-setting-tech-required"].value and player.force.technologies["Arci-pavement-drive-assistant"].researched or settings.global["PDA-setting-tech-required"].value == false) --[[and global.mod_compatibility]] then
        if settings.global["PDA-setting-allow-cruise-control"].value then
            -- open the gui if its not already open, otherwise close it
            if not player.gui.center.pda_cc_limit_gui_frame then
                modgui.create_cc_limit_gui(player)
                -- if cruise control is active, load the current limit
                if global.cruise_control[player.index] == true then
                    player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text = mpt_to_kmph(global.cruise_control_limit[player.index])
                else
                    player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text = ""
                end
				player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.select_all()
				player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.focus()
            else
                player.gui.center.pda_cc_limit_gui_frame.destroy()
            end
        end
    end
end

-- set a new value for cruise control
function pda.set_new_value_for_cruise_control_limit(event)
	local player = game.players[event.player_index]    
    local hard_speed_limit = global.hard_speed_limit
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
		player.set_shortcut_toggled("pda-cruise-control-toggle", true)
		-- check, if the player is sitting in a vehicle and changed the cc limit below the velocity of the car
		if player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" and vehicle_blacklist[player.vehicle.name] == nil and player.vehicle.speed > global.cruise_control_limit[event.player_index] then
			global.cruise_control_brake_active[event.player_index] = true
		end
		if player.mod_settings["PDA-setting-verbose"].value then 
			player.print({"DA-cruise-control-active", mpt_to_kmph(global.cruise_control_limit[player.index])})
		end
	end
end

-- handle gui interaction: player pressed "Return"-key
function pda.set_cruise_control_limit_ok(event)
	local player = game.players[event.player_index]  
	if player.gui.center.pda_cc_limit_gui_frame then
		pda.set_new_value_for_cruise_control_limit(event)
		player.gui.center.pda_cc_limit_gui_frame.destroy()
	end
end

-- handle gui interaction: player clicked on a button
function pda.on_gui_click(event)
    local player = game.players[event.player_index]    
	if player.gui.center.pda_cc_limit_gui_frame then
		if event.element.name == "pda_cc_limit_gui_close" then
			player.gui.center.pda_cc_limit_gui_frame.destroy()
		elseif event.element.name == "pda_cc_limit_gui_confirm" then
			pda.set_new_value_for_cruise_control_limit(event)
			player.gui.center.pda_cc_limit_gui_frame.destroy()
		end
	end
end

-- shortcuts
function pda.on_lua_shortcut(event)
	local shortcut = event.prototype_name
	if shortcut == "pda-cruise-control-toggle" then
		pda.toggle_cruise_control(event)
	elseif shortcut == "pda-drive-assistant-toggle" then
		pda.toggle_drive_assistant(event)
	elseif shortcut == "pda-set-cruise-control-limit" then
		pda.set_cruise_control_limit(event)
	end
end

-- if the player presses the respective key, this event is fired to toggle the current state of the driving assistant
function pda.toggle_drive_assistant(event)
    local player = game.players[event.player_index]
    local drvassist = global.drive_assistant[player.index]
    if (settings.global["PDA-setting-tech-required"].value and player.force.technologies["Arci-pavement-drive-assistant"].researched or settings.global["PDA-setting-tech-required"].value == false) --[[and global.mod_compatibility]] then 
        if (drvassist == nil or drvassist == false) then 
            -- check if the vehicle is blacklisted
            if player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" then
                if vehicle_blacklist[player.vehicle.name] ~= nil then
                    player.print({"DA-vehicle-blacklisted"})
                else
                    drvassist = true

					player.set_shortcut_toggled("pda-drive-assistant-toggle", true)
                    if player.mod_settings["PDA-setting-verbose"].value then 
                        player.print({"DA-drive-assistant-active"})
                    end
                end
            end
        else
            drvassist = false
			global.emergency_brake_active[player.index] = false
			global.last_score[player.index] = 0
			player.set_shortcut_toggled("pda-drive-assistant-toggle", false)
            if player.mod_settings["PDA-setting-verbose"].value then
                player.print({"DA-drive-assistant-inactive"})
            end
        end
        global.drive_assistant[player.index] = drvassist
    end    
end

-- adjusts the orientation of the car the player is driving to follow paved tiles
local function manage_drive_assistant(index)
    local player = game.players[index]
	
	if player.riding_state.direction == defines.riding.direction.straight and (global.imposed_speed_limit[index] ~= nil or math.abs(player.vehicle.speed) > global.min_speed) then
		local car = player.vehicle
		local dir = car.orientation
		local scores = global.scores
        local newdir = 0
		local pi = math.pi
		local fsin = math.sin
		local fcos = math.cos
		local mfloor = math.floor
		
		local dirr = dir + lookangle
		local dirl = dir - lookangle
		
		-- scores for straight, right and left (@sillyfly)
		local ss,sr,sl = 0,0,0
		local vs = {fsin(2*pi*dir), -fcos(2*pi*dir)}
		local vr = {fsin(2*pi*dirr), -fcos(2*pi*dirr)}
		local vl = {fsin(2*pi*dirl), -fcos(2*pi*dirl)}
		
		local px = player.position['x'] or player.position[1]
		local py = player.position['y'] or player.position[2]
		local sign = (car.speed > 0 and 1) or -1
		
		local sts = {px, py}
		local str = {px + sign*vs[2]*eccent, py - sign*vs[1]*eccent}
		local stl = {px -sign*vs[2]*eccent, py + sign*vs[1]*eccent}
        
        -- linearly increases start and length of the scanned area if the car is very fast
        local lookahead_start_hs = 0 
        local lookahead_length_hs = 0  
        
        if car.speed > global.highspeed then 
            local speed_factor = car.speed / global.highspeed
            lookahead_start_hs = mfloor (hs_start_extension * speed_factor + 0.5)
            lookahead_length_hs = mfloor (hs_length_extension * speed_factor + 0.5)
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
		--[[if debug then
			player.print("x:" .. px .. "->" .. px+vs[1]*(lookahead_start + lookahead_length) .. ", y:" .. py .. "->" .. py+vs[2]*(lookahead_start + lookahead_length))
			player.print("S: " .. ss .. " R: " .. sr .. " L: " .. sl)
		end]]
            
        -- check if the score indicates that the vehicle leaved paved area
        local ls = global.last_score[index] or 0
        local ts = ss+sr+sl
        
        if ts < ls and ts == 0 and not global.emergency_brake_active[index] then
            -- warn the player and activate emergency brake
            if player.mod_settings["PDA-setting-sound-alert"].value then
                player.surface.create_entity({name = "pda-warning-1", position = player.position})
            elseif player.mod_settings["PDA-setting-verbose"].value then
                player.print({"DA-road-departure-warning"})                
            end
            player.riding_state = {acceleration = defines.riding.acceleration.braking, direction = player.riding_state.direction}
            global.emergency_brake_active[index] = true                           
        end
		global.last_score[index] = ts
        
        -- set new direction depending on the scores (@sillyfly)
		if sr > ss and sr > sl and (sr + ss) > 0 then
			newdir = dir + (changeangle*sr*2)/(sr+ss)
		elseif sl > ss and sl > sr and (sl + ss) > 0 then
			newdir = dir - (changeangle*sl*2)/(sl+ss)
		else
           newdir = dir
        end
            
        -- Snap car to nearest 1/64 to avoid oscillation (@GotLag)
		--car.orientation = newdir	
		car.orientation = mfloor(newdir * 64 + 0.5) / 64		
            
        -- no score reset in curves -> allow the player to guide his vehicle off road manually
	elseif player.riding_state.direction ~= defines.riding.direction.straight then
        global.last_score[index] = 0
    end
end

-- check if vehicle speed needs to be adjusted (only if cruise control is active)
-- wont do anything if player stands still or is braking
local function manage_cruise_control(index)
    local player = game.players[index]
	local px = player.position['x'] or player.position[1]
	local py = player.position['y'] or player.position[2]
	local car = player.vehicle
    local speed = player.vehicle.speed
    local target_speed = 0
	
	-- sign detection
	if global.cruise_control[index] then
		local sign_scanner = game.surfaces[player.surface.index].find_entities_filtered{area = {{px-1, py-1},{px+1, py+1}}, type="constant-combinator"}
		if #sign_scanner > 0 then
			--local sign_scanner = game.surfaces[player.surface.index].find_entities_filtered{area = {{px-1, py-1},{px+1, py+1}}, type="constant-combinator"}             
			for i = 1, #sign_scanner do
				-- speed limit sign
				if sign_scanner[i].name == "pda-road-sign-speed-limit" then                    
					local sign = sign_scanner[i].get_or_create_control_behavior()
					local network = nil
					local sign_value = 0
					-- wire priority: red wire > green wire > not connected
					-- signal priority: lexicographic order (0,1,2,...,9,A,B,C,... ,Y,Z)
					-- the signal of the sign itself is part of its circuit networks! Additional signals of the same type on this networks will be cummulated (e.g. a "L=60" on the sign and a signal "L=30" on the red network will add up to "L=90")
					local network_red = sign.get_circuit_network(defines.wire_type.red)
					local network_green = sign.get_circuit_network(defines.wire_type.green)
					-- 1st: check if a red wire is connected (with >=1 signals, including the one of the sign itself)
					if network_red ~= nil and network_red.signals ~= nil and #network_red.signals > 0 then
						local networksignal = network_red.signals[1]   
						if networksignal.signal ~= nil then sign_value = networksignal.count end
					-- 2nd: if there is no res wire, check if a green wire is connected (with >=1 signals, including the one of the sign itself)
					elseif network_green ~= nil and network_green.signals ~= nil and #network_green.signals > 0 then
						local networksignal = network_green.signals[1]   
						if networksignal.signal ~= nil then sign_value = networksignal.count end
					-- 3rd: if the sign is not connected to any circuit network, read its own signal
					elseif sign.get_signal(1).signal ~= nil then
						local localsignal = sign.get_signal(1)
						if localsignal.signal ~= nil then sign_value = localsignal.count end
					end
					-- read signal value only if a signal is set       
					if --[[(sign_value ~= nil) and]] sign_value ~= 0 then
						global.imposed_speed_limit[index] = kmph_to_mpt(sign_value)
						if car.speed > global.imposed_speed_limit[index] then
							-- activate brake to deccelerate the vehicle
							global.cruise_control_brake_active[index] = true
						end
					end
					return
				-- unlimit sign
				elseif sign_scanner[i].name == "pda-road-sign-speed-unlimit" then
					global.imposed_speed_limit[index] = nil
					return
				end
			end
		end
	end
	
    -- check if there is a speed limit that is more restrictive than the set limit for cruise control
    if global.imposed_speed_limit[index] ~= nil and (global.imposed_speed_limit[index] < global.cruise_control_limit[index]) then
        target_speed = global.imposed_speed_limit[index]
    else    
        target_speed = global.cruise_control_limit[index]
    end
	if speed ~= 0 and player.riding_state.acceleration ~= defines.riding.acceleration.braking then
        if math.abs(speed) > target_speed then
            player.riding_state = {acceleration = defines.riding.acceleration.nothing, direction = player.riding_state.direction}
            if speed > 0 then
                player.vehicle.speed = target_speed
            -- check for reverse gear
            else
                player.vehicle.speed = -target_speed
            end
        elseif speed > 0 and speed < target_speed then
            player.riding_state = {acceleration = defines.riding.acceleration.accelerating, direction = player.riding_state.direction}
        end
    end
end

-- on game start 
function pda.on_init(data)
    init_global()    
    --[[if global.mod_compatibility == false then
        incompability_detected()
    end]]
    -- if no tech is needed, disable the tech for all forces
    for k, f in pairs (game.forces) do
        f.technologies["Arci-pavement-drive-assistant"].enabled = settings.global["PDA-setting-tech-required"].value
    end
end

-- joining players that drove vehicles while leaving the game are in the "offline_players_in_vehicles" list and will be put back to normal
function pda.on_player_joined_game(event)
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

-- puts leaving players currently driving a vehicle in the "offline_players_in_vehicles" list
function pda.on_player_left_game(event)
   local p = event.player_index
    if debug then notification(tostring("on-left triggered by player "..p)) end
    for i=#global.players_in_vehicles, 1, -1 do
        if global.players_in_vehicles[i] == p then
            table.insert(global.offline_players_in_vehicles, p)
            table.remove(global.players_in_vehicles, i)
        end
    end
end

-- adjust global variables if mod settings have been changed
function pda.on_settings_changed(event)
    local p = event.player_index
    local s = event.setting
    if event.setting_type == "runtime-global" then
        if s == "PDA-setting-assist-min-speed" then 
            global.min_speed = kmph_to_mpt(settings.global["PDA-setting-assist-min-speed"].value) 
        end
        if s == "PDA-setting-game-max-speed" then 
            global.hard_speed_limit = kmph_to_mpt(settings.global["PDA-setting-game-max-speed"].value) 
        end
        if s == "PDA-setting-assist-high-speed" then 
            global.highspeed = kmph_to_mpt(settings.global["PDA-setting-assist-high-speed"].value) 
        end
        if s == "PDA-setting-tick-rate" then 
            global.driving_assistant_tickrate = settings.global["PDA-setting-tick-rate"].value 
        end
		if string.sub(s, 1, 11) == "PDA-tileset" then
			global.scores = config.update_scores()
		end
    end
end

-- put default signals into new speed limit signs and disable unlimit signs on placement
function pda.on_placed_sign(event)
    local p = event.player_index
    local e = event.created_entity
    if e ~= nil and e.valid and e.type == "constant-combinator" then
        if e.name == "pda-road-sign-speed-unlimit" then
            e.operable = false
            e.get_control_behavior().enabled = false
        elseif e.name == "pda-road-sign-speed-limit" then
            -- on placement: if the sign had no specified signal value, set it to the default value.
            if e.get_or_create_control_behavior().get_signal(1).signal == nil then
                -- if placed by robots, use map setting, otherwise use personal setting
                local limit = settings.global["PDA-setting-server-limit-sign-speed"].value
                if p ~= nil then
                    limit = game.players[p].mod_settings["PDA-setting-personal-limit-sign-speed"].value
                end
                e.get_or_create_control_behavior().parameters = {parameters={{index = 1, count = limit, signal = {type="virtual", name="signal-L"}}}}
            end
        end
    end
end

function pda.on_tick(event)
-- Main routine (remember the api and the "no heavy code in the on_tick event" advice? ^^) 
    -- Process every n-th player in vehicles (n = driving_assistant_tickrate)
    -- Exception: Process "cruise control" every tick to gain maximum acceleration
    local ptick = global.playertick
    local pinvec = #global.players_in_vehicles

    -- compatibility for 2.1.1
    if global.imposed_speed_limit == nil then global.imposed_speed_limit = {} end
    
    if ptick < global.driving_assistant_tickrate then 
        ptick = ptick + 1
    else 
        ptick = 1
    end         
    
    -- process cruise control, check for hard_speed_limit and emergency_brake_active (every tick)
    for i=1, pinvec, 1 do
        local hard_speed_limit = global.hard_speed_limit
        local p = global.players_in_vehicles[i]
        local player = game.players[p]
        local car = game.players[p].vehicle
        -- if vehicle == nil don't process the player (i.e. if the character bound to the player changed)
        if car == nil or not car.valid then
            return
        end
        if hard_speed_limit > 0 then
        -- check if a vehicle is faster than the global speed limit
            local speed = car.speed
            if speed > 0 and speed > hard_speed_limit then
                game.players[p].vehicle.speed = hard_speed_limit
            elseif speed < 0 and speed < -hard_speed_limit then
            -- reverse
                car.speed = -hard_speed_limit
            end
        end
        -- check if forced braking is active...
        if global.emergency_brake_active[p] then
            if player.riding_state.acceleration == (defines.riding.acceleration.accelerating) or car.speed == 0 then
                global.emergency_brake_active[p] = false
                player.riding_state = {acceleration = defines.riding.acceleration.nothing, direction = player.riding_state.direction}
            else 
                player.riding_state = {acceleration = defines.riding.acceleration.braking, direction = player.riding_state.direction}
            end
        elseif global.cruise_control_brake_active[p] then
            if (car.speed < global.cruise_control_limit[p]) and global.imposed_speed_limit[p] == nil or (global.imposed_speed_limit[p] ~= nil and car.speed < global.imposed_speed_limit[p]) then
                global.cruise_control_brake_active[p] = false
                player.riding_state = {acceleration = defines.riding.acceleration.nothing, direction = player.riding_state.direction}
            else 
                player.riding_state = {acceleration = defines.riding.acceleration.braking, direction = player.riding_state.direction}
            end
        -- ...otherwise proceed to handle cruise control
        elseif settings.global["PDA-setting-allow-cruise-control"].value and global.cruise_control[p] then 
            manage_cruise_control(p)
        end
    end
    -- process driving assistant (every "driving_assistant_tickrate" ticks)
    for i=ptick, pinvec, global.driving_assistant_tickrate do
        -- if vehicle == nil don't process the player
        if game.players[global.players_in_vehicles[i]].vehicle == nil then
            return
        end
        if (pinvec >= i) and global.drive_assistant[global.players_in_vehicles[i]] then
            manage_drive_assistant(global.players_in_vehicles[i])
        end
    end
    global.playertick = ptick
end