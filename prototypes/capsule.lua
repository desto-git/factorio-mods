modPath = '__sapling-capsule__'

local cooldown = 30
local range = 10
local clusters = 8
local smokeColor = {r = 0.602, g = 0.848, b = 0.445, a = 0.8}

local names = {
	technology = "forestation",
	recipe = "sapling-capsule",
	projectile = {
		main = "sapling-capsule-payload",
		spore = "sapling-capsule-spore",
	},
	item = "sapling-capsule",
	smoke = "sapling-capsule-smoke",
}

local craftingRecipe = {
	time = 10,
	ingredients = {
		{ "wood", (4 * clusters) / 2 }, -- 4 = loot for harvesting a single tree
		{ "solar-panel", 1 },
		{ "cluster-grenade", 1 },
		{ type = "fluid", name = "water", amount = 10000 }
	}
}

local technologyRequirements =
{
	prerequisites = {
		"military-4",
		"solar-energy",
	},
	unit =
	{
		count = 250,
		ingredients =
		{
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "military-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			-- { "production-science-pack", 1 },
			{ "utility-science-pack", 1 },
		},
		time = 60
	},
}

local smoke = {
	type = "trivial-smoke",
	name = names.smoke,
	animation =
	{
		filename = "__base__/graphics/entity/smoke-fast/smoke-fast.png",
		priority = "high",
		width = 50,
		height = 50,
		frame_count = 16,
		animation_speed = 16 / 60,
		scale = 0.5,
	},
	duration = 60,
	fade_away_duration = 60,
	render_layer = "higher-object-above",
	color = smokeColor
}

local projectileSounds = {
	{ filename = "__base__/sound/fight/throw-projectile-1.ogg", volume = 0.4 },
	{ filename = "__base__/sound/fight/throw-projectile-2.ogg", volume = 0.4 },
	{ filename = "__base__/sound/fight/throw-projectile-3.ogg", volume = 0.4 },
	{ filename = "__base__/sound/fight/throw-projectile-4.ogg", volume = 0.4 },
	{ filename = "__base__/sound/fight/throw-projectile-5.ogg", volume = 0.4 },
	{ filename = "__base__/sound/fight/throw-projectile-6.ogg", volume = 0.4 },
}

explosionSounds = {
	{ filename = "__base__/sound/small-explosion-1.ogg", volume = 0.15 },
	{ filename = "__base__/sound/small-explosion-2.ogg", volume = 0.15 },
	{ filename = "__base__/sound/small-explosion-3.ogg", volume = 0.15 },
	{ filename = "__base__/sound/small-explosion-4.ogg", volume = 0.15 },
	{ filename = "__base__/sound/small-explosion-5.ogg", volume = 0.15 },
}

local capsuleItem = {
	type = "capsule",
	name = names.item,
	icon = modPath .. "/graphics/item.png",
	icon_size = 64,
	icon_mipmaps = 4,
	capsule_action =
	{
		type = "throw",
		attack_parameters =
		{
			type = "projectile",
			ammo_category = "capsule",
			cooldown = cooldown,
			projectile_creation_distance = 0.6,
			range = range,
			ammo_type =
			{
				category = "capsule",
				target_type = "position",
				action =
				{
					{
						type = "direct",
						action_delivery =
						{
							type = "projectile",
							projectile = names.projectile.main,
							starting_speed = 0.3
						}
					},
					{
					type = "direct",
					action_delivery =
					{
						type = "instant",
						target_effects =
						{
							{
								type = "play-sound",
								sound = projectileSounds,
							},
						}
					}
					}
				}
			}
	}
	},
	subgroup = "capsule",
	order = "a[grenade]-c[" .. names.item .. "]",
	stack_size = 100
}

