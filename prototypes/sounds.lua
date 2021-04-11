data:extend({
	{
		type = "explosion",
		name = "pda-warning-1",
		flags = {"not-on-map"},
		animations =
		{
			{
				filename = "__PavementDriveAssist__/graphics/sound/dummy.png",
				priority = "low",
				width = 32,
				height = 32,
				frame_count = 1,
				line_length = 1,
				animation_speed = 1
			},
		},
		light = {intensity = 0, size = 0},
		sound =
		{
		{
			filename = "__PavementDriveAssist__/sound/pda_warning_1.ogg",
			volume = 0.5
		},
		},
	}
})