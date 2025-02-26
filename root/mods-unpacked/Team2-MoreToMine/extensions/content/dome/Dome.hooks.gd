extends Object


func getDropTarget(chain: ModLoaderHookChain, dropType:String):
	var target = chain.execute_next()
	var ref: Dome = chain.reference_object
	var mod_node := ref.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals: Team2Globals = mod_node.globals

	if not target:
		for resource in globals.resources:
			if resource.type == dropType:
				target = ref.get_node("Shredder")
				break

	return target
