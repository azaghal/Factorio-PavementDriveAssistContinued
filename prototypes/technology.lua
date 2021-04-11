data:extend(
{
    {
        type = "technology",
        name = "Arci-pavement-drive-assistant",
        icon = "__PavementDriveAssist__/graphics/technology/tech-pda.png",
        icon_size = 128,
        prerequisites = {"automobilism", "robotics", "laser"},
        unit =
        {
            count = 250,
            ingredients =
            {
                {"science-pack-1", 2},
                {"science-pack-2", 1}
            },
        time = 30
        },
        -- no immediate effects. The tech is used as a flag for the mod code.
        effects =
        {
        },
        order = "e-b-a"	
    } 
}
)	