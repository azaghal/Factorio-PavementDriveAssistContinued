data:extend({
        {
            type = "shortcut",
            name = "pda-cruise-control-toggle",
            associated_control_input = "toggle_cruise_control",
            order = "a",
            action = "lua",
            localised_name = {"controls.toggle_cruise_control"},
            toggleable = true,
            icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/cc-32px.png",
                priority = "extra-high-no-scale",
                size = 32,
                scale = 1,
                flags = {"icon"}
            },
            small_icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/cc-24px.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 1,
                flags = {"icon"}
            },
            disabled_small_icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/cc-24px-white.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 1,
                flags = {"icon"}
            },
        },
        {
            type = "shortcut",
            name = "pda-set-cruise-control-limit",
            associated_control_input = "set_cruise_control_limit",
            order = "a",
            action = "lua",
            localised_name = {"controls.set_cruise_control_limit"},
            style = "green",
            icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/set-cc-32px-white.png",
                priority = "extra-high-no-scale",
                size = 32,
                scale = 1,
                flags = {"icon"}
            },
            small_icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/cc-24px.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 1,
                flags = {"icon"}
            },
            disabled_small_icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/cc-24px-white.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 1,
                flags = {"icon"}
            },
        },
        {
            type = "shortcut",
            name = "pda-drive-assistant-toggle",
            associated_control_input = "toggle_drive_assistant",
            order = "a",
            action = "lua",
            localised_name = {"controls.toggle_drive_assistant"},
            toggleable = true,
            icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/pda-32px.png",
                priority = "extra-high-no-scale",
                size = 32,
                scale = 1,
                flags = {"icon"}
            },
            small_icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/pda-24px.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 1,
                flags = {"icon"}
            },
            disabled_small_icon = {
                filename = "__PavementDriveAssistContinued__/graphics/shortcuts/pda-24px-white.png",
                priority = "extra-high-no-scale",
                size = 24,
                scale = 1,
                flags = {"icon"}
            },
        },
})
