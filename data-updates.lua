local only_for_electric_energy = true

log (' ==============================================')
log (' ==============================================')
log (' ==============================================')
log (' ================ < HI DEVS > ================')
log (' =============================================')
log (' =============================================')
log ('==============================================')

-- electric furnace must better as the steel one
data.raw.furnace["steel-furnace"].crafting_speed = data.raw.furnace["stone-furnace"].crafting_speed * 2
data.raw.furnace["electric-furnace"].crafting_speed = data.raw.furnace["steel-furnace"].crafting_speed * 2


-- you are need a lot of steam, really lot
data.raw.fluid.steam.heat_capacity = "2KJ"
data.raw.boiler.boiler.energy_source.effectivity = 10
data.raw.boiler.boiler.energy_consumption = "18MW"
data.raw.boiler["heat-exchanger"].energy_source.effectivity = 10
data.raw.boiler["heat-exchanger"].energy_consumption = "100MW"
data.raw.boiler["heat-exchanger"].target_temperature = 515

-- some rounding
data.raw.fluid.steam.max_temperature = 1015

data.raw.recipe.pump.ingredients = {{'iron-plate', 10}, {'pipe', 2}}

local blacklist = {'factory-port-marker', 'hidden_trade_post', 'castle_dummy', 'castle'}



function is_value_in_list (value, list)
  for i, v in pairs (list) do
    if v == value then return true end
  end
  return false
end


