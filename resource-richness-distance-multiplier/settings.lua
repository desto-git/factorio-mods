-- https://wiki.factorio.com/Tutorial:Mod_settings

local prefix = "resource-richness-distance-multiplier-"

data:extend({
	{
		type = "double-setting",
		name = prefix .. "regular-patch-multiplier",
		setting_type = "startup",
		default_value = 0.1,
		minimum_value = 0,
	},
	{
		type = "double-setting",
		name = prefix .. "distance-multiplier",
		setting_type = "startup",
		default_value = 0.1,
		minimum_value = 0,
	}
})