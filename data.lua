local mod_name = '__Steamed__'

local name = 'mini-storage-tank'

data:extend ({  
  {
    type = "item",
    name = name,
    icon = mod_name.."/graphics/icons/"..name..".png",
    icon_size = 32,
    subgroup = "storage",
    order = "b[fluid]-a[storage-tank]-d["..name.."]",
    place_result = name,
    stack_size = 50
  },
  
  {
    type = "storage-tank",
    name = "mini-storage-tank",
    icon = mod_name.."/graphics/icons/"..name..".png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = name},
    max_health = 50,
    corpse = "medium-remnants",
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fluid_box =
    {
      base_area = 1, -- was 250
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        { position = { 0, -1} },
        { position = { 1,  0} },
        { position = { 0,  1} },
        { position = {-1,  0} }
      }
    },
    -- two_direction_only = true,
    window_bounding_box = {{-0.125, 0.125}, {0.125, 0.250}},
    pictures =
    {
      picture =
      {
        sheets =
        {
          {
            filename = mod_name.."/graphics/entity/"..name..".png",
            priority = "extra-high",
            frames = 1,
            width = 36,
            height = 36,
            -- shift = util.by_pixel(0, 4),
            hr_version =
            {
              filename = mod_name.."/graphics/entity/hr-"..name..".png",
              priority = "extra-high",
              frames = 1,
              width = 72,
              height = 72,
              -- shift = util.by_pixel(-0.25, 3.75),
              scale = 0.5
            }
          }
        }
      },

      window_background =
      {
        filename = mod_name.."/graphics/entity/window-background.png",
        priority = "extra-high",
        width = 16,
        height = 16,
        hr_version =
        {
          filename = mod_name.."/graphics/entity/hr-window-background.png",
          priority = "extra-high",
          width = 32,
          height = 32,
          scale = 0.5
        }
      },
      fluid_background =
      {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15
      },
      flow_sprite =
      {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20
      },
      gas_flow =
      {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 24,
        height = 15,
        frame_count = 60,
        axially_symmetrical = false,
        direction_count = 1,
        animation_speed = 0.25,
        -- hr_version =
        -- {
          -- filename = "__base__/graphics/entity/pipe/hr-steam.png",
          -- priority = "extra-high",
          -- line_length = 10,
          -- width = 48,
          -- height = 30,
          -- frame_count = 60,
          -- axially_symmetrical = false,
          -- animation_speed = 0.25,
          -- direction_count = 1
        -- }
      }
    },
    flow_length_in_ticks = 360,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
          filename = "__base__/sound/storage-tank.ogg",
          volume = 0.8
      },
      match_volume_to_activity = true,
      apparent_volume = 1.5,
      max_sounds_per_type = 3
    },
    circuit_wire_connection_points = 
      {
      {
        wire = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
        shadow = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
      },
      {
        wire = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
        shadow = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
      },
      {
        wire = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
        shadow = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
      },
      {
        wire = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
        shadow = {red = {-0.25, 0.25}, green = {0.25, 0.25}},
      },
      },
    -- circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points,
    circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance
  },
  
  {
    type = "recipe",
    name = name,
    energy_required = 1,
    -- enabled = false,
    ingredients =
    {
      {"iron-plate", 4}
    },
    result= name
  },
  
  
})