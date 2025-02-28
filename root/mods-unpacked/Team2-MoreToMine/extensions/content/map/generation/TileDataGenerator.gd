extends "res://content/map/generation/TileDataGenerator.gd"


const TEAM2_MORE_TO_MINE_LOG_NAME := "Team2-MoreToMine:TileDataGenerator"

var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")


func init(archetype:MapArchetype, randSeed):
	super.init(archetype, randSeed)

	var globals: Team2Globals = team_2_mod_node.globals


	adjust_archetype_values("water_rate", globals.water_spawn_rate_multiplier)
	adjust_archetype_values("iron_cluster_rate", globals.iron_cluster_rate_multiplier)
	adjust_archetype_values("iron_cluster_size_base", globals.iron_cluster_size_base_multiplier)
	adjust_archetype_values("iron_cluster_size_per_y", globals.iron_cluster_size_per_y_multiplier)
	adjust_archetype_values("iron_cluster_size_randomness", globals.iron_cluster_size_randomness_multiplier)


func generate_resources(rand):
	super.generate_resources(rand)

	var globals: Team2Globals = team_2_mod_node.globals

	for resource in globals.resources:
		if resource.spawn_as_cluster:
			var cluster_centers = $MapData.get_resource_cells_by_id(resource.tile_id).duplicate()
			expand_clusters(cluster_centers, resource)
		else:
			for i in range(0, 10):
				var cells = $MapData.get_biome_cells_by_index(i)
				if cells.size() == 0:
					break

				var biome_cells = Data.seedShuffle(cells, gen_seed)

				var resources_generated = 0
				for cell in biome_cells:
					var ressource_cell = $MapData.get_resourcev(cell)
					if (
						ressource_cell >= Data.TILE_DIRT_START and
						ressource_cell <= Data.TILE_DIRT_START + Data.HARDNESS_VERY_HARD and
						cell.y >= a.depth * resource.spawn_depth_min_multiplier and
						cell.y <= a.depth * resource.spawn_depth_max_multiplier
					):
						$MapData.set_resourcev(cell, resource.tile_id)
						print_generated_resource(cell, resource.type)
						resources_generated += 1
					if resources_generated >= resource.spawn_per_layer_max:
						break

				# debugging purposes
				if GameWorld.devMode or OS.is_debug_build():
					$MapData.set_resourcev(Vector2(0, 2) , 42)


func generate_iron_clusters(original_cell_coords, borderCells):
	super.generate_iron_clusters(original_cell_coords, borderCells)

	var globals: Team2Globals = team_2_mod_node.globals

	for resource in globals.resources:
		if resource.spawn_as_cluster:
			generate_clusters(original_cell_coords, borderCells, resource)


func generate_clusters(original_cell_coords, borderCells, resource_data: Team2ResourceData):
	var ClusterAmount = round(resource_data.cluster_rate * 0.001 * original_cell_coords.size())

	for i in ClusterAmount:
		$MapData.set_resourcev(original_cell_coords[i], resource_data.tile_id)

	# DISTRIBUTE CLUSTERS
	var iterations := 100
	var totalMove := Vector2()
	var averagedLastTotalMoves := Vector2()
	for iteration in iterations:
		var Tiles = $MapData.get_resource_cells_by_id(resource_data.tile_id)
		Utils.shuffle(Tiles, rand)
		for tileCoord in Tiles:
			# Skip if spawn depth is not met
			if (
				tileCoord.y >= a.depth * resource_data.spawn_depth_min_multiplier or
				tileCoord.y <= a.depth * resource_data.spawn_depth_max_multiplier
			):
				continue

			var sum := Vector2()
			for otherCoord in Tiles:
				if otherCoord == tileCoord:
					continue
				var delta = tileCoord - otherCoord
				var strength = 20 + 5 * round(otherCoord.y * resource_data.cluster_size_per_y)
				var mod = strength / delta.length_squared()
				if mod < 0.02:
					continue
				sum += (Vector2(delta).normalized()) * mod
			for borderCell in borderCells:
				var strength = 500 + round(borderCell.y * 2.0)
				var delta = tileCoord - borderCell
				var deltal = delta.length()
				var mod = 0.02 * strength / (deltal*deltal*deltal)
				if mod < 0.002:
					continue
				sum += (Vector2(delta).normalized()) * mod
			if sum.length() > 0.2:
				sum = sum.normalized()
			sum.x = round(sum.x)
			sum.y = round(sum.y)
			if $MapData.get_resourcev(Vector2(tileCoord) + sum) == Data.TILE_DIRT_START:
				totalMove += sum
				moveResource(tileCoord, sum.x, sum.y, resource_data.tile_id)
		averagedLastTotalMoves = averagedLastTotalMoves * 0.5 + totalMove * 0.5
#			if (totalMove-averagedLastTotalMoves).length() < 1.0:
#				zeroMoves += 1
#
#				if zeroMoves >= 5:
#					break


func expand_clusters(ClusterCenters, resource_data: Team2ResourceData):
	for cell in ClusterCenters:
		var cluster := [cell]
		var goalSize = round(resource_data.cluster_size_base + cell.y * (resource_data.cluster_size_per_y - resource_data.cluster_size_randomness * 0.5 + resource_data.cluster_size_randomness * rand.randf()))
		for i in 50:
			if cluster.size() >= goalSize:
				break
			var randomCell = cluster[rand.randi() % cluster.size()]
			Utils.shuffle(directions,rand)
			for d in directions:
				var neighbor = randomCell + Vector2i(d)
				if $MapData.get_resourcev(neighbor) == Data.TILE_DIRT_START:
					$MapData.set_resourcev(neighbor, resource_data.tile_id)
					cluster.append(neighbor)
					break


func adjust_archetype_values(prop_name: String, multiplier: float) -> void:
	if multiplier == 1.0:
		return
	ModLoaderLog.debug.call_deferred("Adjusted %s from %s" % [prop_name, a[prop_name]], TEAM2_MORE_TO_MINE_LOG_NAME)
	a[prop_name] *= multiplier
	ModLoaderLog.debug.call_deferred("Adjusted %s to %s" % [prop_name, a[prop_name]], TEAM2_MORE_TO_MINE_LOG_NAME)
	ModLoaderLog.debug.call_deferred("Adjusted %s multiplied by %s" % [prop_name, multiplier], TEAM2_MORE_TO_MINE_LOG_NAME)


func print_generated_resource(cell, resource_name: String):
	if GameWorld.devMode or OS.is_debug_build():
		ModLoaderLog.debug.call_deferred("Generated \"%s\" at: \"%s\"" % [resource_name, cell], TEAM2_MORE_TO_MINE_LOG_NAME)
