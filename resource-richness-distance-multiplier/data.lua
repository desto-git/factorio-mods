local resource_autoplace_settings = require('lualib.resource-autoplace').resource_autoplace_settings

-- default values as of 1.0.0
data.raw.resource['iron-ore'].autoplace = resource_autoplace_settings({
	name = 'iron-ore',
	order = 'b',
	base_density = 10,
	has_starting_area_placement = true,
	regular_rq_factor_multiplier = 1.10,
	starting_rq_factor_multiplier = 1.5,
	candidate_spot_count = 22,
})
data.raw.resource['copper-ore'].autoplace = resource_autoplace_settings({
	name = 'copper-ore',
	order = 'b',
	base_density = 8,
	has_starting_area_placement = true,
	regular_rq_factor_multiplier = 1.10,
	starting_rq_factor_multiplier = 1.2,
	candidate_spot_count = 22,
})
data.raw.resource['coal'].autoplace = resource_autoplace_settings({
	name = 'coal',
	order = 'b',
	base_density = 8,
	has_starting_area_placement = true,
	regular_rq_factor_multiplier = 1.0,
	starting_rq_factor_multiplier = 1.1,
})
data.raw.resource['stone'].autoplace = resource_autoplace_settings({
	name = 'stone',
	order = 'b',
	base_density = 4,
	has_starting_area_placement = true,
	regular_rq_factor_multiplier = 1.0,
	starting_rq_factor_multiplier = 1.1,
})

data.raw.resource['uranium-ore'].autoplace = resource_autoplace_settings({
	name = "uranium-ore",
	order = "c",
	base_density = 0.9,
	base_spots_per_km2 = 1.25,
	has_starting_area_placement = false,
	random_spot_size_minimum = 2,
	random_spot_size_maximum = 4,
	regular_rq_factor_multiplier = 1
})

data.raw.resource['crude-oil'].autoplace = resource_autoplace_settings({
	name = "crude-oil",
	order = "c",
	base_density = 8.2,
	base_spots_per_km2 = 1.8,
	random_probability = 1/48,
	random_spot_size_minimum = 1,
	random_spot_size_maximum = 1,
	additional_richness = 220000,
	has_starting_area_placement = false,
	regular_rq_factor_multiplier = 1
})