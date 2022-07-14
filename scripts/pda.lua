-- Copyright (c) 2016 sillyfly
-- Copyright (c) 2019 Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

local cruise_control_limit_gui = require("gui.cruise_control_limit")
local config = require("config")

local pda = {}

local acc = defines.riding.acceleration.accelerating
local brk = defines.riding.acceleration.braking
local idl = defines.riding.acceleration.nothing
local rev = defines.riding.acceleration.reversing

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

--- Converts Factorios meter per tick to floored integer kilometer per hour (used for GUI interaction)
local function mpt_to_kmph(mpt)
    return math.floor(mpt * 60 * 60 * 60 / 1000 + 0.5)
end

local function kmph_to_mpt(kmph)
    return ((kmph * 1000) / 60 / 60 / 60)
end

--- Get or init persistent vars
local function init_global()
    global = global or {}
    global.drive_assistant = global.drive_assistant or {}
    global.cruise_control = global.cruise_control or {}
    global.cruise_control_limit = global.cruise_control_limit or {}
    global.imposed_speed_limit = global.imposed_speed_limit or {}
    global.players_in_vehicles = global.players_in_vehicles or {}
    global.offline_players_in_vehicles = global.offline_players_in_vehicles or {}
    global.playertick = global.playertick or 0
    global.last_score = global.last_score or {}
    global.last_sign_data = global.last_sign_data or {}
    global.active_signs = global.active_signs or {}
    global.vehicles_registered_to_signs = global.vehicles_registered_to_signs or {}
    global.road_departure_brake_active = global.road_departure_brake_active or {}
    global.cruise_control_brake_active = global.cruise_control_brake_active or {}
    global.emergency_brake_power = global.emergency_brake_power or {}
    global.min_speed = global.min_speed or kmph_to_mpt(settings.global["PDA-setting-assist-min-speed"].value) or 0.1
    global.hard_speed_limit = global.hard_speed_limit or kmph_to_mpt(settings.global["PDA-setting-game-max-speed"].value) or 0
    global.highspeed = global.highspeed or kmph_to_mpt(settings.global["PDA-setting-assist-high-speed"].value) or 0.5
    global.driving_assistant_tickrate = global.driving_assistant_tickrate or settings.global["PDA-setting-tick-rate"].value or 2
    global.scores = config.get_scores()

    -- Ensure that cruise control limit is set to non-nil value for existing players.
    -- Needed when upgrading from versions <= 3.1.0.
    for player_index in pairs(game.players) do
        global.cruise_control_limit[player_index] =
            global.cruise_control_limit[player_index] or
            kmph_to_mpt(game.players[player_index].mod_settings["PDA-setting-personal-limit-sign-speed"].value)
    end

end


---@param sign table
local function increment_detector_signal(sign)
    if not sign or not sign.valid then
        return
    end
    local signals = sign.get_or_create_control_behavior()
    local count = 0
    local s = signals.get_signal(1)
    if s ~= nil and s.signal ~= nil then
        count = s.count
    end
    signals.set_signal(1, {count = count + 1, signal = {type="virtual", name="signal-V"}})
end

---@param sign table
local function decrement_detector_signal(sign)
        if not sign or not sign.valid then
        return
    end
    local signals = sign.get_or_create_control_behavior()
    local count = 1
    local s = signals.get_signal(1)
    if s ~= nil and s.signal ~= nil then
        count = s.count
    end
    signals.set_signal(1, {count = count - 1, signal = {type="virtual", name="signal-V"}})
end

function removeStopSignsFromLastSignData(player_index)
    local sd = global.last_sign_data[player_index]
    if sd ~= nil and sd.type ~= nil and sd.type["stop"] ~= nil then
        local stops = sd.type["stop"]
        local entities = {stops.entity_1, stops.entity_2, stops.entity_3, stops.entity_4}
        for _, e in pairs(entities) do
            decrement_detector_signal(e)
        end
    end
end

local function deregister_from_road_sensor(sign_uid, player_index)
    local sd = global.signs[sign_uid]
    local player = game.players[player_index]
    local qpos = 0
    local vreg = global.vehicles_registered_to_signs[player_index]
    local car = player.vehicle
    for i, pid in pairs(sd.vehicle_queue) do
        if pid == player_index then
            qpos = i
        end
    end
    if qpos > 0 then
        sd.vehicle_queue[qpos] = nil
        sd.vehicles_registered = sd.vehicles_registered - 1
        --game.print("S"..player_index.." deregistriert ["..sd.vehicles_registered.." Fahrzeuge verbleiben]")
        decrement_detector_signal(sd.entity)
        if sd.vehicles_registered == 0 then
            global.active_signs[sign_uid] = nil
        else
            sd.queue_update_pending = true
            -- the queue of this sign needs to be updated on next tick
        end
    else
        --game.print("FATAL: "..player_index.." nicht deregistriert [S-QPOS = "..qpos.." / V-QPOS = "..vreg.queue_position.." ?]")
    end
    global.emergency_brake_power[player_index] = nil -- stop braking for any stop position
    global.imposed_speed_limit[player_index] = vreg.previous_speed_limit
    if car and car.valid then
        if global.imposed_speed_limit[player_index] ~= nil and car.speed > 0 and car.speed > global.imposed_speed_limit[player_index] then
            -- keep brake active to deccelerate the vehicle
            global.cruise_control_brake_active[player_index] = true
        else
            global.cruise_control_brake_active[player_index] = false
            player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
        end
    end
    global.vehicles_registered_to_signs[player_index] = nil
end

