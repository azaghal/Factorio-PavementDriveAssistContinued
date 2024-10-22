if settings.startup["PDA-setting-smart-roads-enabled"].value then
    data:extend({
            {
                type = "recipe",
                name = "pda-road-sign-speed-limit",
                enabled = false,
                ingredients = {
                    {type = "item", name = "constant-combinator", amount = 1},
                    {type = "item", name = "advanced-circuit", amount = 1}
                },
                results = {
                    {type = "item", name = "pda-road-sign-speed-limit", amount = 1}
                }
            },
            {
                type = "recipe",
                name = "pda-road-sign-speed-unlimit",
                enabled = false,
                ingredients = {
                    {type = "item", name = "pda-road-sign-speed-limit", amount = 1},
                },
                results = {
                    {type = "item", name="pda-road-sign-speed-unlimit", amount = 1 }
                }
            },
            {
                type = "recipe",
                name = "pda-road-sign-stop",
                enabled = false,
                ingredients = {
                    {type = "item", name = "pda-road-sign-speed-limit", amount = 1},
                },
                results = {
                    {type = "item", name = "pda-road-sign-stop", amount = 1}
                }
            },
            {
                type = "recipe",
                name = "pda-road-sensor",
                enabled = false,
                ingredients = {
                    {type = "item", name = "pda-road-sign-speed-limit", amount = 1},
                },
                results = {
                    {type = "item", name = "pda-road-sensor", amount = 1 }
                }
            },
    })
end
