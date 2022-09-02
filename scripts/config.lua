-- Copyright (c) 2016 sillyfly
-- Copyright (c) 2019 Arcitos, based on work of sillyfly. Provided under MIT license. See license.txt for details.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


-- Advanced settings
-- =================

local config = {}


-- Debug configuration
-- ===================

-- This variable determines the number of players inserted into the player_in_vehicle list if a vehicle is entered. Set
-- this to more than 1 to simulate multiple players at once, useful for testing how many players your server is able to
-- support until severe FPS-drops emerge.
config.benchmark_level = 1

-- Debugging flag. Setting to true will spam your console with debugging messages.
config.debug = false


-- Static configuration
-- ====================

-- Vehicles that will not be supported by the driving assistant. This is tested against the name of the vehicle. All other vehicles will be supported.
-- example: {["car"] = true, ["tank"] = true}
config.vehicle_blacklist = {}

-- How many tiles ahead of location to start looking. Remember that most vehicles are 2x2, so this should be 1-2 preferably.
config.lookahead_start = 2

-- How many tiles ahead to look at. Setting this too larger values may cause lags, but increases precision.
config.lookahead_length = 4

-- Angle to look for tiles on each side. 1/24 (= 360/24 = 15 degrees) seems to work nicely.
config.lookangle = 1/24

-- Use 1/64 angles for better sprite orientation (@GotLag).
config.changeangle = 1/64

-- Maximum turning rate per scan. Multiplied with tick rate. WIP
-- config.max_changeangle = 1/128

-- Straight lookahead eccentricity (to avoid driving on the edge of a paved path)
config.eccent = 1

-- Adds to lookahead_start if vehicle is in highspeed mode.
config.hs_start_extension = 1

-- Adds to lookahead_length if vehicle is in highspeed mode.
config.hs_length_extension = 2

-- List of available tilesets, in (default) order of importance.
config.available_tilesets = {
    "asphalt",
    "refined-concrete",
    "concrete",
    "stone",
    "gravel",
    "wood",
    "road-marking",
    "ignore",
}

