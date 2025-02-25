extends Object


func init(chain: ModLoaderHookChain, fromDeserialize := false, generateChambers := true):
	chain.execute_next([fromDeserialize, generateChambers])
	var main_node : Node = chain.reference_object
	var mod_node := main_node.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals: Team2Globals = mod_node.globals

	for resource in globals.resources:
		main_node.tilesByType[resource.tile_string] = []
		Data.TILE_ID_TO_STRING_MAP[resource.tile_id] = resource.tile_string


func isResourceTile(chain: ModLoaderHookChain, typeId: int) -> bool:
	var mod_node: Node = chain.reference_object.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals: Team2Globals = mod_node.globals

	var result: bool = chain.execute_next([typeId])

	for resource in globals.resources:
		if resource.tile_id == typeId:
			result = true

	return result


func revealTile(chain: ModLoaderHookChain, coord:Vector2):
	var main_node : Node = chain.reference_object
	var mod_node := main_node.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals: Team2Globals = mod_node.globals
	var is_modded_resource := false

	var typeId:int = main_node.tileData.get_resource(coord.x, coord.y)

	for resource in globals.resources:
		if resource.tile_id == typeId:
			is_modded_resource = true

	if is_modded_resource:
		var invalids := []

		if main_node.tileRevealedListeners.has(coord):
			for listener in main_node.tileRevealedListeners[coord]:
				if is_instance_valid(listener):
					listener.tileRevealed(coord)
				else:
					invalids.append(listener)
			for invalid in invalids:
				main_node.tileRevealedListeners.erase(invalid)

		if typeId == Data.TILE_EMPTY:
			return

		if main_node.tiles.has(coord):
			return

		var tile: Tile = main_node.tile_scene.instantiate()
		var biomeId:int = main_node.tileData.get_biome(coord.x, coord.y)
		tile.layer = biomeId
		tile.biome = main_node.biomes[tile.layer]
		tile.position = coord * GameWorld.TILE_SIZE
		tile.coord = coord
		tile.hardness = main_node.tileData.get_hardness(coord.x, coord.y)
		tile.type = Data.TILE_ID_TO_STRING_MAP.get(typeId, "dirt")

		# !! MODDED CODE START !! #
		for resource in globals.resources:
			if resource.tile_string == tile.type:
				tile.richness = resource.richness
				main_node.revealTileVisually(coord)
		# !! MODDED CODE END !! #

		main_node.tiles[coord] = tile

		if main_node.tilesByType.has(tile.type):
			main_node.tilesByType[tile.type].append(tile)
		tile.destroyed.connect(main_node.destroyTile.bind(tile))

		main_node.tiles_node.add_child(tile)
		# !! MODDED CODE START !! #
		tile.res_sprite.add_to_group("unstyled")
		tile.res_sprite.material = null
		# !! MODDED CODE END !! #

		# Allow border tiles to fade correctly at edges of the map
		main_node.visibleTileCoords[coord] = typeId

	chain.execute_next([coord])


func destroyTile(chain: ModLoaderHookChain, tile, withDropsAndSound := true):
	chain.execute_next([tile, withDropsAndSound])

	var main_node : Node = chain.reference_object
	var mod_node := main_node.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals: Team2Globals = mod_node.globals
	var is_modded_tile := false

	for resource in globals.resources:
		if tile.type == resource.tile_string:
			is_modded_tile = true
			break

	# Skip if it is not a modded resource
	if not is_modded_tile:
		return

	Data.changeByInt("map.tilesDestroyed", 1)
	Recorder.recordTileDestroyed(tile.coord)
	if withDropsAndSound:
		var sound
		sound = main_node.find_child("TileDestroyedSand").duplicate(Node.DuplicateFlags.DUPLICATE_USE_INSTANTIATION)
		sound.setSimulatedPosition(tile.global_position)
		main_node.add_child(sound)
		sound.play()

		var goalRichness = tile.richness * Data.ofOr("resourcemodifiers.richness." + tile.type, 1.0)
		var drops

		# !! MODDED CODE START !! #
		for resource in globals.resources:
			if tile.type == resource.tile_string:
				drops = randi_range(resource.drop_min, resource.drop_max)
		# !! MODDED CODE END !! #

		for _i in range(0, drops):
			var drop = Data.DROP_SCENES.get(tile.type).instantiate()
			drop.position = tile.global_position + 0.6 * Vector2(GameWorld.HALF_TILE_SIZE - randf()*GameWorld.TILE_SIZE, GameWorld.HALF_TILE_SIZE - randf()*GameWorld.TILE_SIZE)
			drop.apply_central_impulse(Vector2(0, 40).rotated(randf() * TAU))
			main_node.call_deferred("addDrop", drop)
			GameWorld.incrementRunStat("resources_mined")

	if tile.hardness == 5:
		# border tile destroyed, make sure there are physical tiles around now
		main_node.buildBorderAroundTile(tile.coord, main_node.tileData.get_biomev(tile.coord))

	main_node.tiles.erase(tile.coord)
	for t in main_node.tilesByType.values():
		t.erase(tile)
	main_node.tilesByType.get(tile.type, {}).erase(tile)
	tile.queue_free()

	main_node.onTileRemoved(tile.coord)
#	for d in CONST.DIRECTIONS:
#		tileCoordsToReveal.append(tile.coord + d)
	main_node.tileCoordsToReveal.append(tile.coord)
	main_node.floodRevealTiles()
