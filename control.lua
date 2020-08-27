script.on_event( defines.events.on_trigger_created_entity, function(event)
	if not (event.entity.name == "tree-01") then return end

	local position = event.entity.position
	local surface = event.entity.surface

	-- kill it of before scanning for nearby trees, otherwise they would find themselves
	-- dying also plays a neat animation for "planting"
	-- and it's a feature, not a bug: new trees cannot be planted too far away from other ones
	event.entity.die()

	-- look for the closest tree to copy
	-- note that "find_entities_filtered" does not sort by distance
	local found = surface.find_entities_filtered({
		position = position,
		radius = 16,
		-- limit = 10,
		type = "tree",
	})

	if #found > 0 then
		local closest = surface.get_closest( position, found )
		local treeData = {name = closest.name, position = position}
		if surface.can_place_entity( treeData ) then
			surface.create_entity( treeData )
		end
	end
end)