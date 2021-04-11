data:extend({
    {
        type = "recipe",
        name = "pda-road-sign-speed-limit",
        enabled = false,
        ingredients =
        {
            {"constant-combinator", 1},
            {"advanced-circuit", 1}
        },
        result = "pda-road-sign-speed-limit"
    },
    {
        type = "recipe",
        name = "pda-road-sign-speed-unlimit",
        enabled = false,
        ingredients =
        {
            {"pda-road-sign-speed-limit", 1},
        },
        result = "pda-road-sign-speed-unlimit"
    },
    {
        type = "recipe",
        name = "pda-road-sign-stop",
        enabled = false,
        ingredients =
        {
            {"pda-road-sign-speed-limit", 1},
        },
        result = "pda-road-sign-stop"
    },
    {
        type = "recipe",
        name = "pda-road-sensor",
        enabled = false,
        ingredients =
        {
            {"pda-road-sign-speed-limit", 1},
        },
        result = "pda-road-sensor"
    },
})