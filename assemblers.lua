local crafting_category = "crafting-with-steam"

data:extend({
  {
    type = "recipe-category",
    name = crafting_category
  }
})

function has_same_values (list_1, list_2)
  for i, v_1 in pairs (list_1) do
    for j, v_2 in pairs (list_2) do
      if v_1 == v_2 then return true end
    end
  end
  return false
end

for recipe_name, recipe_prot in pairs (data.raw.recipe) do
  local recipe_handlers = {recipe_prot}
  if recipe_prot.normal then table.insert(recipe_handlers, recipe_prot.normal) end
  if recipe_prot.expensive then table.insert(recipe_handlers, recipe_prot.expensive) end

  if recipe_prot.category then 
    if recipe_prot.category == "crafting" then
      -- recipe_prot.category = "crafting-with-fluid"
      recipe_prot.category = "crafting-with-steam"
      log ('recipe category by '.. recipe_name.. ' was changed to "crafting-with-fluid"')
    end
  else  
    -- recipe_prot.category = "crafting-with-fluid"
    recipe_prot.category = "crafting-with-steam"
    log ('it was no recipe category by '.. recipe_name)
  end
  if has_same_values ({recipe_prot.category}, {"crafting", "advanced-crafting", "crafting-with-fluid", "crafting-with-steam"}) then
    for i, handler_prot in pairs (recipe_handlers) do
      -- code here
      if handler_prot.ingredients then
        table.insert (handler_prot.ingredients, {type = "fluid", name = "steam", amount = 10})
      end
    end
  end
end

data.raw["assembling-machine"]["assembling-machine-1"].collision_box = {{-0.7,-0.7},{0.7,0.7}}
data.raw["assembling-machine"]["assembling-machine-2"].collision_box = {{-1.2,-1.2},{1.2,1.2}}
data.raw["assembling-machine"]["assembling-machine-3"].collision_box = {{-1.7,-1.7},{1.7,1.7}}

data.raw["assembling-machine"]["assembling-machine-1"].selection_box = {{-1.0,-1.0},{1.0,1.0}}
data.raw["assembling-machine"]["assembling-machine-2"].selection_box = {{-1.5,-1.5},{1.5,1.5}}
data.raw["assembling-machine"]["assembling-machine-3"].selection_box = {{-2.0,-2.0},{2.0,2.0}}

for i, layer in pairs (data.raw["assembling-machine"]["assembling-machine-1"].animation.layers) do
  layer.scale = layer.scale and layer.scale * 0.66 or 0.66
  if layer.hr_version then
    layer.hr_version.scale = layer.hr_version.scale and layer.hr_version.scale * 0.66 or 0.66
  end
end

for i, layer in pairs (data.raw["assembling-machine"]["assembling-machine-3"].animation.layers) do
  layer.scale = layer.scale and layer.scale * 1.33 or 1.33
  if layer.hr_version then
    layer.hr_version.scale = layer.hr_version.scale and layer.hr_version.scale * 1.33 or 0.5*1.33
  end
end

for i, fluid_box in ipairs (data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes) do
  for j, pipe_connection in pairs (fluid_box.pipe_connections) do
    local x = pipe_connection.position[1]
    local y = pipe_connection.position[2]
    if x > 0 then x = x + 0.5 else x = x - 0.5 end
    if y > 0 then y = y + 0.5 else y = y - 0.5 end
    pipe_connection.position = {x, y}
  end
end



for am_name , am_prot in pairs (data.raw["assembling-machine"]) do
  if has_same_values ({"crafting", "advanced-crafting", "crafting-with-fluid", "crafting-with-steam"}, am_prot.crafting_categories) then
    if (not am_prot.fluid_boxes) then 
      am_prot.fluid_boxes = 
        {
          {
            production_type = "input", 
            -- pipe_connections = {{type = "input", position = {0, -2}}}
            pipe_connections = 
              {
                {
                  type = "input", 
                  position = {am_prot.collision_box[1][1]+1.2, am_prot.collision_box[1][2]-0.8}
                }  -- also {0, -2} fo 3x3 entities
              }
          }
        }
    else
      -- test only
      for i, fluid_box in pairs (am_prot.fluid_boxes) do
        if type(fluid_box)=="table" then
          fluid_box.pipe_picture=nil
          fluid_box.pipe_covers=nil
          fluid_box.base_area=nil
          fluid_box.base_level=nil
          fluid_box.secondary_draw_orders=nil
        else
          log ('not a table! '..am_name)
        end
      end
      --/test only
      table.insert (am_prot.fluid_boxes, 
          {
            production_type = "input", 
            pipe_connections = 
              {
                {
                  type = "input", 
                  position = {am_prot.collision_box[1][1]-0.8, am_prot.collision_box[1][2]+1.2}
                },              
                {
                  type = "input", 
                  position = {am_prot.collision_box[2][1]+0.8, am_prot.collision_box[1][2]+1.2}
                },
              }
          }
          )
    end
    am_prot.fluid_boxes.off_when_no_fluid_recipe = true
    
    if am_prot.crafting_categories then
      table.insert (am_prot.crafting_categories, crafting_category)
    else
      am_prot.crafting_categories = {crafting_category}
    end
  end
end

-- data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories[1] = "crafting" 
-- data.raw.recipe.lubricant.subgroup = "fluid-recipes" 
-- data.raw.recipe["express-transport-belt"].category = "crafting-with-fluid" 
