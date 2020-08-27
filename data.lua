local normalizeTreeCollision = settings.startup["sapling-capsule-normalize-collision-box"].value
if normalizeTreeCollision then
	for i, v in pairs( data.raw.tree ) do
		if v.collision_box[2][1] < 0.4 then
			v.collision_box = {{-0.4, -0.4}, {0.4, 0.4}}
		end
	end
end



require("prototypes.capsule")