--- Fired if a player enters or leaves a vehicle
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
        if car ~= nil and car.valid and car.type == "car" and not config.vehicle_blacklist[car.name] then
            -- if the player entered a valid car...
            local driver = car.get_driver()
            if driver ~= nil and (driver == player or driver.player == player) then
                -- ... and entered as the driver not as a passenger ...
                for i = 1, config.benchmark_level do
                    -- ... then insert player (or multiple instances of the same player, if benchmark_level > 1) in list
                    table.insert(global.players_in_vehicles, p_id)
                end
            end
        else
            -- remove player from list.
            for i=#global.players_in_vehicles, 1, -1 do
                if global.players_in_vehicles[i] == p_id then
                    -- reset emergency brake state, imposed speed limit and scores (e.g. if the vehicle got destroyed, its no longer necessary)
                    global.road_departure_brake_active[p_id] = false
                    global.emergency_brake_power[p_id] = nil
                    global.imposed_speed_limit[p_id] = nil
                    global.last_score[p_id] = 0
                    removeStopSignsFromLastSignData(player.index)
                    global.last_sign_data[p_id] = nil
                    if global.vehicles_registered_to_signs[p_id] ~= nil then
                        deregister_from_road_sensor(global.vehicles_registered_to_signs[p_id].registered_to_sensor, p_id)
                    end
                    table.remove(global.players_in_vehicles, i)
                end
            end
            -- reset emergency brake
            global.road_departure_brake_active[p_id] = false
        end

        -- Update shortcuts in one swoop.
        pda.update_shortcut_availability(player)

        if #global.players_in_vehicles > 0 then
            if config.debug then
                for i=1, #global.players_in_vehicles, 1 do
                    notification(tostring(i..".: Player index"..global.players_in_vehicles[i].." ("..game.players[global.players_in_vehicles[i]].name..")"))
                end
            end
        else
            if config.debug then
                notification("List empty.")
            end
        end
    end
end

--- Toggles (enables/disables) cruise control for player.
--
-- @param event LuaPlayer Player for which to toggle the cruise control.
--
function pda.toggle_cruise_control(player)
    if global.cruise_control[player.index] then
        pda.disable_cruise_control(player)
    else
        pda.enable_cruise_control(player)
    end
end

--- Displays dialog for setting the cruise control limit.
--
-- @param player LuaPlayer Player for which the dialog should be shown.
--
function pda.set_cruise_control_limit(player)
    if pda.is_driver_assistance_technology_available(player) then
        if pda.is_cruise_control_allowed() then
            -- open the gui if its not already open, otherwise close it
            if not player.gui.center.pda_cc_limit_gui_frame then
                cruise_control_limit_gui.build(player)
                player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.text = tostring(mpt_to_kmph(global.cruise_control_limit[player.index]))
                player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.select_all()
                player.gui.center.pda_cc_limit_gui_frame.pda_cc_limit_gui_textfield.focus()
            else
                player.gui.center.pda_cc_limit_gui_frame.destroy()
            end
        end
    end
end

--- Sets new value for cruise control limit.
--
-- @param player LuaPlayer Player for which the cruise control limit is being changed.
--
function pda.set_new_value_for_cruise_control_limit(player)

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

        -- check, if the player is sitting in a vehicle and changed the cc limit below the velocity of the car
        if player.vehicle ~= nil and player.vehicle.valid and player.vehicle.type == "car" and not config.vehicle_blacklist[player.vehicle.name] and player.vehicle.speed > global.cruise_control_limit[player.index] then
            global.cruise_control_brake_active[player.index] = true
        end
        if player.mod_settings["PDA-setting-verbose"].value then
            player.print({"DA-cruise-control-active", mpt_to_kmph(global.cruise_control_limit[player.index])})
        end
    end
end

-- handle gui interaction: player clicked on a button
function pda.on_gui_click(event)
    local player = game.players[event.player_index]
	if player.gui.center.pda_cc_limit_gui_frame then
		if event.element.name == "pda_cc_limit_gui_close" then
			player.gui.center.pda_cc_limit_gui_frame.destroy()
		elseif event.element.name == "pda_cc_limit_gui_confirm" then
			pda.set_new_value_for_cruise_control_limit(player)
			player.gui.center.pda_cc_limit_gui_frame.destroy()
		end
	end
end

-- handle gui interaction: player confirmed entry via textfield
function pda.on_gui_confirmed(event)
    local player = game.players[event.player_index]

    if player.opened and player.opened.name == "pda_cc_limit_gui_frame" then
        pda.set_new_value_for_cruise_control_limit(player)
        player.gui.center.pda_cc_limit_gui_frame.destroy()
    end
end

-- handle gui interaction: player closed cruise speed window via Escape
function pda.on_gui_closed(event)
   if event.element and event.element.name == "pda_cc_limit_gui_frame" then
      local player = game.players[event.player_index]

      if player.gui.center.pda_cc_limit_gui_frame then
         player.gui.center.pda_cc_limit_gui_frame.destroy()
      end
   end
end


--- Event handler for activating shortcuts.
--
-- @param event EventData Event data passed-on by the game engine.
--
function pda.on_lua_shortcut(event)
    local player = game.players[event.player_index]
    local shortcut = event.prototype_name

    if shortcut == "pda-cruise-control-toggle" then
        pda.toggle_cruise_control(player)
    elseif shortcut == "pda-drive-assistant-toggle" then
        pda.toggle_drive_assistant(player)
    elseif shortcut == "pda-set-cruise-control-limit" then
        pda.set_cruise_control_limit(player)
    end
end


--- Toggles driving assistant for the player.
--
-- @param player LuaPlayer Player for which to toggle the driving assistant.
--
function pda.toggle_drive_assistant(player)
    if global.drive_assistant[player.index] then
        pda.disable_drive_assistant(player)
    else
        pda.enable_drive_assistant(player)
    end
end


