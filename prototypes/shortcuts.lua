local tech = "Arci-pavement-drive-assistant"
--[[
if settings.global["PDA-setting-tech-required"].value then
	tech = "Arci-pavement-drive-assistant"
end]]

data:extend({
	{
		type = "shortcut",
		name = "pda-cruise-control-toggle",
		order = "a",
		action = "lua",
		localised_name = {"controls.toggle_cruise_control"},
		technology_to_unlock = tech,
		toggleable = true,
		icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/cc-32px.png",
			priority = "extra-high-no-scale",
			size = 32,
			scale = 1,
			flags = {"icon"}
		},
		small_icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/cc-24px.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
		disabled_small_icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/cc-24px-white.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
	},
	{
		type = "shortcut",
		name = "pda-set-cruise-control-limit",
		order = "a",
		action = "lua",
		localised_name = {"controls.set_cruise_control_limit"},
		technology_to_unlock = tech,
		style = "green",
		icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/set-cc-32px-white.png",
			priority = "extra-high-no-scale",
			size = 32,
			scale = 1,
			flags = {"icon"}
		},
		small_icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/cc-24px.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
		disabled_small_icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/cc-24px-white.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
	},
	{
		type = "shortcut",
		name = "pda-drive-assistant-toggle",
		order = "a",
		action = "lua",
		localised_name = {"controls.toggle_drive_assistant"},
		technology_to_unlock = tech,
		toggleable = true,
		icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/pda-32px.png",
			priority = "extra-high-no-scale",
			size = 32,
			scale = 1,
			flags = {"icon"}
		},
		small_icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/pda-24px.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
		disabled_small_icon =
		{
			filename = "__PavementDriveAssist__/graphics/shortcuts/pda-24px-white.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 1,
			flags = {"icon"}
		},
	},
})