-- Default assignment of tilesets to tiles. Tiles without assignments are given zero score. Negative scores signal that
-- the tile should be avoided.
config.default_tile_assignments = {

        -- Base game.
        ["stone-path"] = "stone",
        ["concrete"] = "concrete",
        ["refined-concrete"] = "refined-concrete",
        ["hazard-concrete-left"] = "concrete",
        ["hazard-concrete-right"] = "concrete",
        ["refined-hazard-concrete-left"] = "refined-concrete",
        ["refined-hazard-concrete-right"] = "refined-concrete",

        -- "Asphalt Roads" mod.
        ["Arci-asphalt"] = "asphalt",
        ["Arci-asphalt-hazard-white-left"] = "asphalt",
        ["Arci-asphalt-hazard-white-right"] = "asphalt",
        ["Arci-asphalt-hazard-yellow-left"] = "asphalt",
        ["Arci-asphalt-hazard-yellow-right"] = "asphalt",
        ["Arci-asphalt-hazard-red-left"] = "asphalt",
        ["Arci-asphalt-hazard-red-right"] = "asphalt",
        ["Arci-asphalt-hazard-blue-left"] = "asphalt",
        ["Arci-asphalt-hazard-blue-right"] = "asphalt",
        ["Arci-asphalt-hazard-green-left"] = "asphalt",
        ["Arci-asphalt-hazard-green-right"] = "asphalt",
        ["Arci-asphalt-zebra-crossing-horizontal"] = "asphalt",
        ["Arci-asphalt-zebra-crossing-vertical"] = "asphalt",
        ["Arci-asphalt-triangle-white-up"] = "asphalt",
        ["Arci-asphalt-triangle-white-left"] = "asphalt",
        ["Arci-asphalt-triangle-white-down"] = "asphalt",
        ["Arci-asphalt-triangle-white-right"] = "asphalt",

        ["Arci-marking-white-straight-vertical"] = "road-marking",
        ["Arci-marking-white-diagonal-right"] = "road-marking",
        ["Arci-marking-white-straight-horizontal"] = "road-marking",
        ["Arci-marking-white-diagonal-left"] = "road-marking",
        ["Arci-marking-white-right-turn-left"] = "road-marking",
        ["Arci-marking-white-left-turn-left"] = "road-marking",
        ["Arci-marking-white-right-turn-down"] = "road-marking",
        ["Arci-marking-white-left-turn-down"] = "road-marking",
        ["Arci-marking-white-right-turn-up"] = "road-marking",
        ["Arci-marking-white-left-turn-up"] = "road-marking",
        ["Arci-marking-white-left-turn-right"] = "road-marking",
        ["Arci-marking-white-right-turn-right"] = "road-marking",
        ["Arci-marking-yellow-straight-vertical"] = "road-marking",
        ["Arci-marking-yellow-diagonal-right"] = "road-marking",
        ["Arci-marking-yellow-straight-horizontal"] = "road-marking",
        ["Arci-marking-yellow-diagonal-left"] = "road-marking",
        ["Arci-marking-yellow-right-turn-left"] = "road-marking",
        ["Arci-marking-yellow-left-turn-left"] = "road-marking",
        ["Arci-marking-yellow-right-turn-down"] = "road-marking",
        ["Arci-marking-yellow-left-turn-down"] = "road-marking",
        ["Arci-marking-yellow-right-turn-up"] = "road-marking",
        ["Arci-marking-yellow-left-turn-up"] = "road-marking",
        ["Arci-marking-yellow-left-turn-right"] = "road-marking",
        ["Arci-marking-yellow-right-turn-right"] = "road-marking",

        ["Arci-marking-white-dl-straight-vertical"] = "road-marking",
        ["Arci-marking-white-dl-diagonal-right"] = "road-marking",
        ["Arci-marking-white-dl-straight-horizontal"] = "road-marking",
        ["Arci-marking-white-dl-diagonal-left"] = "road-marking",
        ["Arci-marking-white-dl-right-turn-left"] = "road-marking",
        ["Arci-marking-white-dl-left-turn-left"] = "road-marking",
        ["Arci-marking-white-dl-right-turn-down"] = "road-marking",
        ["Arci-marking-white-dl-left-turn-down"] = "road-marking",
        ["Arci-marking-white-dl-right-turn-up"] = "road-marking",
        ["Arci-marking-white-dl-left-turn-up"] = "road-marking",
        ["Arci-marking-white-dl-left-turn-right"] = "road-marking",
        ["Arci-marking-white-dl-right-turn-right"] = "road-marking",
        ["Arci-marking-yellow-dl-straight-vertical"] = "road-marking",
        ["Arci-marking-yellow-dl-diagonal-right"] = "road-marking",
        ["Arci-marking-yellow-dl-straight-horizontal"] = "road-marking",
        ["Arci-marking-yellow-dl-diagonal-left"] = "road-marking",
        ["Arci-marking-yellow-dl-right-turn-left"] = "road-marking",
        ["Arci-marking-yellow-dl-left-turn-left"] = "road-marking",
        ["Arci-marking-yellow-dl-right-turn-down"] = "road-marking",
        ["Arci-marking-yellow-dl-left-turn-down"] = "road-marking",
        ["Arci-marking-yellow-dl-right-turn-up"] = "road-marking",
        ["Arci-marking-yellow-dl-left-turn-up"] = "road-marking",
        ["Arci-marking-yellow-dl-left-turn-right"] = "road-marking",
        ["Arci-marking-yellow-dl-right-turn-right"] = "road-marking",

        -- "5Dim" mod series.
        ["5d-concrete-a"] = "concrete",
        ["5d-concrete-b"] = "concrete",
        ["5d-concrete-b2"] = "concrete",
        ["5d-concrete-m"] = "concrete",
        ["5d-concrete-r"] = "concrete",
        ["5d-concrete-v"] = "concrete",

        -- "Color Coding" mod.
        ["concrete-red"] = "concrete",
        ["concrete-orange"] = "concrete",
        ["concrete-yellow"] = "concrete",
        ["concrete-green"] = "concrete",
        ["concrete-cyan"] = "concrete",
        ["concrete-blue"] = "concrete",
        ["concrete-purple"] = "concrete",
        ["concrete-magenta"] = "concrete",
        ["concrete-white"] = "concrete",
        ["concrete-black"] = "concrete",

        -- "Dectorio" mod.
        ["dect-wood-floor"] = "wood",
        ["dect-stone-gravel"] = "gravel",
        ["dect-iron-ore-gravel"] = "gravel",
        ["dect-copper-ore-gravel"] = "gravel",
        ["dect-coal-gravel"] = "gravel",
        ["dect-paint-hazard-left"] = "concrete",
        ["dect-paint-hazard-right"] = "concrete",
        ["dect-paint-danger-left"] = "concrete",
        ["dect-paint-danger-right"] = "concrete",
        ["dect-paint-emergency-left"] = "concrete",
        ["dect-paint-emergency-right"] = "concrete",
        ["dect-paint-caution-left"] = "concrete",
        ["dect-paint-caution-right"] = "concrete",
        ["dect-paint-radiation-left"] = "concrete",
        ["dect-paint-radiation-right"] = "concrete",
        ["dect-paint-defect-left"] = "concrete",
        ["dect-paint-defect-right"] = "concrete",
        ["dect-paint-operations-left"] = "concrete",
        ["dect-paint-operations-right"] = "concrete",
        ["dect-paint-safety-left"] = "concrete",
        ["dect-paint-safety-right"] = "concrete",
        ["dect-paint-refined-hazard-left"] = "refined-concrete",
        ["dect-paint-refined-hazard-right"] = "refined-concrete",
        ["dect-paint-refined-danger-left"] = "refined-concrete",
        ["dect-paint-refined-danger-right"] = "refined-concrete",
        ["dect-paint-refined-emergency-left"] = "refined-concrete",
        ["dect-paint-refined-emergency-right"] = "refined-concrete",
        ["dect-paint-refined-caution-left"] = "refined-concrete",
        ["dect-paint-refined-caution-right"] = "refined-concrete",
        ["dect-paint-refined-radiation-left"] = "refined-concrete",
        ["dect-paint-refined-radiation-right"] = "refined-concrete",
        ["dect-paint-refined-defect-left"] = "refined-concrete",
        ["dect-paint-refined-defect-right"] = "refined-concrete",
        ["dect-paint-refined-operations-left"] = "refined-concrete",
        ["dect-paint-refined-operations-right"] = "refined-concrete",
        ["dect-paint-refined-safety-left"] = "refined-concrete",
        ["dect-paint-refined-safety-right"] = "refined-concrete",
        ["dect-concrete-grid"] = "concrete",

        -- "Extra Floors" mod.
        ["smooth-concrete"] = "concrete",
        ["wood-floor"] = "wood",
        ["reinforced-concrete"] = "refined-concrete",
        ["diamond-plate"] = "stone",
        ["rusty-metal"] = "stone",
        ["rusty-grate"] = "stone",
        ["arrow-grate"] = "refined-concrete",
        ["arrow-grate-left"] = "refined-concrete",
        ["arrow-grate-right"] = "refined-concrete",
        ["arrow-grate-down"] = "refined-concrete",
        ["circuit-floor"] = "stone",
        ["gravel"] = "gravel",
        ["asphalt"] = "asphalt",
        ["alien-metal"] = "stone",
        ["metal-scraps"] = "stone",
        ["hexagonb"] = "stone",
        ["fast-arrow-grate"] = "refined-concrete",
        ["fast-arrow-grate-left"] = "refined-concrete",
        ["fast-arrow-grate-right"] = "refined-concrete",
        ["fast-arrow-grate-down"] = "refined-concrete",
        ["express-arrow-grate"] = "refined-concrete",
        ["express-arrow-grate-left"] = "refined-concrete",
        ["express-arrow-grate-right"] = "refined-concrete",
        ["express-arrow-grate-down"] = "refined-concrete",
        ["yellowbrick"] = "stone",
        ["mf-concrete-black"] = "concrete",
        ["mf-concrete-darkgrey"] = "concrete",
        ["mf-concrete-blue"] = "concrete",
        ["mf-concrete-gold"] = "concrete",
        ["mf-concrete-green"] = "concrete",
        ["mf-concrete-limegreen"] = "concrete",
        ["mf-concrete-orange"] = "concrete",
        ["mf-concrete-magenta"] = "concrete",
        ["mf-concrete-pink"] = "concrete",
        ["mf-concrete-purple"] = "concrete",
        ["mf-concrete-red"] = "concrete",
        ["mf-concrete-skyblue"] = "concrete",
        ["mf-concrete-white"] = "concrete",
        ["mf-concrete-yellow"] = "concrete",
        ["road-line"] = "road-marking",
        ["road-line-down"] = "road-marking",
        ["road-line-left"] = "road-marking",
        ["road-line-right"] = "road-marking",
        ["redbrick"] = "stone",
        ["decal1"] = "concrete",
        ["decal2"] = "concrete",
        ["decal3"] = "concrete",
        ["decal4"] = "concrete",

        -- "Angel's Smelting" mod.
        ["clay-bricks"] = "stone",

        -- "Krastorio 2" mod.
        ["kr-white-reinforced-plate"] = "asphalt",
        ["kr-black-reinforced-plate"] = "asphalt",
        ["kr-white-reinforced-plate-l"] = "asphalt",
        ["kr-black-reinforced-plate-l"] = "asphalt",

        -- "AAI Industries" mod.
        ["rough-stone-path"] = "gravel",

        -- "Transport Drones" mod.
        ["transport-drone-road"] = "stone",
        ["transport-drone-road-better"] = "asphalt",
}


