-- Copyright (2017) Arcitos, based on the work of sillyfly. Provided under MIT license. See license.txt for details. 

-- ###  CONTROL SETTINGS  ###

-- Messaging flag. Setting to true will announce changes of the state of the drive assistant or cruise control (activated/deactivated) to the console
verbose = true

-- Sound flag. As long as this is "true" there will be a short warning sound played if the player's vehicle leaves paved ground, indicating a dead end (or an unintended failure of the PDA). If set so false, the warning will be printed to console.
alert = true

-- Technology flag. Default setting is true. Set this to false if you want drive assistant and cruise control to work without researching the technology at first. 
technology_required = true

-- Vehicles that will not be supported by the driving assistant. This is tested against the name of the vehicle. All other vehicles will be supported.
-- example: {["car"] = false, ["tank"] = false}
vehicle_blacklist = {}

-- This variable determines the amount of ticks for one driving assist scan. Default is "2", meaning there are 30 scans per second (60/2)
-- Set this value to 1 if you want maximum precision (and an extra amount (+100%) of load, as the event will be fired on every tick). Set it to 3 or higher to reduce the load on your CPU, at the cost of decreased precision. Setting this to very high values (> 4) will make the driving assistant increasingly sluggish and finally useless at higher speeds. 
driving_assistant_tickrate = 2

-- This flag determines if any player is allowed to use cruise control on their ride. If you experience significant lags, switching this to "false" might save you circa 20% of the overall load created by this mod.
cruise_control_allowed = true

-- Use this variable to set up a hard speed limit for all players and all rideable "car"-type vehicles (so trains will not be affected) in your game. This will also limit the load caused by the driving assistant, as higher speeds are generally more demanding in terms of CPU time. Values smaller or equal to zero will allow for unlimited speed. Speed is allways in tiles/tick. Multiply by 216 to get km/h. 
hard_speed_limit = -1

-- ###  ADVANCED SETTINGS  ###

-- Minimum speed to start assisting in. 
minspeed = 0.1

-- How many tiles ahead of location to start looking. Remember that most vehicles are 2x2, so this should be 1-2 preferably.
lookahead_start = 2

-- How many tiles ahead to look at. Setting this too larger values may cause lags, but increases precision.
lookahead_length = 4

-- Angle to look for tiles on each side. 1/24 (= 360/24 = 15 degrees) seems to work nicely. 
lookangle = 1/24

-- Use 1/64 angles for better sprite orientation (@GotLag).
changeangle = 1/64

-- Straight lookahead eccentricity (to avoid driving on the edge of a paved path)
eccent = 1

-- If a vehicle is faster than this speed, the scanned area in front of the vehicle will be linearily increased.
highspeed = 0.5

-- Adds to lookahead_start if vehicle is in highspeed-mode.
hs_start_extension = 1

-- Adds to lookahead_length if vehicle is in highspeed-mode.
hs_length_extension = 2

-- Vehicle will accelerate in cruise control mode if velocity falls below vehicle speed times minspeed_tolerance. 
-- Factor 1 leads to constant speed, factor of 0 means no minimum speed will be aplied at all.
minspeed_tolerance = 1

-- Score for each tile type. Tiles not included will be given zero score. Negative scores mean try to avoid this type of tile. 
scores = {
	-- These are the tiles in the base game. Vehicles will try to avoid hazard zones.
	["stone-path"] = 0.5, ["concrete"] = 1, 
    ["hazard-concrete-left"] = 0.2, ["hazard-concrete-right"] = 0.2,
    -- "Asphalt Roads" mod tiles. Vehicles will try to not cross lane marking tiles and avoid red hazard zones.
    ["Arci-asphalt"] = 1.25, 
    ["Arci-asphalt-hazard-white-left"] = 1.25, ["Arci-asphalt-hazard-white-right"] = 1.25, 
    ["Arci-asphalt-hazard-yellow-left"] = 1.25, ["Arci-asphalt-hazard-yellow-right"] = 1.25, 
    ["Arci-asphalt-hazard-red-left"] = -0.25, ["Arci-asphalt-hazard-red-right"] = -0.25, 
    ["Arci-asphalt-hazard-blue-left"] = 1.25, ["Arci-asphalt-hazard-blue-right"] = 1.25, 
    ["Arci-asphalt-marking-white-ns"] = 0.4, ["Arci-asphalt-marking-white-swne"] = 0.4,
    ["Arci-asphalt-marking-white-we"] = 0.4, ["Arci-asphalt-marking-white-nwse"] = 0.4,
    ["Arci-asphalt-marking-yellow-ns"] = 0.4, ["Arci-asphalt-marking-yellow-swne"] = 0.4,
    ["Arci-asphalt-marking-yellow-we"] = 0.4, ["Arci-asphalt-marking-yellow-nwse"] = 0.4,
    ["Arci-asphalt-zebra-crossing-horizontal"] = 1.25, ["Arci-asphalt-zebra-crossing-vertical"] = 1.25, 
    -- The following are 5dim mod tiles. 
	["5d-concrete-a"] = 1, ["5d-concrete-b"] = 1, ["5d-concrete-b2"] = 1, 
	["5d-concrete-m"] = 1, ["5d-concrete-r"] = 1, ["5d-concrete-v"] = 1, 
	-- The following are color-coding mod tiles,
	["concrete-red"] = 1, ["concrete-orange"] = 1, ["concrete-yellow"] = 1,
	["concrete-green"] = 1, ["concrete-cyan"] = 1, ["concrete-blue"] = 1, 
	["concrete-purple"] = 1, ["concrete-magenta"] = 1, ["concrete-white"] = 1,
	["concrete-black"] = 1, ["concrete-hazard-left"] = 1, ["concrete-hazard-right"] = 1,
	["concrete-fire-left"] = 1, ["concrete-fire-right"] = 1,
    -- The following are "More-Floors" mod tiles
    ["smooth-concrete"] = 1, ["wood-floor"] = 0.4, ["reinforced-concrete"] = 1, 
    ["diamond-plate"] = 0.5, ["rusty-metal"] = 0.5, ["rusty-grate"] = 0.5, 
    ["arrow-grate"] = 1.25, ["circuit-floor"] = 0.5, ["gravel"] = 0.3, 
    ["asphalt"] = 1.25, ["alien-metal"] = 0.5, ["metal-scraps"] = 0.5, 
    ["hexagonb"] = 0.5,
}

-- List of mods that are incompatible to pavement drive assist and will cause mod deactivation.
mod_incompatibility_list = {["VehicleSnap"] = true}

-- This variable determines the number of players inserted into the player_in_vehicle list if a vehicle is entered. Set this to more than 1 to simulate multiple players at once, useful for testing how many players your server is able to support until severe FPS-drops emerge. 
benchmark_level = 1

-- Debugging flag. Setting to true will spam your console with debugging messages. 
debug = false