function createProjectile( name, action )
	return
	{
		name = name,
		action = action,
		type = "projectile",
		flags = {"not-on-map"},
		acceleration = 0.005,
		light = {intensity = 0.5, size = 4},
		animation =
		{
			filename = modPath .. "/graphics/projectile.png",
			frame_count = 16,
			line_length = 8,
			animation_speed = 0.250,
			width = 26,
			height = 28,
			shift = util.by_pixel(1, 1),
			priority = "high",
			hr_version =
			{
				filename = modPath .. "/graphics/hr-projectile.png",
				frame_count = 16,
				line_length = 8,
				animation_speed = 0.250,
				width = 48,
				height = 54,
				shift = util.by_pixel(0.5, 0.5),
				priority = "high",
				scale = 0.5
			}
		},
		shadow =
		{
			filename = "__base__/graphics/entity/grenade/grenade-shadow.png",
			frame_count = 16,
			line_length = 8,
			animation_speed = 0.250,
			width = 26,
			height = 20,
			shift = util.by_pixel(2, 6),
			priority = "high",
			draw_as_shadow = true,
			hr_version =
			{
				filename = "__base__/graphics/entity/grenade/hr-grenade-shadow.png",
				frame_count = 16,
				line_length = 8,
				animation_speed = 0.250,
				width = 50,
				height = 40,
				shift = util.by_pixel(2, 6),
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5
			}
		},
		smoke =
		{
			{
				name = names.smoke,
				deviation = {0.15, 0.15},
				frequency = 1,
				position = {0, 0},
				starting_frame = 3,
				starting_frame_deviation = 5,
				starting_frame_speed_deviation = 5
			}
		}
	}
end

local capsuleProjectile = createProjectile( names.projectile.main, {
	{
		type = "cluster",
		cluster_count = clusters,
		distance = 4,
		distance_deviation = 3.8,

		sound = explosionSounds,
		action_delivery =
		{
			type = "projectile",
			projectile = names.projectile.spore,
			direction_deviation = 0.6,
			starting_speed = 0.25,
			starting_speed_deviation = 0.3,
			target_effects =
			{
				{
					type = "play-sound",
					sound = explosionSounds
				}
			}
		}
	}
})

local spore = createProjectile( names.projectile.spore, {
	type = "direct",
	action_delivery =
	{
		type = "instant",
		target_effects =
		{
			{
				type = "play-sound",
				sound = {
					{ filename = "__base__/sound/particles/tree-leaves-1.ogg", volume = 0.4 },
					{ filename = "__base__/sound/particles/tree-leaves-2.ogg", volume = 0.4 },
					{ filename = "__base__/sound/particles/tree-leaves-3.ogg", volume = 0.4 },
					{ filename = "__base__/sound/particles/tree-leaves-4.ogg", volume = 0.4 },
				}
			},
			{
				type = "create-entity",
				show_in_tooltip = true,
				trigger_created_entity = true, -- emit the "on_trigger_created_entity" event so it can be handled in control.lua
				entity_name = "tree-01",
				-- check_buildability = true, -- kill it off in control.lua for particles
				tile_collision_mask = { "water-tile" }, -- do not spawn trees in water
			},

			-- water splash effect if a spore lands in water
			{
				type = "create-entity", -- create-explosion does not respect "tile_collision_mask"
				entity_name = "water-splash",
				tile_collision_mask = { "ground-tile" },
			}
		}
	}
})

local technology = {
	type = "technology",
	name = names.technology,
	icon_size = 128,
	icon = modPath .. "/graphics/technology.png",
	effects =
	{
		{
			type = "unlock-recipe",
			recipe = names.recipe,
		}
	},
	prerequisites = technologyRequirements.prerequisites,
	unit = technologyRequirements.unit,
	order = "e-p-b-b"
}

local recipe = {
	type = "recipe",
	name = names.recipe,
	enabled = false,
	energy_required = craftingRecipe.time,
	category = "crafting-with-fluid",
	ingredients = craftingRecipe.ingredients,
	result = names.item
}

data:extend({
	smoke,
	capsuleProjectile,
	spore,
	capsuleItem,
	technology,
	recipe,
})