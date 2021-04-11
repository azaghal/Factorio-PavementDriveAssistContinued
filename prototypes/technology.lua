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
            count = 175,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
        time = 30
        },
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "pda-road-sign-speed-limit"
            },
            {
                type = "unlock-recipe",
                recipe = "pda-road-sign-speed-unlimit"
            },
        },
        order = "e-b-a"	
    } 
}
)	