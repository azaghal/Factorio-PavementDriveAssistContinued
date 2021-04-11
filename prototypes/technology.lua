data:extend(
{
    {
        type = "technology",
        name = "Arci-pavement-drive-assistant",
        icon = "__PavementDriveAssist__/graphics/technology/tech-pda.png",
        icon_size = 128,
        prerequisites = {"automobilism"},
        unit =
        {
            count = 120,
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
                type = "nothing",
                effect_description  = {"pda-effect-description-pda"}
            },
            {
                type = "nothing",
                effect_description  = {"pda-effect-description-cc"}
            },
        },
        order = "e-b-a"
    },
    {
        type = "technology",
        name = "Arci-smart-road",
        icon = "__PavementDriveAssist__/graphics/technology/smart-road.png",
        icon_size = 128,
        prerequisites = {"Arci-pavement-drive-assistant", "robotics", "laser", "circuit-network"},
        unit =
        {
            count = 150,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1}
            },
        time = 60
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
            {
                type = "unlock-recipe",
                recipe = "pda-road-sign-stop"
            },
            {
                type = "unlock-recipe",
                recipe = "pda-road-sensor"
            }
        },
        order = "e-b-b"
    }
}
)
