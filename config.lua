-- Copyright (2016) sillyfly. Provided under MIT license. See license.txt for details. 

-- How many tiles ahead of location to start looking. Remember that most vehicles are 2x2, so this should be 1-2 preferably.
lookahead_start = 2

-- How many tiles ahead to look at. Setting too large a value may cause lags
lookahead_length = 4

-- Angle to look for tiles on each side. 1/24 (= 360/24 = 15 degrees) seeme to work nicely. 
lookangle = 1/24

-- Use 1/64 angles for better sprite orientation (@GotLag)
changeangle = 1/64

-- Straight lookahead eccentricity (to avoid driving on the edge of a paved path)
eccent = 1

-- Score for each tile type. Tiles not included will be given zero score. Negative scores mean try to avoid this type of tile. 
scores = {
	-- These are the tiles in the base game. Concrete gets a higher scores for roads with a middle concrete part and 
	-- outer stone bricks. 
	["stone-path"] = 0.5, ["concrete"] = 1, 
	-- The following are 5dim mod tiles. 
	["5d-concrete-a"] = 1, ["5d-concrete-b"] = 1, ["5d-concrete-b2"] = 1, 
	["5d-concrete-m"] = 1, ["5d-concrete-r"] = 1, ["5d-concrete-v"] = 1, 
	-- The following are color-coding mod tiles,
	["concrete-red"] = 1, ["concrete-orange"] = 1, ["concrete-yellow"] = 1,
	["concrete-green"] = 1, ["concrete-cyan"] = 1, ["concrete-blue"] = 1, 
	["concrete-purple"] = 1, ["concrete-magenta"] = 1, ["concrete-white"] = 1,
	["concrete-black"] = 1, ["concrete-hazard-left"] = 1, ["concrete-hazard-right"] = 1,
	["concrete-fire-left"] = 1, ["concrete-fire-right"] = 1    
}

-- Vehicles to assist in the driving of. This is tested against the name of the vehicle. 
vehicles = {["car"]=true, ["tank"] = true}

-- Minimum speed to start assisting in. This is in tiles/tick. Multiply by 216 to get km/h. 
minspeed = 0.1

-- Debugging flag. Setting to true will spam your console with debugging messages. 
debug=false
