extends "res://content/gadgets/mineraltree/MineralTree.gd"


@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals = team_2_mod_node.globals


func updateFruitType() -> void:
	var rootedResources := {CONST.IRON: 1}
	for rootCoord in rootCoords:
		var res = Level.map.getTileData().get_resourcev(rootCoord)
		for resource in team_2_globals.resources:
			if int(res) == resource.tile_id:
				rootedResources[resource.type] = 1 + rootedResources.get(resource.type, 0)

		for f in fruits[fruitStage]:
			for resource in team_2_globals.resources:
				if f.type == resource.type:
					rootedResources[resource.type] = rootedResources.get(resource.type, 0) - 1

	for fs in fruits[fruitStage]:
		if not fs.type or fs.type == "":
			for resource in team_2_globals.resources:
				# decide on a new fruit
				var type: String
				if rootedResources.get(resource.type, 0) > 0:
					type = resource.type
					rootedResources[resource.type] = rootedResources.get(resource.type, 0) - 1

				if type:
					fs.setType(type)
				else:
					var team_2_resource_types: Array = team_2_globals.resources.map(
						func map(element):
							return element.type
					)
					var all_resource_types := [CONST.SAND, CONST.WATER, CONST.IRON]
					all_resource_types.append_array(team_2_resource_types)

					for t in all_resource_types:
						for fs2 in fruits[fruitStage]:
							if fs2.type == t and fs.totalCycles >= 5:
								fs.setType(t)

	super.updateFruitType()


# NOTE: This will cause double rooting on modded resources
# NOTE: because the vanilla function is called and will not find a resource,
# NOTE: and if no resource is found, a random tile is rooted.
func tryRooting():
	super.tryRooting()

	var baseCoord = rootCoords.front()

	var randDir : Array = CONST.DIRECTIONS.duplicate()
	randDir.shuffle()
	var roots = rootCoords.duplicate()
	roots.shuffle()
	var freeTiles := []
	for root in roots:
		for d in randDir:
			var coord = root + d
			if rootCoords.has(coord) or (baseCoord - coord).length() >= 30: # TODO implement root spread on backwall
				continue
			var res = Level.map.getTileData().get_resourcev(root + d)

			for resource in team_2_globals.resources:
				if res == resource.tile_id:
					growOnTile(coord)
					return


func tryGrowingStem():
	super.tryGrowingStem()

	var modded_resource_tiles := 0

	for rootCoord in rootCoords:
		var res = Level.map.getTileData().get_resourcev(rootCoord)
		for resource in team_2_globals.resources:
				if res == resource.tile_id:
					modded_resource_tiles += 1
					break

	if currentGrowthStage == 5 and modded_resource_tiles >= 2:
		currentGrowthStage = 10
	elif currentGrowthStage == 10 and modded_resource_tiles >= 3:
		currentGrowthStage = 15

	$Stem.frame = currentGrowthStage