-- Dynamic configuration
-- =====================

-- Tiles assigned to each tileset. Maps tileset names to list of tile names.
config.tilesets = {}

-- Scores assigned to tilesets. Maps tileset names to score values.
config.tileset_scores = {}

-- Scores assigned to each tile. Maps tile names to score values.
config.tile_scores = {}


--- Updates dynamic configuration (dependant on mod settings).
--
-- Recalculates the following properties:
--
--   - config.tilesets
--   - config.tileset_scores
--   - config.tile_scores
--
function config.update()

    -- Clear the current configuration.
    config.tilesets = {}
    config.tileset_scores = {}
    config.tile_scores = {}

    -- Initialise tilset lists.
    for _, tileset in pairs(config.available_tilesets) do
        config.tilesets[tileset] = {}
    end

    -- Read the tileset scores from mod settings.
    config.tileset_score = {
        ["asphalt"] = settings.global["PDA-tileset-score-asphalt"].value,
        ["refined-concrete"] = settings.global["PDA-tileset-score-refined-concrete"].value,
        ["concrete"] = settings.global["PDA-tileset-score-concrete"].value,
        ["stone"] = settings.global["PDA-tileset-score-stone"].value,
        ["gravel"] = settings.global["PDA-tileset-score-gravel"].value,
        ["wood"] = settings.global["PDA-tileset-score-wood"].value,
        ["road-markings"] = settings.global["PDA-tileset-score-asphalt-road-lines"].value,
    }

    -- Calculate tileset lists and individual tile scores.
    for tile, tileset in pairs(config.default_tile_assignments) do
        config.tile_scores[tile] = config.tileset_score[tileset]
        table.insert(config.tilesets[tileset], tile)
    end

    -- Sort the tiles in tilesets (useful for command outputs).
    for tilset, tiles in pairs(config.tilesets) do
        table.sort(tiles, function(a, b) return a:upper() < b:upper() end)
    end
end


return config
