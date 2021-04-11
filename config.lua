-- Copyright (2017) Arcitos, based on work of sillyfly. Provided under MIT license. See license.txt for details. 

-- ###  ADVANCED SETTINGS  ###

-- Vehicles that will not be supported by the driving assistant. This is tested against the name of the vehicle. All other vehicles will be supported.
-- example: {["car"] = false, ["tank"] = false}
vehicle_blacklist = {}

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

-- Adds to lookahead_start if vehicle is in highspeed mode.
hs_start_extension = 1

-- Adds to lookahead_length if vehicle is in highspeed mode.
hs_length_extension = 2

-- Score for each tile type. Tiles not included will be given zero score. Negative scores: try to avoid this type of tile. 
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
    ["Arci-asphalt-hazard-green-left"] = 1.25, ["Arci-asphalt-hazard-green-right"] = 1.25, 
    ["Arci-asphalt-zebra-crossing-horizontal"] = 1.25, ["Arci-asphalt-zebra-crossing-vertical"] = 1.25,     
    ["Arci-asphalt-triangle-white-up"] = 1.25, ["Arci-asphalt-triangle-white-left"] = 1.25, ["Arci-asphalt-triangle-white-down"] = 1.25, ["Arci-asphalt-triangle-white-right"] = 1.25,

    ["Arci-marking-white-straight-vertical"] = 0.4,    ["Arci-marking-white-diagonal-right"] = 0.4,
    ["Arci-marking-white-straight-horizontal"] = 0.4,  ["Arci-marking-white-diagonal-left"] = 0.4,
    ["Arci-marking-white-right-turn-left"] = 0.4,      ["Arci-marking-white-left-turn-left"] = 0.4,
    ["Arci-marking-white-right-turn-down"] = 0.4,      ["Arci-marking-white-left-turn-down"] = 0.4,
    ["Arci-marking-white-right-turn-up"] = 0.4,        ["Arci-marking-white-left-turn-up"] = 0.4,
    ["Arci-marking-white-left-turn-right"] = 0.4,      ["Arci-marking-white-right-turn-right"] = 0.4,
    ["Arci-marking-yellow-straight-vertical"] = 0.4,   ["Arci-marking-yellow-diagonal-right"] = 0.4,
    ["Arci-marking-yellow-straight-horizontal"] = 0.4, ["Arci-marking-yellow-diagonal-left"] = 0.4,
    ["Arci-marking-yellow-right-turn-left"] = 0.4,     ["Arci-marking-yellow-left-turn-left"] = 0.4,
    ["Arci-marking-yellow-right-turn-down"] = 0.4,     ["Arci-marking-yellow-left-turn-down"] = 0.4,
    ["Arci-marking-yellow-right-turn-up"] = 0.4,       ["Arci-marking-yellow-left-turn-up"] = 0.4,
    ["Arci-marking-yellow-left-turn-right"] = 0.4,     ["Arci-marking-yellow-right-turn-right"] = 0.4,
    
    ["Arci-marking-white-dl-straight-vertical"] = -0.25,    ["Arci-marking-white-dl-diagonal-right"] = -0.25,
    ["Arci-marking-white-dl-straight-horizontal"] = -0.25,  ["Arci-marking-white-dl-diagonal-left"] = -0.25,
    ["Arci-marking-white-dl-right-turn-left"] = -0.25,      ["Arci-marking-white-dl-left-turn-left"] = -0.25,
    ["Arci-marking-white-dl-right-turn-down"] = -0.25,      ["Arci-marking-white-dl-left-turn-down"] = -0.25,
    ["Arci-marking-white-dl-right-turn-up"] = -0.25,        ["Arci-marking-white-dl-left-turn-up"] = -0.25,
    ["Arci-marking-white-dl-left-turn-right"] = -0.25,      ["Arci-marking-white-dl-right-turn-right"] = -0.25,
    ["Arci-marking-yellow-dl-straight-vertical"] = -0.25,   ["Arci-marking-yellow-dl-diagonal-right"] = -0.25,
    ["Arci-marking-yellow-dl-straight-horizontal"] = -0.25, ["Arci-marking-yellow-dl-diagonal-left"] = -0.25,
    ["Arci-marking-yellow-dl-right-turn-left"] = -0.25,     ["Arci-marking-yellow-dl-left-turn-left"] = -0.25,
    ["Arci-marking-yellow-dl-right-turn-down"] = -0.25,     ["Arci-marking-yellow-dl-left-turn-down"] = -0.25,
    ["Arci-marking-yellow-dl-right-turn-up"] = -0.25,       ["Arci-marking-yellow-dl-left-turn-up"] = -0.25,
    ["Arci-marking-yellow-dl-left-turn-right"] = -0.25,     ["Arci-marking-yellow-dl-right-turn-right"] = -0.25,    
    -- "Asphalt Roads" legacy mod tiles
    ["Arci-asphalt-marking-white-ns"] = 0.4, ["Arci-asphalt-marking-white-swne"] = 0.4,
    ["Arci-asphalt-marking-white-we"] = 0.4, ["Arci-asphalt-marking-white-nwse"] = 0.4,
    ["Arci-asphalt-marking-yellow-ns"] = 0.4, ["Arci-asphalt-marking-yellow-swne"] = 0.4,
    ["Arci-asphalt-marking-yellow-we"] = 0.4, ["Arci-asphalt-marking-yellow-nwse"] = 0.4,
    ["Arci-asphalt-marking-white-enw"] = 0.4, ["Arci-asphalt-marking-white-esw"] = 0.4,
    ["Arci-asphalt-marking-white-nsw"] = 0.4, ["Arci-asphalt-marking-white-nse"] = 0.4,
    ["Arci-asphalt-marking-white-sne"] = 0.4, ["Arci-asphalt-marking-white-snw"] = 0.4,
    ["Arci-asphalt-marking-white-wne"] = 0.4, ["Arci-asphalt-marking-white-wse"] = 0.4,
    ["Arci-asphalt-marking-yellow-enw"] = 0.4, ["Arci-asphalt-marking-yellow-esw"] = 0.4,
    ["Arci-asphalt-marking-yellow-nsw"] = 0.4, ["Arci-asphalt-marking-yellow-nse"] = 0.4,
    ["Arci-asphalt-marking-yellow-sne"] = 0.4, ["Arci-asphalt-marking-yellow-snw"] = 0.4,
    ["Arci-asphalt-marking-yellow-wne"] = 0.4, ["Arci-asphalt-marking-yellow-wse"] = 0.4,
    -- The following are 5dim mod tiles. 
	["5d-concrete-a"] = 1, ["5d-concrete-b"] = 1, ["5d-concrete-b2"] = 1, 
	["5d-concrete-m"] = 1, ["5d-concrete-r"] = 1, ["5d-concrete-v"] = 1, 
	-- The following are color-coding mod tiles,
	["concrete-red"] = 1, ["concrete-orange"] = 1, ["concrete-yellow"] = 1,
	["concrete-green"] = 1, ["concrete-cyan"] = 1, ["concrete-blue"] = 1, 
	["concrete-purple"] = 1, ["concrete-magenta"] = 1, ["concrete-white"] = 1,
	["concrete-black"] = 1, ["concrete-hazard-left"] = 1, ["concrete-hazard-right"] = 1,
	["concrete-fire-left"] = 1, ["concrete-fire-right"] = 1,
    -- The following are "Dectorio" mod tiles
    ["dect-wood-floor"] = 0.3, ["dect-gravel"] = 0.4, ["dect-paint-hazard"] = 0.2,
    ["dect-paint-danger"] = 0.2, ["dect-paint-emergency"] = 0.5, ["dect-paint-caution"] = 0.5,
    ["dect-paint-radiation"] = 0.5, ["dect-paint-defect"] = 0.5, ["dect-paint-operations"] = 0.5,
    ["dect-paint-safety"] = 0.5,    
    -- The following are "More-Floors" mod tiles
    ["smooth-concrete"] = 1, ["wood-floor"] = 0.3, ["reinforced-concrete"] = 1, 
    ["diamond-plate"] = 0.5, ["rusty-metal"] = 0.5, ["rusty-grate"] = 0.5, 
    ["arrow-grate"] = 1.25, ["arrow-grate-left"] = 1.25, ["arrow-grate-right"] = 1.25, 
    ["arrow-grate-down"] = 1.25, ["circuit-floor"] = 0.5, ["gravel"] = 0.4, 
    ["asphalt"] = 1.25, ["alien-metal"] = 0.5, ["metal-scraps"] = 0.5, 
    ["hexagonb"] = 0.5, ["fast-arrow-grate"] = 1.25, ["fast-arrow-grate-left"] = 1.25,
    ["fast-arrow-grate-right"] = 1.25, ["fast-arrow-grate-down"] = 1.25, ["express-arrow-grate"] = 1.25,
    ["express-arrow-grate-left"] = 1.25, ["express-arrow-grate-right"] = 1.25, ["express-arrow-grate-down"] = 1.25,
    ["yellowbrick"] = 0.5, ["mf-concrete-black"] = 1, ["mf-concrete-darkgrey"] = 1,
    ["mf-concrete-blue"] = 1, ["mf-concrete-gold"] = 1, ["mf-concrete-green"] = 1,
    ["mf-concrete-limegreen"] = 1, ["mf-concrete-orange"] = 1, ["mf-concrete-magenta"] = 1,
    ["mf-concrete-pink"] = 1, ["mf-concrete-purple"] = 1, ["mf-concrete-red"] = 1,
    ["mf-concrete-skyblue"] = 1, ["mf-concrete-white"] = 1, ["mf-concrete-yellow"] = 1,
    ["road-line"] = 0.4, ["road-line-down"] = 0.4, ["road-line-left"] = 0.4, 
    ["road-line-right"] = 0.4, ["redbrick"] = 0.5, ["decal1"] = 1,
    ["decal2"] = 1, ["decal3"] = 1, ["decal4"] = 1, 
}

-- List of mods that are incompatible to pavement drive assist and will cause mod deactivation.
mod_incompatibility_list = {}

-- This variable determines the number of players inserted into the player_in_vehicle list if a vehicle is entered. Set this to more than 1 to simulate multiple players at once, useful for testing how many players your server is able to support until severe FPS-drops emerge. 
benchmark_level = 1

-- Debugging flag. Setting to true will spam your console with debugging messages. 
debug = false
