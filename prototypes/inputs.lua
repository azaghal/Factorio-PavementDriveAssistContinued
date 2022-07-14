data:extend({
    {
        type = "custom-input",
        name = "toggle_drive_assistant",
        key_sequence = "I",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "toggle_cruise_control",
        key_sequence = "O",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "set_cruise_control_limit",
        key_sequence = "CONTROL + O",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "confirm_set_cruise_control_limit",
        key_sequence = "",
        linked_game_control = "confirm-gui"
    },
})
