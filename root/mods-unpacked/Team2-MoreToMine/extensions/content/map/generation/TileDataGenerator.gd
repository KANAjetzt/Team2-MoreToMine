extends "res://content/map/generation/TileDataGenerator.gd"


const TEAM2_MORE_TO_MINE_LOG_NAME := "Team2-MoreToMine:TileDataGenerator"

var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")


func generate_resources(rand):
	super.generate_resources(rand)

	var globals: Team2Globals = team_2_mod_node.globals

	for resource in globals.resources:
		for i in range(0, 10):
			var cells = $MapData.get_biome_cells_by_index(i)
			if cells.size() == 0:
				break

			var biome_cells = Data.seedShuffle(cells, gen_seed)

			var resources_generated = 0
			for cell in biome_cells:
				var ressource_cell = $MapData.get_resourcev(cell)
				if ressource_cell >= Data.TILE_DIRT_START && ressource_cell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD:
					$MapData.set_resourcev(cell, resource.tile_id)
					print_generated_resource(cell, resource.tile_string)
					resources_generated += 1
				if resources_generated >= resource.spawn_per_layer_max:
					break

			# debugging purposes
			if GameWorld.devMode or OS.is_debug_build():
				$MapData.set_resourcev(Vector2(0, 2) , 42)


func print_generated_resource(cell, resource_name: String):
	if GameWorld.devMode or OS.is_debug_build():
		ModLoaderLog.debug.call_deferred("Generated \"%s\" at: \"%s\"" % [resource_name, cell], TEAM2_MORE_TO_MINE_LOG_NAME)
