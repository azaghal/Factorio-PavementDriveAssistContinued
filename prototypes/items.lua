data:extend({
    {
        type = "item",
        name = "pda-road-sign-speed-limit",
        icon = "__PavementDriveAssist__/graphics/icons/icon_speed_limit.png",
        icon_size = 32,
        flags = { "goes-to-quickbar" },
        subgroup = "circuit-network",
        place_result="pda-road-sign-speed-limit",
        order = "d[other]-c[programmable-speaker]",
        stack_size= 50,
    },
    {
        type = "item",
        name = "pda-road-sign-speed-unlimit",
        icon = "__PavementDriveAssist__/graphics/icons/icon_speed_unlimit.png",
        icon_size = 32,        
        flags = { "goes-to-quickbar" },
        subgroup = "circuit-network",
        place_result="pda-road-sign-speed-unlimit",
        order = "d[other]-d[pda-road-sign-speed-limit]",
        stack_size= 50,
    },
})