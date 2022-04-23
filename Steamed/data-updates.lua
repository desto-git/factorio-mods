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

  local positions = entity.energy_source and entity.energy_source.fluid_box and entity.energy_source.fluid_box.pipe_connections or {}

  for i, pos in pairs (positions) do
    local x = pos.x or pos[1]
    local y = pos.y or pos[2]
    table.insert (all_pipe_connections, {x=x, y=y})
  end

  local fluid_boxes = entity.fluid_boxes or {}

  for i, fluid_box in pairs (fluid_boxes) do
    if type (fluid_box) == 'table' then -- somehow it was boolean
      local pipe_connections = fluid_box.pipe_connections or {}

      for j, pipe_connection in pairs (pipe_connections) do
        local pos = pipe_connection.position
        local x = pos.x or pos[1]
        local y = pos.y or pos[2]
        table.insert (all_pipe_connections, {x=x, y=y})
      end
    end
  end

  for i, pipe_connection in pairs (all_pipe_connections) do
    if pipe_connection.x == position.x and pipe_connection.y == position.y then
      return true
    end
  end
  return false
end


function get_free_pipe_connection (entity, best_position, prev_pipe_connections)
  local cb = entity.collision_box
  local min_x = math.floor (cb[1][1]*2)/2 -- -0.4 --> -0.5; -1.4 --> -1.5; -1.2 --> -1.5
  local min_y = math.floor (cb[1][2]*2)/2

  local max_x = math.ceil (cb[2][1]*2)/2
  local max_y = math.ceil (cb[2][2]*2)/2

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
            table.remove (all_c_positions_list, i)
          end

        end

      end
    end
  end

  if best_position and all_c_positions[best_position.x] and all_c_positions[best_position.x][best_position.y] then
    return best_position
  end

  -- best position was already used
  local best_list = {}
  for i, pos in pairs (all_c_positions_list) do
    local position = pos
    if pos.x == best_position.x or pos.y == best_position.y then
      if not (is_pipe_connection_collides (entity, position, prev_pipe_connections)) then
        table.insert (best_list, pos)
      end
    end
  end



  if #best_list > 0 then
    return best_list[1]
  else

    for i, pos in pairs (all_c_positions_list) do
      if pos.x == (-0.5) or pos.x == (0) or pos.x == (0.5) or pos.y == (-0.5) or pos.y == (0) or pos.y == (0.5) then
        table.insert (best_list, pos)
      end
    end

    if #best_list > 0 then
      return best_list[1]
    end

  end

  if #all_c_positions_list > 0 then
    return best_list[1]
  end

  log ('error: no position found for entity "' .. entity.name .. '"')
  return nil
end

--- add a pipe connection to the list of connections to be added to the entity
-- @param into_table - table to add the pipe into
-- @param entity - the entity to add pipe connections to
-- @param best_position - the preferred position for a new pipe connection
-- @param prev_connections - a table of pipe connections previously added with this function
function insert_pipe_connection (into_table, entity, position, prev_connections)
  local pipe_connection_position = get_free_pipe_connection (entity, position, prev_connections)
  if pipe_connection_position then
    local new_connection = {position = pipe_connection_position}
    table.insert (into_table, new_connection)
    table.insert (prev_connections, new_connection.position)
  end
end

local entity_types_to_alter = {
  'furnace' ,
  'assembling-machine',
  'mining-drill',
  'lab'
}

for i, type_name in pairs (entity_types_to_alter) do
  local prot_type = data.raw[type_name]
  for name, prot in pairs (prot_type) do

    if prot.energy_source and prot.energy_source.type and prot.energy_source.type == "electric" then

      if
        prot.collision_box
        and not (prot.energy_source.burner_only)
        and not (is_value_in_list (name, blacklist)) -- maybe as selectable_in_game?
      then

        local x = prot.collision_box[1][1] -- -1.4
        local y = prot.collision_box[1][2] -- -1.4

        x = math.floor (x*2)/2 - 0.5
        y = math.floor (y*2)/2 - 0.5

        local pipe_connections = {}
        local new_connections = {}

        -- left and right
        insert_pipe_connection (pipe_connections, prot, {x= x, y=y+2}, new_connections)
        insert_pipe_connection (pipe_connections, prot, {x=-x, y=y+2}, new_connections)

        if type_name == "lab" then
          -- top and bottom
          insert_pipe_connection (pipe_connections, prot, {x=x+2, y= y}, new_connections)
          insert_pipe_connection (pipe_connections, prot, {x=x+2, y=-y}, new_connections)
        end

        local images = data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box
        local emissions_per_minute = prot.energy_source.emissions_per_minute

        prot.energy_source =
        {
          type = 'fluid',
          maximum_temperature = 165,
          emissions_per_minute = emissions_per_minute,

          fluid_box =
          {
            production_type = "input-output",
            filter = "steam",
            pipe_picture = images.pipe_picture,
            pipe_covers = images.pipe_covers,
            base_area = 1,
            height = 2,
            base_level = -1,
            pipe_connections = pipe_connections
          }
        }
      end
    end
  end
end