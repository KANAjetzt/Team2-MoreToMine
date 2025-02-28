extends Object


func _ready(chain: ModLoaderHookChain):
	chain.execute_next()

	var main_node : Node = chain.reference_object
	var res_sprite: Sprite2D = main_node.res_sprite

	if res_sprite:
		res_sprite.texture = load("res://mods-unpacked/Team2-MoreToMine/content/map/border/resources_sheet.png")


func setType(chain: ModLoaderHookChain, type:String):
	chain.execute_next([type])

	var main_node : Node = chain.reference_object
	var mod_node := main_node.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals = mod_node.globals

	main_node.type = type

	for resource in globals.resources:
		if resource.type == type:
			var baseHealth:float = Data.of("map.tileBaseHealth")

			main_node.set_meta("destructable", true)
			main_node.initResourceSprite(
				Vector2(
					randi_range(resource.resource_sheet_location_center_start.x, resource.resource_sheet_location_center_end.x),
					randi_range(resource.resource_sheet_location_center_start.y, resource.resource_sheet_location_center_end.y)
				)
			)
			baseHealth += Data.of("map.sandAdditionalHealth")

			var healthMultiplier:float = 1.0
			match int(main_node.hardness):
				0:
					main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier0")
				1:
					main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier1")
				2:
					main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier2")
				3:
					main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier3")
				4:
					main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier4")
				5:
					main_node.hardnessMultiplier = Data.of("map.hardnessMultiplier5")
				_:
					main_node.hardnessMultiplier = 1

			healthMultiplier *= main_node.hardnessMultiplier
			healthMultiplier *= (pow(Data.of("map.tileHealthMultiplierPerLayer"), main_node.layer))

			var max_health = max(1, round(healthMultiplier * resource.hardness_multiplier * baseHealth))
			main_node.max_health = max_health
			main_node.health = max_health
