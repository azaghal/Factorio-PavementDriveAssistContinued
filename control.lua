-- Copyright (2016) sillyfly. Provided under MIT license. See license.txt for details. 
-- This is the main logic script. For configuration options see lua.

require "defines"
require "math"
require "config"

script.on_event(defines.events.on_tick, function(event)
	-- Process events 30 times per second.
	-- Interleave players to avoid lags
	for i=(game.tick%2)+1, #game.players, 2 do
		local player = game.players[i]
		if player.vehicle and player.vehicle.valid and vehicles[player.vehicle.name] and player.riding_state.direction == defines.riding.direction.straight and math.abs(player.vehicle.speed) > minspeed then
			local car = player.vehicle
			local dir = car.orientation
			
			local dirr = dir + lookangle
			local dirl = dir - lookangle
			
			-- scores for straight, right and left
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
			
			for i=lookahead_start,lookahead_start + lookahead_length do
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
			
			if sr > ss and sr > sl then
				car.orientation  = dir + (changeangle*sr*2)/(sr+ss)
			elseif sl > ss and sl > sr then
				car.orientation = dir - (changeangle*sl*2)/(sl+ss)
			end
			-- Snap car to nearest 1/64 to avoid oscillation (@GotLag)
			car.orientation = math.floor(car.orientation * 64 + 0.5) / 64
			
		end
	end
end)
