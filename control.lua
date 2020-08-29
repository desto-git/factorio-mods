script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  log ('Added items to player '..player.name)
  player.insert{name="iron-plate", count=200}
  player.insert{name="copper-plate", count=100}
  player.insert{name="coal", count=200}
  player.insert{name="assembling-machine-1", count=12}
  player.insert{name="assembling-machine-2", count=2}
  player.insert{name="assembling-machine-3", count=1}
  player.insert{name="wooden-chest", count = 12}
  player.insert{name="burner-mining-drill", count = 4}
  player.insert{name="electric-mining-drill", count = 1}
  player.insert{name="stone-furnace", count = 4}
  player.insert{name="steel-furnace", count = 2}
  player.insert{name="electric-furnace", count = 1}
  player.insert{name="boiler", count = 10}
  player.insert{name="steam-engine", count = 2}
  player.insert{name="inserter", count = 50}
  player.insert{name="pipe", count = 400}
  player.insert{name="pipe-to-ground", count = 200}
  player.insert{name="offshore-pump", count = 2}
  player.insert{name="small-electric-pole", count = 100}
  player.insert{name="medium-electric-pole", count = 50}
  player.insert{name="lab", count = 1}
  player.insert{name="transport-belt", count = 200}
  player.insert{name="underground-belt", count = 50}
  -- player.insert{name="steel-axe", count = 1} -- not for 0.17
end)

-- script.on_event(defines.events.on_player_respawned, function(event)
  -- local player = game.players[event.player_index]
  -- player.insert{name="pistol", count=1}
  -- player.insert{name="firearm-magazine", count=10}
-- end)
