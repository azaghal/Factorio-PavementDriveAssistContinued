-- Copyright (c) 2016 sillyfly
-- Copyright (c) 2019 Arcitos, based on work of sillyfly. Provided under MIT license. See license.txt for details.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

-- Advanced settings
-- =================

local config = {}

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

local scores_values = {
    asphalt = settings.global["PDA-tileset-score-asphalt"].value,
    ref_concrete = settings.global["PDA-tileset-score-refined-concrete"].value,
    concrete = settings.global["PDA-tileset-score-concrete"].value,
    stone = settings.global["PDA-tileset-score-stone"].value,
    gravel = settings.global["PDA-tileset-score-gravel"].value,
    wood = settings.global["PDA-tileset-score-wood"].value,
    road_lines = settings.global["PDA-tileset-score-asphalt-road-lines"].value,
}

local scores = {}

function config.set_scores()
    scores = {
        -- Score for each tile type. Tiles not included will be given zero score. Negative scores: try to avoid this type of tile.
        -- If you want to customize/override the tile scores, just replace the value/scores_value reference

        -- These are the tiles in the base game.
        ["stone-path"] = scores_values.stone,
        ["concrete"] = scores_values.concrete,
        ["refined-concrete"] = scores_values.ref_concrete,
        ["hazard-concrete-left"] = scores_values.concrete,
        ["hazard-concrete-right"] = scores_values.concrete,
        ["refined-hazard-concrete-left"] = scores_values.ref_concrete,
        ["refined-hazard-concrete-right"] = scores_values.ref_concrete,

        -- "Asphalt Roads" mod tiles. Vehicles will try to not cross lane marking tiles and avoid red hazard zones.
        ["Arci-asphalt"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-white-left"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-white-right"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-yellow-left"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-yellow-right"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-red-left"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-red-right"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-blue-left"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-blue-right"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-green-left"] = scores_values.asphalt,
        ["Arci-asphalt-hazard-green-right"] = scores_values.asphalt,
        ["Arci-asphalt-zebra-crossing-horizontal"] = scores_values.asphalt,
        ["Arci-asphalt-zebra-crossing-vertical"] = scores_values.asphalt,
        ["Arci-asphalt-triangle-white-up"] = scores_values.asphalt,
        ["Arci-asphalt-triangle-white-left"] = scores_values.asphalt,
        ["Arci-asphalt-triangle-white-down"] = scores_values.asphalt,
        ["Arci-asphalt-triangle-white-right"] = scores_values.asphalt,

        ["Arci-marking-white-straight-vertical"] = scores_values.road_lines,
        ["Arci-marking-white-diagonal-right"] = scores_values.road_lines,
        ["Arci-marking-white-straight-horizontal"] = scores_values.road_lines,
        ["Arci-marking-white-diagonal-left"] = scores_values.road_lines,
        ["Arci-marking-white-right-turn-left"] = scores_values.road_lines,
        ["Arci-marking-white-left-turn-left"] = scores_values.road_lines,
        ["Arci-marking-white-right-turn-down"] = scores_values.road_lines,
        ["Arci-marking-white-left-turn-down"] = scores_values.road_lines,
        ["Arci-marking-white-right-turn-up"] = scores_values.road_lines,
        ["Arci-marking-white-left-turn-up"] = scores_values.road_lines,
        ["Arci-marking-white-left-turn-right"] = scores_values.road_lines,
        ["Arci-marking-white-right-turn-right"] = scores_values.road_lines,
        ["Arci-marking-yellow-straight-vertical"] = scores_values.road_lines,
        ["Arci-marking-yellow-diagonal-right"] = scores_values.road_lines,
        ["Arci-marking-yellow-straight-horizontal"] = scores_values.road_lines,
        ["Arci-marking-yellow-diagonal-left"] = scores_values.road_lines,
        ["Arci-marking-yellow-right-turn-left"] = scores_values.road_lines,
        ["Arci-marking-yellow-left-turn-left"] = scores_values.road_lines,
        ["Arci-marking-yellow-right-turn-down"] = scores_values.road_lines,
        ["Arci-marking-yellow-left-turn-down"] = scores_values.road_lines,
        ["Arci-marking-yellow-right-turn-up"] = scores_values.road_lines,
        ["Arci-marking-yellow-left-turn-up"] = scores_values.road_lines,
        ["Arci-marking-yellow-left-turn-right"] = scores_values.road_lines,
        ["Arci-marking-yellow-right-turn-right"] = scores_values.road_lines,

        ["Arci-marking-white-dl-straight-vertical"] = scores_values.road_lines,
        ["Arci-marking-white-dl-diagonal-right"] = scores_values.road_lines,
        ["Arci-marking-white-dl-straight-horizontal"] = scores_values.road_lines,
        ["Arci-marking-white-dl-diagonal-left"] = scores_values.road_lines,
        ["Arci-marking-white-dl-right-turn-left"] = scores_values.road_lines,
        ["Arci-marking-white-dl-left-turn-left"] = scores_values.road_lines,
        ["Arci-marking-white-dl-right-turn-down"] = scores_values.road_lines,
        ["Arci-marking-white-dl-left-turn-down"] = scores_values.road_lines,
        ["Arci-marking-white-dl-right-turn-up"] = scores_values.road_lines,
        ["Arci-marking-white-dl-left-turn-up"] = scores_values.road_lines,
        ["Arci-marking-white-dl-left-turn-right"] = scores_values.road_lines,
        ["Arci-marking-white-dl-right-turn-right"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-straight-vertical"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-diagonal-right"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-straight-horizontal"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-diagonal-left"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-right-turn-left"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-left-turn-left"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-right-turn-down"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-left-turn-down"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-right-turn-up"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-left-turn-up"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-left-turn-right"] = scores_values.road_lines,
        ["Arci-marking-yellow-dl-right-turn-right"] = scores_values.road_lines,

        -- The following are 5dim mod tiles.
        ["5d-concrete-a"] = scores_values.concrete,
        ["5d-concrete-b"] = scores_values.concrete,
        ["5d-concrete-b2"] = scores_values.concrete,
        ["5d-concrete-m"] = scores_values.concrete,
        ["5d-concrete-r"] = scores_values.concrete,
        ["5d-concrete-v"] = scores_values.concrete,

        -- The following are color-coding mod tiles,
        ["concrete-red"] = scores_values.concrete,
        ["concrete-orange"] = scores_values.concrete,
        ["concrete-yellow"] = scores_values.concrete,
        ["concrete-green"] = scores_values.concrete,
        ["concrete-cyan"] = scores_values.concrete,
        ["concrete-blue"] = scores_values.concrete,
        ["concrete-purple"] = scores_values.concrete,
        ["concrete-magenta"] = scores_values.concrete,
        ["concrete-white"] = scores_values.concrete,
        ["concrete-black"] = scores_values.concrete,

        -- The following are "Dectorio" mod tiles
        ["dect-wood-floor"] = scores_values.wood,
        ["dect-stone-gravel"] = scores_values.gravel,
        ["dect-iron-ore-gravel"] = scores_values.gravel,
        ["dect-copper-ore-gravel"] = scores_values.gravel,
        ["dect-coal-gravel"] = scores_values.gravel,
        ["dect-paint-hazard-left"] = scores_values.concrete,
        ["dect-paint-hazard-right"] = scores_values.concrete,
        ["dect-paint-danger-left"] = scores_values.concrete,
        ["dect-paint-danger-right"] = scores_values.concrete,
        ["dect-paint-emergency-left"] = scores_values.concrete,
        ["dect-paint-emergency-right"] = scores_values.concrete,
        ["dect-paint-caution-left"] = scores_values.concrete,
        ["dect-paint-caution-right"] = scores_values.concrete,
        ["dect-paint-radiation-left"] = scores_values.concrete,
        ["dect-paint-radiation-right"] = scores_values.concrete,
        ["dect-paint-defect-left"] = scores_values.concrete,
        ["dect-paint-defect-right"] = scores_values.concrete,
        ["dect-paint-operations-left"] = scores_values.concrete,
        ["dect-paint-operations-right"] = scores_values.concrete,
        ["dect-paint-safety-left"] = scores_values.concrete,
        ["dect-paint-safety-right"] = scores_values.concrete,
        ["dect-paint-refined-hazard-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-hazard-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-danger-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-danger-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-emergency-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-emergency-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-caution-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-caution-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-radiation-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-radiation-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-defect-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-defect-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-operations-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-operations-right"] = scores_values.ref_concrete,
        ["dect-paint-refined-safety-left"] = scores_values.ref_concrete,
        ["dect-paint-refined-safety-right"] = scores_values.ref_concrete,
        ["dect-concrete-grid"] = scores_values.concrete,

        -- The following are "More-Floors" mod tiles
        ["smooth-concrete"] = scores_values.concrete,
        ["wood-floor"] = scores_values.wood,
        ["reinforced-concrete"] = scores_values.ref_concrete,
        ["diamond-plate"] = scores_values.stone,
        ["rusty-metal"] = scores_values.stone,
        ["rusty-grate"] = scores_values.stone,
        ["arrow-grate"] = scores_values.ref_concrete,
        ["arrow-grate-left"] = scores_values.ref_concrete,
        ["arrow-grate-right"] = scores_values.ref_concrete,
        ["arrow-grate-down"] = scores_values.ref_concrete,
        ["circuit-floor"] = scores_values.stone,
        ["gravel"] = scores_values.gravel,
        ["asphalt"] = scores_values.asphalt,
        ["alien-metal"] = scores_values.stone,
        ["metal-scraps"] = scores_values.stone,
        ["hexagonb"] = scores_values.stone,
        ["fast-arrow-grate"] = scores_values.ref_concrete,
        ["fast-arrow-grate-left"] = scores_values.ref_concrete,
        ["fast-arrow-grate-right"] = scores_values.ref_concrete,
        ["fast-arrow-grate-down"] = scores_values.ref_concrete,
        ["express-arrow-grate"] = scores_values.ref_concrete,
        ["express-arrow-grate-left"] = scores_values.ref_concrete,
        ["express-arrow-grate-right"] = scores_values.ref_concrete,
        ["express-arrow-grate-down"] = scores_values.ref_concrete,
        ["yellowbrick"] = scores_values.stone,
        ["mf-concrete-black"] = scores_values.concrete,
        ["mf-concrete-darkgrey"] = scores_values.concrete,
        ["mf-concrete-blue"] = scores_values.concrete,
        ["mf-concrete-gold"] = scores_values.concrete,
        ["mf-concrete-green"] = scores_values.concrete,
        ["mf-concrete-limegreen"] = scores_values.concrete,
        ["mf-concrete-orange"] = scores_values.concrete,
        ["mf-concrete-magenta"] = scores_values.concrete,
        ["mf-concrete-pink"] = scores_values.concrete,
        ["mf-concrete-purple"] = scores_values.concrete,
        ["mf-concrete-red"] = scores_values.concrete,
        ["mf-concrete-skyblue"] = scores_values.concrete,
        ["mf-concrete-white"] = scores_values.concrete,
        ["mf-concrete-yellow"] = scores_values.concrete,
        ["road-line"] = scores_values.road_lines,
        ["road-line-down"] = scores_values.road_lines,
        ["road-line-left"] = scores_values.road_lines,
        ["road-line-right"] = scores_values.road_lines,
        ["redbrick"] = scores_values.stone,
        ["decal1"] = scores_values.concrete,
        ["decal2"] = scores_values.concrete,
        ["decal3"] = scores_values.concrete,
        ["decal4"] = scores_values.concrete,

        -- the following are tile from angels smelting
        ["clay-bricks"] = scores_values.stone,

        -- Krastorio 2
        ["kr-white-reinforced-plate"] = scores_values.asphalt,
        ["kr-black-reinforced-plate"] = scores_values.asphalt,
        ["kr-white-reinforced-plate-l"] = scores_values.asphalt,
        ["kr-black-reinforced-plate-l"] = scores_values.asphalt,

        -- AAI Industries.
        ["rough-stone-path"] = scores_values.gravel,

        -- Transport Drones.
        ["transport-drone-road"] = scores_values.stone,
        ["transport-drone-road-better"] = scores_values.asphalt
    }
end

function config.get_scores()
    if #scores == 0 then
        config.set_scores()
    end
    return scores
end

function config.update_scores()
    scores_values = {
        asphalt = settings.global["PDA-tileset-score-asphalt"].value,
        ref_concrete = settings.global["PDA-tileset-score-refined-concrete"].value,
        concrete = settings.global["PDA-tileset-score-concrete"].value,
        stone = settings.global["PDA-tileset-score-stone"].value,
        gravel = settings.global["PDA-tileset-score-gravel"].value,
        wood = settings.global["PDA-tileset-score-wood"].value,
        road_lines = settings.global["PDA-tileset-score-asphalt-road-lines"].value
    }
    config.set_scores()
    return scores
end

-- This variable determines the number of players inserted into the player_in_vehicle list if a vehicle is entered. Set this to more than 1 to simulate multiple players at once, useful for testing how many players your server is able to support until severe FPS-drops emerge.
config.benchmark_level = 1

-- Debugging flag. Setting to true will spam your console with debugging messages.
config.debug = false

return config
