extends Object


func getDropTarget(chain: ModLoaderHookChain, dropType:String):
	var target = chain.execute_next([dropType])

	if target:
		return target

	var ref: Dome = chain.reference_object
	var mod_node := ref.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals = mod_node.globals

	for resource in globals.resources:
		if resource.type == dropType:
			target = ref.get_node("Shredder")
			break

	return target
