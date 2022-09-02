data:extend({
        -- Startup settings
        -- ================
        {
            type = "bool-setting",
            name = "PDA-setting-tech-required",
            setting_type = "startup",
            default_value = true,
            order = "aa",
        },
        {
            type = "bool-setting",
            name = "PDA-setting-smart-roads-enabled",
            setting_type = "startup",
            default_value = true,
            order = "ab",
        },

        -- Map settings
        -- ============
        {
            type = "bool-setting",
            name = "PDA-setting-allow-cruise-control",
            setting_type = "runtime-global",
            default_value = true,
            order = "b",
        },
        {
            type = "int-setting",
            name = "PDA-setting-tick-rate",
            setting_type = "runtime-global",
            default_value = 2,
            allowed_values = { 1, 2, 3, 4, 5, 6, 8, 10, 12 },
            order = "c",
        },
        {
            type = "int-setting",
            name = "PDA-setting-assist-min-speed",
            setting_type = "runtime-global",
            default_value = 20,
            minimum_value = 6,
            maximum_value = 10000,
            order = "d",
        },
        {
            type = "int-setting",
            name = "PDA-setting-assist-high-speed",
            setting_type = "runtime-global",
            default_value = 100,
            minimum_value = 50,
            maximum_value = 10000,
            order = "e",
        },
        {
            type = "int-setting",
            name = "PDA-setting-game-max-speed",
            setting_type = "runtime-global",
            default_value = 0,
            minimum_value = 0,
            maximum_value = 10000,
            order = "f",
        },
        {
            type = "int-setting",
            name = "PDA-setting-server-limit-sign-speed",
            setting_type = "runtime-global",
            default_value = 60,
            minimum_value = 0,
            maximum_value = 10000,
            order = "g",
        },

        -- Tileset scores.
        {
            type = "double-setting",
            name = "PDA-tileset-score-asphalt",
            setting_type = "runtime-global",
            default_value = 1.5,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-a",
        },
        {
            type = "double-setting",
            name = "PDA-tileset-score-refined-concrete",
            setting_type = "runtime-global",
            default_value = 1.25,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-b",
        },
        {
            type = "double-setting",
            name = "PDA-tileset-score-concrete",
            setting_type = "runtime-global",
            default_value = 1.00,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-c",
        },
        {
            type = "double-setting",
            name = "PDA-tileset-score-stone",
            setting_type = "runtime-global",
            default_value = 0.6,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-d",
        },
        {
            type = "double-setting",
            name = "PDA-tileset-score-gravel",
            setting_type = "runtime-global",
            default_value = 0.4,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-e",
        },
        {
            type = "double-setting",
            name = "PDA-tileset-score-wood",
            setting_type = "runtime-global",
            default_value = 0.3,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-f",
        },
        {
            type = "double-setting",
            name = "PDA-tileset-score-asphalt-road-lines",
            setting_type = "runtime-global",
            default_value = 0.4,
            minimum_value = -2,
            maximum_value = 2,
            order = "h-g",
        },

        -- Tileset overrides.
        {
            type = "string-setting",
            name = "PDA-tileset-override-asphalt",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-a"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-refined-concrete",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-b"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-concrete",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-c"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-stone",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-d"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-gravel",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-e"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-wood",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-f"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-road-marking",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-g"
        },
        {
            type = "string-setting",
            name = "PDA-tileset-override-unassigned",
            setting_type = "runtime-global",
            default_value = "",
            allow_blank = true,
            order = "i-h"
        },

        -- Per-player settings
        -- ===================
        {
            type = "bool-setting",
            name = "PDA-setting-verbose",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "a",
        },
        {
            type = "bool-setting",
            name = "PDA-setting-sound-alert",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "b",
        },
        {
            type = "bool-setting",
            name = "PDA-setting-alt-toggle-mode",
            setting_type = "runtime-per-user",
            default_value = true,
            order = "c",
        },
        {
            type = "int-setting",
            name = "PDA-setting-personal-limit-sign-speed",
            setting_type = "runtime-per-user",
            default_value = 60,
            minimum_value = 0,
            maximum_value = 10000,
            order = "d",
        }
})