function is_pipe_connection_collides (entity, position, prev_pipe_connections)
  local prev_pipe_connections = prev_pipe_connections or {}
  local all_pipe_connections = prev_pipe_connections -- pipe_connections


  -- entity.energy_source.fluid_box.pipe_connections[1].position = {x = -4, y= -1}
  local positions = entity.energy_source and entity.energy_source.fluid_box and entity.energy_source.fluid_box.pipe_connections or {}
  if #positions > 0 then
    log ('positions: ' .. serpent.line (positions))
  elseif entity.energy_source and entity.energy_source.fluid_box then
    log ('entity.energy_source.fluid_box: ' .. serpent.line (entity.energy_source.fluid_box))
  elseif entity.energy_source then
    log ('entity.energy_source: ' .. serpent.line (entity.energy_source))
  end


  for i, pos in pairs (positions) do
    local x = pos.x or pos[1]
    local y = pos.y or pos[2]
    log (' added 1')
    table.insert (all_pipe_connections, {x=x, y=y})
  end

  -- entity.fluid_boxes[1].pipe_connections[1] = {type = "input", position = {0, -2}}
  local fluid_boxes = entity.fluid_boxes or {}
  if #fluid_boxes > 0 then
    -- log ('fluid_boxes: ' .. serpent.line (fluid_boxes))
  end

  for i, fluid_box in pairs (fluid_boxes) do
    if type (fluid_box) == 'table' then -- somehow it was boolean
      local pipe_connections = fluid_box.pipe_connections or {}
      if #pipe_connections > 0 then
        log ('pipe_connections: ' .. serpent.line (pipe_connections))
      end

      for j, pipe_connection in pairs (pipe_connections) do
        local pos = pipe_connection.position
        local x = pos.x or pos[1]
        local y = pos.y or pos[2]
        log (' added 2')
        table.insert (all_pipe_connections, {x=x, y=y})
      end
    end
  end

  log (' ["'..entity.name..'"] amount pipes: ' .. #all_pipe_connections)

  for i, pipe_connection in pairs (all_pipe_connections) do
    if pipe_connection.x == position.x and pipe_connection.y == position.y then
      return true
    end
  end
  return false
end


function get_free_pipe_connection (entity, best_position, prev_pipe_connections, comment)
  local prev_pipe_connections = prev_pipe_connections or {}

  local cb = entity.collision_box
  local min_x = math.floor (cb[1][1]*2)/2 -- -0.4 --> -0.5; -1.4 --> -1.5;
  local min_y = math.floor (cb[1][2]*2)/2

  local max_x = math.ceil (cb[2][1]*2)/2
  local max_y = math.ceil (cb[2][2]*2)/2

  local entity_size = (max_x-min_x) .. 'x' .. (max_y-min_y)
  log ('["' .. entity.name .. '"] size: ' .. entity_size)

  local all_c_positions = {}
  local all_c_positions_list = {}

  for x = (min_x+0.5), (max_x-0.5) do
    for _, y in pairs ({(min_y-0.5), (max_y+0.5)}) do
      if not all_c_positions[x] then all_c_positions[x] = {} end
      if not all_c_positions[x][y] then all_c_positions[x][y] = true end
      table.insert (all_c_positions_list, {x=x,y=y})
    end
  end

  for y = (min_y+0.5), (max_y-0.5) do
    for _, x in pairs ({(min_x-0.5), (max_x+0.5)}) do
      if not all_c_positions[x] then all_c_positions[x] = {} end
      if not all_c_positions[x][y] then all_c_positions[x][y] = true end
      table.insert (all_c_positions_list, {x=x,y=y})
    end
  end

  local all_pcs = {} -- all pipe connections

  local ipcs = entity.input_fluid_box and entity.input_fluid_box.pipe_connections or {}

  local espcs = entity.energy_source and entity.energy_source.fluid_box and entity.energy_source.fluid_box.pipe_connections or {}

  for i, pcs in pairs ({ipcs, espcs}) do
    for j, pc in pairs (pcs) do
      table.insert (all_pcs, pc)
    end
  end

  if #all_pcs>0 then
    for i, pc in pairs (all_pcs) do
      local position = pc.position
      local x = position[1]
      local y = position[2]
      if all_c_positions[x] and all_c_positions[x][y] then
        all_c_positions[x][y] = nil

        for i = #all_c_positions_list, 1, -1 do -- backwards!
          local pos = all_c_positions_list[i]
          if pos.x == x and pos.y == y then
            -- all_c_positions_list[i] = nil
            table.remove (all_c_positions_list, i)
          end

        end

      end
    end
  end

  -- the all_c_positions hasn't any collided pipes
  -- if best_position and and all_c_positions[best_position.x][best_position.y] then
  if best_position and all_c_positions[best_position.x] and all_c_positions[best_position.x][best_position.y] then -- changed in 0.2.1
    log ('["'..entity.name..'"] '.. comment ..' - best position: '..serpent.line (best_position))
    return best_position
  else
    log ('error: no best position: '..comment)
  end

  -- best position was already used
  local best_list = {}
  for i, pos in pairs (all_c_positions_list) do
    local position = pos
    if pos.x == best_position.x or pos.y == best_position.y then
      if not (is_pipe_connection_collides (entity, position, prev_pipe_connections)) then

        table.insert (best_list, pos)
      else
        log ('not free position')
      end
    end
  end



  if #best_list > 0 then
    log ('is best_list[1] not free? ' .. tostring (is_pipe_connection_collides (entity, best_list[1], prev_pipe_connections)))

    local pipe_position = best_list[1]
    -- is_pipe_connection_collides (entity, position)

    log ('["'..entity.name..'"] '.. comment ..' - first from best list 1: '..serpent.line (pipe_position))
    -- return best_list[math.random(#best_list)]


    return pipe_position
  else -- make best_list more flexible

    for i, pos in pairs (all_c_positions_list) do
      if pos.x == (-0.5) or pos.x == (0) or pos.x == (0.5) or pos.y == (-0.5) or pos.y == (0) or pos.y == (0.5) then
        table.insert (best_list, pos)
      end
    end

    if #best_list > 0 then
      local pipe_position = best_list[1]
      log ('["'..entity.name..'"] '.. comment ..' - first from best list 1: '..serpent.line (pipe_position))
      -- return best_list[math.random(#best_list)] -- no random please, added in 0.2.1
      return pipe_position
    end

  end

  if #all_c_positions_list > 0 then
    local pipe_position = best_list[1]
    log ('["'..entity.name..'"] '.. comment ..' - first from best list 2: '..serpent.line (pipe_position))
    -- return all_c_positions_list[math.random(#all_c_positions_list)] -- no random please, added in 0.2.1
    return pipe_position
  end
  log ('no free position by ' .. entity.name)
  return nil
end


for i, type_name in pairs ({
    'furnace' ,
    'assembling-machine',
    'mining-drill',
    'lab' -- crash on deconstructing in 0.17.4
    }) do
  local prot_type = data.raw[type_name]
  for name, prot in pairs (prot_type) do

    if not only_for_electric_energy or (only_for_electric_energy and prot.energy_source and prot.energy_source.type and prot.energy_source.type == "electric") then

      if prot.energy_source
        and prot.collision_box
        and not (prot.energy_source.burner_only)
        and not (is_value_in_list (name, blacklist)) -- maybe as selectable_in_game?
        and true then

        local x = prot.collision_box[1][1] -- -1.4
        local y = prot.collision_box[1][2] -- -1.4

        x = math.floor (x*2)/2 - 0.5
        y = math.floor (y*2)/2 - 0.5

        local position   = {x= x, y=y+2}
        local position_2 = {x=-x, y=y+2}

        local pipe_connections = {{position = get_free_pipe_connection (prot, position, nil ,'pos 1')}}

        -- log ('pipe_connections: ' .. serpent.line (pipe_connections))

        local new_connections = {}
        for i, v in pairs (pipe_connections) do
          table.insert (new_connections, v.position)
        end

        local second_pipe_connection_position = get_free_pipe_connection (prot, position_2, new_connections, 'pos 2')

        if second_pipe_connection_position then
          table.insert (pipe_connections, {position = second_pipe_connection_position})
        end

        -- log (name ..' position '..serpent.line (position))

		local str = prot.energy_usage
		local fupt = (0.24)/60
		if str then
			local value = tonumber(string.match(str, "%d[%d.,]*"))
			local unit = string.match(str, "%a+")

			if unit == "kW" then
				fupt = fupt * value /75
			elseif unit == "MW" then
				fupt = fupt * (value*1000) /75
			elseif unit then
				log ('error: wrong unit: "' .. unit .. '" by ["' .. prot.name .. '"]' )
			else
				log ('error: no unit by ["' .. prot.name .. '"]' )
			end
			log ('["' .. prot.name .. '"] power: "' .. str .. '" fluid_usage_per_tick: ' .. fupt)
		else
			log ('error: no power: "' .. unit .. '" by ["' .. prot.name .. '"]' )
		end

        prot.energy_source =
          {
            type = 'fluid',
--
			scale_fluid_usage = true, -- added in 0.2.1


--			fluid_usage_per_tick = 1.3/60, -- added in 0.3.0
--			fluid_usage_per_tick = 1/60, -- added in 0.3.0
--			1/60 is too small, with am-3 and 3 speed modules we can make 800 items/m with 500 degrees steam; 1/60 makes just 600 items/m

			-- AM-1: energy_usage = "75kW"
--			fluid_usage_per_tick = (0.25)/60, -- added in 0.3.0 -- 500 degrees 75 kW
--			fluid_usage_per_tick = (0.23)/60, -- added in 0.3.0 -- 170 degrees 75 kW
--			fluid_usage_per_tick = (0.24)/60, -- added in 0.3.0 -- 165 degrees 75 kW
			fluid_usage_per_tick = fupt, -- added in 0.3.0

			--	maximum_temperature = 1015, -- https://wiki.factorio.com/Types/EnergySource#maximum_temperature
			-- not useful

            fluid_box =
              {
                -- production_type = "input-output",
                filter = "steam",
                pipe_picture = table.deepcopy (data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box.pipe_picture),
                pipe_covers = table.deepcopy (data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box.pipe_covers),
                base_area = 1,
                height = 2,
                base_level = -1,
                pipe_connections = pipe_connections
              }

          }
        if prot.fluid_boxes and prot.fluid_boxes.off_when_no_fluid_recipe then
          prot.fluid_boxes.off_when_no_fluid_recipe = false
        end

      elseif is_value_in_list (name, blacklist) then
        log ('prototype in black list: ["'..name..'"]')


      else
        if prot.collision_box then
          -- log ('collision_box '..serpent.line (prot.collision_box))
        else
          -- log ('no collision_box by '..name)
        end
      end
    end
  end
end



