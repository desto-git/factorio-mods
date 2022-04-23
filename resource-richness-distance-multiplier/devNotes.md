# Resources

- data/core/lualib/resource-autoplace.lua
- https://github.com/wube/factorio-data/blob/2b18d0a/core/lualib/resource-autoplace.lua
- https://lua-api.factorio.com/1.0.0/Concepts.html#AutoplaceSpecification

# Notes on how stuff works

```
return
{
  initialize_patch_set = initialize_patch_set,
  resource_autoplace_settings = resource_autoplace_settings
}
```

`initialize_patch_set` defines spots that resources can spawn on.
If omitted, it doesn't initially change anything it seems.

However, if the `probability_expression` is changesd, the probability applies to the entire map instead of just some
blobs.

---

```
local ret =
{
	order = order,
	control = autoplace_control_name,
	probability_expression = probability_expression,
	richness_expression = probability_expression * 100 -- noise.random(800) + 400
}
```

`probability_expression` is a value between 0 and 1, indicating the chance that a particular tile will have a resource
to begin with. If the chance is not actually 0 or 1, but something in between, resources patches will have empty tiles
scatted across them.

`richness_expression` returns the exact amount of ore for a particular tile. Though I'm not sure how exactly this
converts to yielding resources, e.g. oil patches.
- tne(10000) -> 3%
- tne(100000) -> 33%
- tne(1000000) -> 333%

Note that this value must be at least 2. The tile won't spawn if it has a richness of less than that.
Though it will still show up on the preview for map generation if the value is greater than 0.
Floating point numbers are floored.

Both these values must be noise expressions, a regular number is not enough. You can use the `tne()` that is used in
this file to convert numbers "To Noise Expression"s.

`noise.delimit_procedure(expression)` doesn't really do anything.
It only causes outputs by `dump_expression(expression)` to be trimmed as not to clutter the output with a wall of math.

---

```
{
	type = "function-application",
	function_name = "random-penalty",
	arguments =
	{
		source = tne(10),
		x = noise.var("x"),
		y = noise.var("y"),
		amplitude = tne(8)
	}
}
```

`source` is the base value.

`amplitude` is the maximum deviation from that base value.
In the above example, the effective value is in the range 2..10

---

```
{
	type = "function-application",
	function_name = "spot-noise",
	arguments =
	{
		x = noise.var("x"),
		y = noise.var("y"),
		seed0 = noise.var("map_seed"),
		seed1 = tne(seed1+1),
		density_expression = litexp(1000), -- litexp(starting_density * starting_modulation_richness),
		spot_quantity_expression = litexp(starting_area_spot_quantity),
		spot_radius_expression = litexp(starting_rq_factor * starting_area_spot_quantity ^ (onethird)),
		spot_favorability_expression = litexp(
		starting_feasibility_richness * 2 -
			1 * distance / starting_resource_placement_radius +
			noise.random(0.5)
		),
		basement_value = basement_value,
		maximum_spot_basement_radius = tne(128) -- does making this huge make a difference?
	}
}
```

`density_expression` seems to practically determine the max distance at which a resource can spawn.

# Variables

The returned expressions can contain variables that will be replaced somewhere in the C++ core I assume.
These can be included by calling `noise.var("variableName")`.

Known variables:
- `x`: X coordinate in tiles on the map
- `y`: Y coordinate in tiles on the map
- `distance`: Distance in tiles from the center of the map
- `elevation`: Height of a specific tile
- `map_seed`: Seed of the map
- `regular-resource-patch-set-count`: ???
- `starting-resource-patch-set-count`: ???