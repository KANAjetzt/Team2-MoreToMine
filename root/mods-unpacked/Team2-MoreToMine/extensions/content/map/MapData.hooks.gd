extends Object


func get_mineable_tile_coords(chain: ModLoaderHookChain) -> Array:
	var coords = chain.execute_next()
	var main_node : Node = chain.reference_object
	var mod_node := main_node.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals = mod_node.globals

	for resource in globals.resources:
		coords.append_array(main_node.get_resource_cells_by_id(resource.tile_id))

	return coords
