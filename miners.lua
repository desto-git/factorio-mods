-- data.raw.resource["uranium-ore"].minable.fluid_amount = 10 
-- data.raw.resource["uranium-ore"].minable.required_fluid = "sulfuric-acid" 



for resource_name, resource_prot in pairs (data.raw.resource) do
  if resource_prot.minable and not (resource_prot.minable.required_fluid) then
    resource_prot.minable.required_fluid = "steam"
    resource_prot.minable.fluid_amount = 100
  end
end

-- local pipe_picture = data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box.pipe_picture
-- local pipe_covers = data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box.pipe_covers
local example_input_fluid_box = table.deepcopy (data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box)
data.raw["mining-drill"]["electric-mining-drill"].input_fluid_box = nil

function add_pipe_connections (prot)

  local input_fluid_box = {}
  
  if not (prot.input_fluid_box) then
    input_fluid_box = table.deepcopy (example_input_fluid_box)
  end
  local collision_box = prot.collision_box
  if collision_box then
    local size_x = math.ceil(collision_box[2][1] - collision_box[1][1]) -- 1.4 + 1.4 = 2.8 --> 3
    local size_y = math.ceil(collision_box[2][2] - collision_box[1][2]) -- 0.7 + 0.7 = 1.4 --> 2
    local pipe_connections = {}
    if size_y%2 == 1 then
      if size_x%2 == 1 then -- x = 3, 5, 7
        table.insert(pipe_connections, {position = {-(size_x/2 +.5), 0}})
        table.insert(pipe_connections, {position = { (size_x/2 +.5), 0}})
        table.insert(pipe_connections, {position = { 0, (size_y/2 +.5)}})
      else -- x = 2 or 4 or 6
        table.insert(pipe_connections, {position = {-(size_x/2 +.5), 0}})
        table.insert(pipe_connections, {position = { (size_x/2 +.5), 0}})
      end
    else -- y = 2, 4, 6
      if size_x%2 == 1 then -- x = 3, 5, 7
        table.insert(pipe_connections, {position = {-(size_x/2 +.5), 0.5}})
        table.insert(pipe_connections, {position = { (size_x/2 +.5), 0.5}})
        table.insert(pipe_connections, {position = { 0, (size_y/2 +.5)}})
      else -- x = 2 or 4 or 6
        table.insert(pipe_connections, {position = {-(size_x/2 +.5), 0.5}})
        table.insert(pipe_connections, {position = { (size_x/2 +.5), 0.5}})
      end
    end
    input_fluid_box.pipe_connections = pipe_connections
    prot.input_fluid_box = input_fluid_box
  else
    log ('Error! No collision box by '..prot.type..' - '..prot.name)
  end
end

for name, prot in pairs (data.raw["mining-drill"]) do
  add_pipe_connections (prot)
end