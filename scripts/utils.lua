-- Copyright (c) 2016 sillyfly
-- Copyright (c) 2019 Arcitos, based on "Pavement-Drive-Assist" v.0.0.5 made by sillyfly.
-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.

local utils = {}

--- Converts meters per tick to kilometers per hour (used for GUI interaction).
--
-- @param mpt uint Value to convert (in m/t).
--
-- @return uint Converted value (in km/h).
--
function utils.mpt_to_kmph(mpt)
    return math.floor(mpt * 60 * 60 * 60 / 1000 + 0.5)
end


--- Converts kilometers per hour to meters per tick (used for GUI interaction).
--
-- @param mpt uint Value to convert (in km/h).
--
-- @return uint Converted value (in m/t).
--
function utils.kmph_to_mpt(kmph)
    return ((kmph * 1000) / 60 / 60 / 60)
end


return utils
