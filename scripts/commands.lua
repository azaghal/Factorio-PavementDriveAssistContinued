-- Copyright (c) 2022 Branko Majic
-- Provided under MIT license. See LICENSE for details.


local pda = require("scripts.pda")


local commands = {}


commands.list_tilesets = {}
commands.list_tilesets.name = "pda-list-tilesets"
commands.list_tilesets.help = [[
Lists available tilesets. Useful for figuring out what name to pass into the /pda-show-tileset command.
Usage:
    /pda-list-tilesets
]]


--- Parses the passed-in player parameters and lists the tilesets.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.list_tilesets.func = function(command_data)
    local player = game.players[command_data.player_index]

    pda.list_tilesets(player)
end


commands.show_tileset = {}
commands.show_tileset.name = "pda-show-tileset"
commands.show_tileset.help = [[
Lists tiles assigned to passed-in tileset. Only tiles available in current game are shown.
Usage:
    /pda-show-tileset TILESET
Parameters:
    TILESET
        Tilset for which to show the information.
]]


--- Parses the passed-in player parameters and shows tileset information.
--
-- @param command_data CustomCommandData Command data structure passed-in by the game engine.
--
commands.show_tileset.func = function(command_data)
    local player = game.players[command_data.player_index]

    if not command_data.parameter then
        player.print(commands.show_tileset.help)
        return
    end

    pda.show_tileset(player, command_data.parameter)
end


return commands
