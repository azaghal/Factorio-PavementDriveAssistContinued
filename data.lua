require("prototypes.technology")
require("prototypes.sounds")

data:extend({
    {
        type = "custom-input",
        name = "toggle_drive_assistant",
        key_sequence = "K",
        consuming = "all"
    },
    {
        type = "custom-input",
        name = "toggle_cruise_control",
        key_sequence = "L",
        consuming = "all"
    }
})