--- Guide the vehicle the player is driving depending on the surface tiles that are in front of the vehicle
---@param player_index number
local function manage_drive_assistant(player_index)
    local player = game.players[player_index]

	if player.riding_state.direction == defines.riding.direction.straight and (global.imposed_speed_limit[player_index] ~= nil or math.abs(player.vehicle.speed) > global.min_speed) then
		local car = player.vehicle
		local dir = car.orientation
        local scores = global.scores
        local eccent = config.eccent
        local newdir = 0
		local pi = math.pi
		local fsin = math.sin
		local fcos = math.cos
        local mfloor = math.floor
        --local mmin = math.min
        local get_tile = player.surface.get_tile

		local dirr = dir + config.lookangle
		local dirl = dir - config.lookangle

		-- scores for straight, right and left (@sillyfly)
		local ss,sr,sl = 0,0,0
		local vs = {fsin(2*pi*dir), -fcos(2*pi*dir)}
		local vr = {fsin(2*pi*dirr), -fcos(2*pi*dirr)}
		local vl = {fsin(2*pi*dirl), -fcos(2*pi*dirl)}

		local px = player.position['x'] or player.position[1]
		local py = player.position['y'] or player.position[2]
		local sign = (car.speed >= 0 and 1) or -1

		local sts = {px, py}
		local str = {px + sign*vs[2]*eccent, py - sign*vs[1]*eccent}
		local stl = {px -sign*vs[2]*eccent, py + sign*vs[1]*eccent}

        -- linearly increases start and length of the scanned area if the car is very fast
        local lookahead_start_hs = 0
        local lookahead_length_hs = 0

        if car.speed > global.highspeed then
            local speed_factor = car.speed / global.highspeed
            lookahead_start_hs = mfloor (config.hs_start_extension * speed_factor + 0.5)
            lookahead_length_hs = mfloor (config.hs_length_extension * speed_factor + 0.5)
        end

        for i=config.lookahead_start + lookahead_start_hs,config.lookahead_start + config.lookahead_length + lookahead_length_hs do
			local d = i*sign
            local rstx = str[1] + vs[1]*d
            local rsty = str[2] + vs[2]*d
            local lstx = stl[1] + vs[1]*d
            local lsty = stl[2] + vs[2]*d
            local rtx = px + vr[1]*d
            local rty = py + vr[2]*d
            local ltx = px + vl[1]*d
            local lty = py + vl[2]*d
			local rst = scores[get_tile(rstx, rsty).name]
			local lst = scores[get_tile(lstx, lsty).name]
			local rt = scores[get_tile(rtx, rty).name]
			local lt = scores[get_tile(ltx, lty).name]

            ss = ss + (((rst or 0) + (lst or 0))/2.0)
			sr = sr + (rt or 0)
			sl = sl + (lt or 0)
            --error("test")
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
		--[[if debug then
			player.print("x:" .. px .. "->" .. px+vs[1]*(lookahead_start + lookahead_length) .. ", y:" .. py .. "->" .. py+vs[2]*(lookahead_start + lookahead_length))
			player.print("S: " .. ss .. " R: " .. sr .. " L: " .. sl)
		end]]

        -- check if the score indicates that the vehicle leaved paved area
        local ls = global.last_score[player_index] or 0
        local ts = ss+sr+sl

        if ts < ls and ts == 0 and not global.road_departure_brake_active[player_index] then
            -- warn the player and activate emergency brake
            if player.mod_settings["PDA-setting-sound-alert"].value then
                player.play_sound{path = "pda-warning-1"}
                --player.surface.create_entity({name = "pda-warning-1", position = player.position})
            elseif player.mod_settings["PDA-setting-verbose"].value then
                player.print({"DA-road-departure-warning"})
            end
            player.riding_state = {acceleration = brk, direction = player.riding_state.direction}
            global.road_departure_brake_active[player_index] = true
        end
		global.last_score[player_index] = ts

        -- set new direction depending on the scores (@sillyfly)
        if sr > ss and sr > sl and (sr + ss) > 0 then
            newdir = dir + (config.changeangle*sr*2)/(sr+ss)
			--newdir = dir + mmin((config.changeangle*sr*2)/(sr+ss), car.prototype.rotation_speed)-- donfig.max_changeangle * global.driving_assistant_tickrate)
        elseif sl > ss and sl > sr and (sl + ss) > 0 then
            newdir = dir - (config.changeangle*sl*2)/(sl+ss)
			--newdir = dir - mmin((config.changeangle*sl*2)/(sl+ss), car.prototype.rotation_speed)--config.max_changeangle * global.driving_assistant_tickrate)
		else
           newdir = dir
        end

        -- Snap car to nearest 1/64 to avoid oscillation (@GotLag)
		--car.orientation = newdir
		car.orientation = mfloor(newdir * 64 + 0.5) / 64

        -- no score reset in curves -> allow the player to guide his vehicle off road manually
	elseif player.riding_state.direction ~= defines.riding.direction.straight then
        global.last_score[player_index] = 0
    end
end

---@param sign table
local function create_sign_logic_table(sign)
    if not sign or not sign.valid then
        return
    end
    data = {}
    data.entity = sign
    data.vehicle_queue = {}
    data.vehicles_registered = 0
    data.status = -1 -- will be updated if a vehicle drives across this sign
    data.queue_update_pending = false
    if global.signs == nil then global.signs = {} end
    global.signs[sign.unit_number] = data
end

---@param sign_uid number
local function delete_sign_logic_table(sign_uid)
    global.signs[sign_uid] = nil
end

