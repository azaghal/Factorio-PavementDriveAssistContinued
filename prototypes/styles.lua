local styles = data.raw["gui-style"].default

data:extend({
    {
        type = "font",
        name = "Arci-pda-font",
        from = "default-bold",
        size = 14
    },
})

styles["Arci-pda-gui-style"] = {
    type = "button_style",
    parent = "button",
    font = "Arci-pda-font",
    align = "center",
    maximal_width = 32,
    top_padding = 2,
    right_padding = 2,
    bottom_padding = 2,
    left_padding = 2,
}
