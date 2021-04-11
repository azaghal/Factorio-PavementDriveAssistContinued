-- GUI Settings inspired by GotLags "Renamer"

require("prototypes.technology")
require("prototypes.sounds")
require("prototypes.entity")
require("prototypes.items")
require("prototypes.recipe")

data:extend({
    {
        type = "custom-input",
        name = "toggle_drive_assistant",
        key_sequence = "I",
        consuming = "all"
    },
    {
        type = "custom-input",
        name = "toggle_cruise_control",
        key_sequence = "O",
        consuming = "all"
    },
    {
        type = "custom-input",
        name = "set_cruise_control_limit",
        key_sequence = "CONTROL + O",
        consuming = "all"
    },
    {
        type = "font",
        name = "Arci-pda-font",
        from = "default-bold",
        size = 14
    }
})

data.raw["gui-style"].default["Arci-pda-gui-style"] =
{
	type = "button_style",
	parent = "button",
	font = "Arci-pda-font",
	align = "center",
	maximal_width = 32,
    top_padding = 2,
    right_padding = 2,
    bottom_padding = 2,
    left_padding = 2,
	--default_font_color = {r = 1, g = 0.707, b = 0.12},
	--hovered_font_color = {r = 1, g = 1, b = 1},
	--clicked_font_color = {r = 1, g = 0.707, b = 0.12}
}