---@param sign table
---@param player_index number
---@param velocity number
local function register_to_road_sensor(sign, player_index, velocity)
    if not sign or not sign.valid then
        return
    end
    local found = {}
    local find = {["signal-S"] = true, ["signal-C"] = true, ["signal-L"] = true}
    local signals = sign.get_or_create_control_behavior()
    local network_red = signals.get_circuit_network(defines.wire_type.red)
    local network_green = signals.get_circuit_network(defines.wire_type.green)
    if network_red ~= nil and network_red.signals ~= nil then
        for _, s in pairs(network_red.signals) do
            if find[s.signal.name] then
                found[s.signal.name] = s.count
                find[s.signal.name] = false
            end
        end
    elseif network_green ~= nil and network_green.signals ~= nil then
        for _, s in pairs(network_green.signals) do
            if find[s.signal.name] then
                found[s.signal.name] = s.count
                find[s.signal.name] = false
            end
        end
    else
        for _, s in pairs(signals.parameters) do
            if find[s.signal.name] then
                found[s.signal.name] = s.count
                find[s.signal.name] = false
            end
        end
    end
    local vec = {}
    vec.command = found["signal-C"] or 0 -- -1 = ignore; 0 = go, but listen to this sign; 1 = stop, but listen to this sign
    --global.signs[sign.unit_number].status = data.command
    if vec.command ~= -1 then
        increment_detector_signal(sign)
        local sign_data = global.signs[sign.unit_number]
        vec.registered_to_sensor = sign.unit_number
        vec.expected_stop_positions = found["signal-S"] or 0
        vec.passed_stop_positions = 0
        vec.waiting_at_stop_position = false
        vec.queue_position = sign_data.vehicles_registered + 1
        vec.previous_speed_limit = global.imposed_speed_limit[player_index]
        vec.local_speed_limit = (found["signal-L"] ~= nil and kmph_to_mpt(found["signal-L"])) or (global.min_speed + 0.024)

        global.vehicles_registered_to_signs[player_index] = vec
        sign_data.vehicles_registered = sign_data.vehicles_registered + 1
        sign_data.vehicle_queue[#sign_data.vehicle_queue + 1] = player_index
        if sign_data.vehicles_registered > 0 then
            -- this sign is now active and needs to be updated every few ticks
            if global.active_signs == nil then global.active_signs = {} end
            global.active_signs[sign.unit_number] = true
        end
        if vec.command == 1 and vec.expected_stop_positions > 0 then
            -- stop command: start to decelerate the vehicle, but only if a stop position is expected
            global.imposed_speed_limit[player_index] = vec.local_speed_limit
            if velocity > global.imposed_speed_limit[player_index] then
                global.cruise_control_brake_active[player_index] = true
            end
        end
        return true
    else
        return false
    end
end

local function update_vehicle_registered_to_sign(player_index, params)
    local vreg = global.vehicles_registered_to_signs[player_index]
    local player = game.players[player_index]
    local car = player.vehicle
    if car == nil or not car.valid then
        return false
    end
    if params.command ~= nil then
        -- this vehicle received a new command - either stop or go (or ignore)
        vreg.command = params.command
    end
    if params.queue_position ~= nil then
        -- this vehicle has a new queue position
        vreg.queue_position = params.queue_position
    end

    if params.command == 1 and (vreg.passed_stop_positions <= vreg.expected_stop_positions - vreg.queue_position) then
    -- stop command: start to decelerate the vehicle, but only if a stop position is expected
        global.imposed_speed_limit[player_index] = vreg.local_speed_limit
        if car.speed > 0 then
            -- vehicle is not already waiting -> brake
            if car.speed > global.imposed_speed_limit[player_index] then
                -- activate brake to deccelerate the vehicle
                global.cruise_control_brake_active[player_index] = true
            end
        end
    elseif params.command == 0 then
    -- go
        if vreg.passed_stop_positions == vreg.expected_stop_positions and vreg.queue_position == 1 then
            deregister_from_road_sensor(vreg.registered_to_sensor, player_index)
        else
            global.emergency_brake_power[player_index] = nil -- stop braking for any stop position
            global.imposed_speed_limit[player_index] = vreg.previous_speed_limit
            if global.imposed_speed_limit[player_index] ~= nil and car.speed > 0 and car.speed > global.imposed_speed_limit[player_index] then
                -- keep brake active to deccelerate the vehicle
                global.cruise_control_brake_active[player_index] = true
            else
                global.cruise_control_brake_active[player_index] = false
                player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
            end
        end
        if vreg.waiting_at_stop_position then
            vreg.waiting_at_stop_position = false
            player.riding_state = {acceleration = acc, direction = player.riding_state.direction}
        end
    elseif params.command == -1 then
    -- ignore this sign
        deregister_from_road_sensor(vreg.registered_to_sensor, player_index)
    end
    return true
end

local function update_road_sensor_data(sign_uid)
    local sign = global.signs[sign_uid]
    if not sign then
        return false
    else
        sign = global.signs[sign_uid].entity
        if not sign or not sign.valid then
            return false
        end
    end
    local found = {}
    local find = {["signal-C"] = true}
    local signals = sign.get_or_create_control_behavior()
    local network_red = signals.get_circuit_network(defines.wire_type.red)
    local network_green = signals.get_circuit_network(defines.wire_type.green)
    if network_red ~= nil and network_red.signals ~= nil then
        for _, s in pairs(network_red.signals) do
            if find[s.signal.name] then
                found[s.signal.name] = s.count
                find[s.signal.name] = false
            end
        end
    elseif network_green ~= nil and network_green.signals ~= nil then
        for _, s in pairs(network_green.signals) do
            if find[s.signal.name] then
                found[s.signal.name] = s.count
                find[s.signal.name] = false
            end
        end
    else
        for _, s in pairs(signals.parameters) do
            if find[s.signal.name] then
                found[s.signal.name] = s.count
                find[s.signal.name] = false
            end
        end
    end
    local new_command = found["signal-C"] or 0
    local sd = global.signs[sign.unit_number]
    if sd.status ~= new_command then
        sd.status = new_command
        for _, pid in pairs(sd.vehicle_queue) do
            if not update_vehicle_registered_to_sign(pid, {command = new_command}) then
                deregister_from_road_sensor(sign_uid, pid)
            end
        end
    end
    if sd.queue_update_pending then
        sd.queue_update_pending = false
        local new_position = 1
        for position, pid in pairs(sd.vehicle_queue) do
            if not update_vehicle_registered_to_sign(pid, {queue_position = new_position}) then
                deregister_from_road_sensor(sign_uid, pid)
            else
                if new_position ~= position then
                    -- swap positions only if they've changed
                    sd.vehicle_queue[new_position] = pid
                    sd.vehicle_queue[position] = nil
                end
                new_position = new_position + 1
            end
        end
    end
    return true
end

local function get_speed_limit_value(sign)
    local sign = sign.get_or_create_control_behavior()
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
    return sign_value
end

function updateLastSignData(player_index, newSign_uid, newSignType, stopSignEntity)
    -- up to four signs will be cached if the player drives over multiple signs at once
    local last = global.last_sign_data[player_index]
    if last.type == nil then last.type = {} end
    if last.type[newSignType] == nil then last.type[newSignType] = {} end
    last.ignore[newSign_uid] = true
    if last.type[newSignType].id_1 == nil then
        last.type[newSignType].id_1 = newSign_uid
        if stopSignEntity ~= nil then
            last.type[newSignType].entity_1 = stopSignEntity
        end
    elseif last.type[newSignType].id_2 == nil then
        last.type[newSignType].id_2 = newSign_uid
        if stopSignEntity ~= nil then
            last.type[newSignType].entity_2 = stopSignEntity
        end
    elseif last.type[newSignType].id_3 == nil then
        last.type[newSignType].id_3 = newSign_uid
        if stopSignEntity ~= nil then
            last.type[newSignType].entity_3 = stopSignEntity
        end
    elseif last.type[newSignType].id_4 == nil then
        last.type[newSignType].id_4 = newSign_uid
        if stopSignEntity ~= nil then
            last.type[newSignType].entity_4 = stopSignEntity
        end
    else
        -- delete old element one; old element two is now element one; new element is now element two
        last.ignore[last.type[newSignType].id_1] = nil
        last.type[newSignType].id_1, last.type[newSignType].id_2, last.type[newSignType].id_3, last.type[newSignType].id_4 =
        last.type[newSignType].id_2, last.type[newSignType].id_3, last.type[newSignType].id_4, newSign_uid
        if stopSignEntity ~= nil then
            decrement_detector_signal(last.type[newSignType].entity_1)
            last.type[newSignType].entity_1, last.type[newSignType].entity_2, last.type[newSignType].entity_3, last.type[newSignType].entity_4 =
            last.type[newSignType].entity_2, last.type[newSignType].entity_3, last.type[newSignType].entity_4, stopSignEntity
        end
    end
end


--- Sign detection and processing
--- @param player_index number
local function process_signs(player_index)
    local cc_active = global.cruise_control[player_index]
    local player = game.players[player_index]
    local px = player.position['x'] or player.position[1]
	local py = player.position['y'] or player.position[2]
	local car = player.vehicle
    local vreg = global.vehicles_registered_to_signs[player_index]
    local sign_scanner = player.surface.find_entities_filtered{area = {{px-1, py-1},{px+1, py+1}}, type="constant-combinator"}
    if #sign_scanner > 0 then
        -- sign detected
        if global.last_sign_data[player_index] == nil then
            global.last_sign_data[player_index] = {["ignore"] = {}}
        end
        for i = 1, #sign_scanner do
            if not global.last_sign_data[player_index].ignore[sign_scanner[i].unit_number] then
                if sign_scanner[i].name == "pda-road-sign-stop" then
                    -- detect stop signs even if cruise control is inactive
                    updateLastSignData(player_index, sign_scanner[i].unit_number, "stop", sign_scanner[i])
                    increment_detector_signal(sign_scanner[i])
                    local pass_stop_sign = false
                    if vreg then
                    -- if this vehicle is currently registered to a sensor
                        vreg.passed_stop_positions = vreg.passed_stop_positions + 1
                        if vreg.command ~= 1 then
                            pass_stop_sign = true
                        elseif vreg.passed_stop_positions <= vreg.expected_stop_positions - vreg.queue_position then
                            -- this works like signal blocks: if another vehicle is infront, stop one stop position before. If not, pass this sign.
                            pass_stop_sign = true
                        end
                        if vreg.command ~= 1 and vreg.passed_stop_positions == vreg.expected_stop_positions and vreg.queue_position == 1 then
                            deregister_from_road_sensor(vreg.registered_to_sensor, player_index)
                        end
                    end
                    if not pass_stop_sign and car.speed > 0 then
                        local brake_power
                        if not global.emergency_brake_power[player_index] then
                            local v_ms = car.speed * 60
                            local brake_distance_m = 4
                            local brake_time_s = brake_distance_m / v_ms
                            --brake_distance = (speed ^ 2) / 2 * brake_power
                            local brake_retardation_ms2 = ((v_ms ^ 2) / (2 * brake_distance_m))
                            brake_power = brake_retardation_ms2 / (60 ^ 2)
                            global.emergency_brake_power[player_index] = brake_power
                        end
                        global.imposed_speed_limit[player_index] = 0 -- global.min_speed + 0.024 -- min speed + 5 km/h
                        player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
                        -- activate brake to deccelerate the vehicle
                    end
                    return true
                elseif cc_active == false then
                    -- other signs are only processed if cruise control is active
                    return false
                elseif sign_scanner[i].name == "pda-road-sensor" then
                    updateLastSignData(player_index, sign_scanner[i].unit_number, "sensor")
                    if vreg == nil then
                        -- this vehicle does now listen to this road sensor
                        register_to_road_sensor(sign_scanner[i], player_index, car.speed)
                        return true
                    elseif vreg.registered_to_sensor ~= sign_scanner[i].unit_number then
                        -- change the road sensor this vehicle listens to
                        deregister_from_road_sensor(vreg.registered_to_sensor, player_index)
                        register_to_road_sensor(sign_scanner[i], player_index, car.speed)
                        return true
                    end
                elseif sign_scanner[i].name == "pda-road-sign-speed-limit" then
                    updateLastSignData(player_index, sign_scanner[i].unit_number, "limit")
                    local sign_value = get_speed_limit_value(sign_scanner[i])
                    -- read signal value only if a signal is set
                    if sign_value ~= 0 then
                        if vreg == nil then
                            global.imposed_speed_limit[player_index] = kmph_to_mpt(sign_value)
                            if car.speed > global.imposed_speed_limit[player_index] then
                                -- activate brake to deccelerate the vehicle
                                global.cruise_control_brake_active[player_index] = true
                            end
                        else -- if this vehicle is currently in a sensor controlled section
                            vreg.previous_speed_limit = kmph_to_mpt(sign_value)
                            if vreg.command == 0 then
                                global.imposed_speed_limit[player_index] = vreg.previous_speed_limit
                                if global.imposed_speed_limit[player_index] ~= nil and car.speed > 0 and car.speed > global.imposed_speed_limit[player_index] then
                                    -- keep brake active to deccelerate the vehicle
                                    global.cruise_control_brake_active[player_index] = true
                                else
                                    global.cruise_control_brake_active[player_index] = false
                                    player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
                                end
                            end
                        end
                    end
                    return true
                elseif sign_scanner[i].name == "pda-road-sign-speed-unlimit" then
                    updateLastSignData(player_index, sign_scanner[i].unit_number, "unlimit")
                    if vreg == nil then
                        global.imposed_speed_limit[player_index] = nil
                    else
                        vreg.previous_speed_limit = nil
                        if vreg.command == 0 then
                            global.imposed_speed_limit[player_index] = vreg.previous_speed_limit
                        end
                    end
                    return true
                end
            end
        end
    elseif global.last_sign_data[player_index] ~= nil then
        removeStopSignsFromLastSignData(player_index)
        global.last_sign_data[player_index] = nil
    end
    return false
end

--- Check if vehicle speed needs to be adjusted (only if cruise control is active).
--- Wont do anything if player stands still or is braking.
--- @param player_index number
local function manage_cruise_control(player_index)
    local player = game.players[player_index]
    local speed = player.vehicle.speed
    local target_speed = 0

    -- check if there is a speed limit that is more restrictive than the set limit for cruise control
    if global.imposed_speed_limit[player_index] ~= nil and (global.imposed_speed_limit[player_index] < global.cruise_control_limit[player_index]) then
        target_speed = global.imposed_speed_limit[player_index]
    else
        target_speed = global.cruise_control_limit[player_index]
    end
	if speed ~= 0 and player.riding_state.acceleration ~= brk and global.emergency_brake_power[player_index] == nil then
        if math.abs(speed) > target_speed then
            player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
            if speed > 0 then
                player.vehicle.speed = target_speed
            -- check for reverse gear
            else
                player.vehicle.speed = -target_speed
            end
        elseif speed > 0 and speed < target_speed then
            player.riding_state = {acceleration = acc, direction = player.riding_state.direction}
        end
    end
end

-- on game start
function pda.on_init(data)
    init_global()

    for _, player in pairs(game.players) do

        if not pda.is_driver_assistance_technology_available(player) then
            pda.disable_drive_assistant(player)
        end

        -- Cruise control depends on additional map setting in order to be available.
        if not pda.is_driver_assistance_technology_available(player) or not pda.is_cruise_control_allowed() then
            pda.disable_cruise_control(player)
        end

        pda.update_shortcut_availability(player)
    end
end

-- joining players that drove vehicles while leaving the game are in the "offline_players_in_vehicles" list and will be put back to normal
function pda.on_player_joined_game(event)
    local p = event.player_index
    if config.debug then
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
        if config.debug then notification(tostring(i..". test - is offline player "..global.offline_players_in_vehicles[i].." now online player: "..p.." ?")) end
        if global.offline_players_in_vehicles[i] == p then
            table.insert(global.players_in_vehicles, p)
            table.remove(global.offline_players_in_vehicles, i)
        end
    end
    if config.debug then notification(tostring("num players now in offline_mode: "..#global.offline_players_in_vehicles)) end

    -- Ensure that cruise control limit is set to non-nil value for joining players.
    global.cruise_control_limit[p] =
        global.cruise_control_limit[p] or
        kmph_to_mpt(game.players[p].mod_settings["PDA-setting-personal-limit-sign-speed"].value)
end

-- puts leaving players currently driving a vehicle in the "offline_players_in_vehicles" list
function pda.on_player_left_game(event)
   local p = event.player_index
    if config.debug then notification(tostring("on-left triggered by player "..p)) end
    for i=#global.players_in_vehicles, 1, -1 do
        if global.players_in_vehicles[i] == p then
            table.insert(global.offline_players_in_vehicles, p)
            table.remove(global.players_in_vehicles, i)
            -- deregister from stop signs and sensors - this would otherwise break their logic
            removeStopSignsFromLastSignData(p)
            global.last_sign_data[p] = nil
            if global.vehicles_registered_to_signs[p] ~= nil then
                deregister_from_road_sensor(global.vehicles_registered_to_signs[p].registered_to_sensor, p)
            end
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
                e.get_or_create_control_behavior().parameters = {{index = 1, count = limit, signal = {type="virtual", name="signal-L"}}}
            end
        elseif e.name == "pda-road-sensor" then
            create_sign_logic_table(e)
            local limit = p ~= nil and game.players[p].mod_settings["PDA-setting-personal-limit-sign-speed"].value or settings.global["PDA-setting-server-limit-sign-speed"].value
            local params = e.get_or_create_control_behavior().parameters
            e.get_or_create_control_behavior().parameters =
                {
                    {index = 1, count = 0, signal = {type="virtual", name="signal-V"}},
                    {index = 2, count = (params[2].signal.name == "signal-C" and params[2].count) or -1, signal = {type="virtual", name="signal-C"}},
                    {index = 3, count = (params[3].signal.name == "signal-S" and params[3].count) or 0, signal = {type="virtual", name="signal-S"}},
                    {index = 4, count = (params[4].signal.name == "signal-L" and params[4].count) or limit, signal = {type="virtual", name="signal-L"}}
                }
        end
    end
end

function pda.on_sign_removed(event)
    local p = event.player_index
    local e = event.entity
    if e.type == "constant-combinator" then
        if e.name == "pda-road-sensor" then
            for _, pid in pairs(global.signs[e.unit_number].vehicle_queue) do
                -- all vehicles currently controlled by this sign are set to ignore this sign now
                update_vehicle_registered_to_sign(pid, {command = -1})
            end
            delete_sign_logic_table(e.unit_number)
        end
    end
end

function pda.on_tick(event)
-- Main routine (remember the api and the "no heavy code in the on_tick event" advice? ^^)
    -- Process every n-th player in vehicles (n = driving_assistant_tickrate)
    -- Exception: Process "cruise control" every tick to gain maximum acceleration
    local ptick = global.playertick
    local pinvec = #global.players_in_vehicles

    if ptick < global.driving_assistant_tickrate then
        ptick = ptick + 1
    else
        ptick = 1
    end
    global.playertick = ptick

    if game.tick%5 == 0 then
        -- check every 5 ticks if road sensors need to be updated
        for sign_uid, _ in pairs(global.active_signs) do
            if not update_road_sensor_data(sign_uid) then
                global.active_signs[sign_uid] = nil
            end
        end
    end

    if pinvec == 0 then
        -- no vehicles to process
        return
    end

    -- process cruise control, check for hard_speed_limit and road_departure_brake_active (every tick)
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
        -- evaluate any road signs in front of this vehicle
        process_signs(p)
        -- check if forced braking is active...
        if global.emergency_brake_power[p] then
            if player.riding_state.acceleration == (acc) or car.speed <= 0 then
                global.emergency_brake_power[p] = nil
                global.imposed_speed_limit[p] = nil
                car.speed = 0
                if global.vehicles_registered_to_signs[p] ~= nil then
                    global.vehicles_registered_to_signs[p].waiting_at_stop_position = true
                end
            else
                player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
                car.speed = math.max(car.speed - global.emergency_brake_power[p], 0)
            end
        elseif global.road_departure_brake_active[p] then
            if player.riding_state.acceleration == (acc) or car.speed == 0 then
                global.road_departure_brake_active[p] = false
                player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
            else
                player.riding_state = {acceleration = brk, direction = player.riding_state.direction}
            end
        -- ...otherwise proceed to handle cruise control
        elseif global.cruise_control_brake_active[p] then
            if (car.speed < global.cruise_control_limit[p]) and global.imposed_speed_limit[p] == nil or (global.imposed_speed_limit[p] ~= nil and car.speed < global.imposed_speed_limit[p]) then
                global.cruise_control_brake_active[p] = false
                player.riding_state = {acceleration = idl, direction = player.riding_state.direction}
            else
                player.riding_state = {acceleration = brk, direction = player.riding_state.direction}
            end
        -- ...otherwise proceed to handle cruise control
        elseif pda.is_cruise_control_allowed() and global.cruise_control[p] then
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
    --global.playertick = ptick
end


--- Checks if driver assistance and cruise control technologies are available.
--
-- @return bool true if yes, false otherwise.
--
function pda.is_driver_assistance_technology_available(player)
    if settings.startup["PDA-setting-tech-required"].value then
        return player.force.technologies["Arci-pavement-drive-assistant"].researched
    end

    return true
end


--- Check if cruise control is allowed.
--
-- This is a separate check from the technology availability check.
--
-- @return bool true if allowed, false otherwise.
--
function pda.is_cruise_control_allowed()
    return settings.global["PDA-setting-allow-cruise-control"].value
end


--- Checks if cruise control limit has been configured to use fixed value.
--
-- @return bool true if active, false otherwise.
--
function pda.is_fixed_cruise_control_limit_enabled(player)
    return player.mod_settings["PDA-setting-alt-toggle-mode"].value
end


--- Enables driving assistant for a player.
--
-- @param player LuaPlayer Player for which the driving assistant should be enabled.
--
function pda.enable_drive_assistant(player)
    -- Nothing to be done, bail out immediatelly.
    if not pda.is_driver_assistance_technology_available(player) or global.drive_assistant[player.index] then
        return
    end

    -- Player is not in a valid vehicle.
    if not player.vehicle or not player.vehicle.valid or player.vehicle.type ~= "car" then
        return
    elseif config.vehicle_blacklist[player.vehicle.name] then
        player.print({"DA-vehicle-blacklisted"})
        return
    end

    global.drive_assistant[player.index] = true

    player.set_shortcut_toggled("pda-drive-assistant-toggle", true)

    if player.mod_settings["PDA-setting-verbose"].value then
        player.print({"DA-drive-assistant-active"})
    end
end


--- Disables driving assistant for a player.
--
-- @param player LuaPlayer Player for which the driving assistant should be disabled.
--
function pda.disable_drive_assistant(player)
    -- Nothing to be done, bail out immediatelly.
    if not global.drive_assistant[player.index] then
        return
    end

    global.drive_assistant[player.index] = false
    global.road_departure_brake_active[player.index] = false
    global.last_score[player.index] = 0

    player.set_shortcut_toggled("pda-drive-assistant-toggle", false)

    if player.mod_settings["PDA-setting-verbose"].value then
        player.print({"DA-drive-assistant-inactive"})
    end
end


--- Enables cruise control for a player.
--
-- Cruise control is only enabled if player is in a car-like vehicle.
--
-- @param player LuaPlayer Player for which the cruise control should be enabled.
--
function pda.enable_cruise_control(player)
    -- Cruise control disabled game-wise, bail out immediatelly.
    if not pda.is_cruise_control_allowed() then
        player.print({"DA-cruise-control-not-allowed"})
        return
    end

    -- Nothing to be done, bail out immediatelly.
    if not pda.is_driver_assistance_technology_available(player) or global.cruise_control[player.index] then
        return
    end

    -- Player is not in a valid vehicle.
    if not player.vehicle or not player.vehicle.valid or player.vehicle.type ~= "car" then
        return
    elseif config.vehicle_blacklist[player.vehicle.name] then
        player.print({"DA-vehicle-blacklisted"})
        return
    end

    global.cruise_control[player.index] = true

    -- Set cruise control limit to current vehicle speed if fixed control limit is not enabled.
    if not pda.is_fixed_cruise_control_limit_enabled(player) then
        -- Store absolute value as vehicle speed (less than zero means player is reversing the car).
        if player.vehicle.speed > 0 then
            global.cruise_control_limit[player.index] = player.vehicle.speed
        else
            global.cruise_control_limit[player.index] = -player.vehicle.speed
        end
    else
        -- Slow down the vehicle to current cruise control limit.
        if player.vehicle.speed > global.cruise_control_limit[player.index] then
            global.cruise_control_brake_active[player.index] = true
        end
    end

    player.set_shortcut_toggled("pda-cruise-control-toggle", true)

    if player.mod_settings["PDA-setting-verbose"].value then
        player.print({"DA-cruise-control-active", mpt_to_kmph(global.cruise_control_limit[player.index])})
    end
end


--- Disables cruise control for a player.
--
-- @param player LuaPlayer Player for which the cruise control should be disabled
--
function pda.disable_cruise_control(player)
    -- Nothing to be done, bail out immediatelly.
    if not global.cruise_control[player.index] then
        return
    end

    -- Drop player's vehicle from stop signs vehicle tracking.
    global.last_sign_data[player.index] = nil
    removeStopSignsFromLastSignData(player.index)

    -- Deregister player's vehicle from road sensors.
    if global.vehicles_registered_to_signs[player.index] then
        deregister_from_road_sensor(global.vehicles_registered_to_signs[player.index].registered_to_sensor, player.index)
    end

    -- Reset riding_state to stop acceleration.
    player.riding_state = {acceleration = idl, direction = player.riding_state.direction}

    global.cruise_control[player.index] = false
    global.cruise_control_brake_active[player.index] = false
    global.imposed_speed_limit[player.index] = nil

    player.set_shortcut_toggled("pda-cruise-control-toggle", false)

    if player.mod_settings["PDA-setting-verbose"].value then
        player.print({"DA-cruise-control-inactive"})
    end
end


--- Handles on_research_finished game event for PDA-related technologies.
--
-- Takes care of enabling the necessary shortcuts etc.
--
-- @param event EventData Event data passed-on by the game engine.
--
function pda.on_research_finished(event)
    if event.research.name == "Arci-pavement-drive-assistant" then
        for _, player in pairs(event.research.force.players) do
            pda.update_shortcut_availability(player)
        end
    end
end


--- Handles on_research_reversed game event for PDA-related technologies.
--
-- Takes care of disabling the shortcuts, drive assistant, and cruise control.
--
-- @param event EventData Event data passed-on by the game engine.
--
function pda.on_research_reversed(event)
    if event.research.name == "Arci-pavement-drive-assistant" then
        for _, player in pairs(event.research.force.players) do
            pda.disable_cruise_control(player)
            pda.disable_drive_assistant(player)
            pda.update_shortcuts(player)
        end
    end
end


--- Updates availability of shortcuts for a given player.
--
-- Takes into account availability of technology, map settings, and player status (in vehicle or not in vehicle).
--
-- @param player LuaPlayer Player to update the shortcuts for.
--
function pda.update_shortcut_availability(player)
    local driver_assistance = pda.is_driver_assistance_technology_available(player)
    local cruise_control = pda.is_driver_assistance_technology_available(player) and pda.is_cruise_control_allowed()

    if player.vehicle and player.vehicle.valid and player.vehicle.type == "car" and not config.vehicle_blacklist[player.vehicle.name] then
        player.set_shortcut_available("pda-drive-assistant-toggle", driver_assistance)
        player.set_shortcut_available("pda-cruise-control-toggle", cruise_control)
    else
        player.set_shortcut_available("pda-drive-assistant-toggle", false)
        player.set_shortcut_available("pda-cruise-control-toggle", false)
    end

    player.set_shortcut_available("pda-set-cruise-control-limit", pda.is_driver_assistance_technology_available(player) and pda.is_cruise_control_allowed())
end

return pda
