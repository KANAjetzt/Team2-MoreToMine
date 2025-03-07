extends "res://content/gadgets/ressourcepacker/ResourcePackerEffect.gd"


@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals = team_2_mod_node.globals


func _getRelevantBodies(area:Area2D) -> Array:
	var drops := super._getRelevantBodies(area)
	var max = Data.of("resourcepacker.packcount")

	if drops.size() >= max:
		return drops

	for drop in area.get_overlapping_bodies():
		if drop is Drop and drop.get("data"):
			drops.push_back(drop)
			var inf = drop.getCarryInfluence()
			if inf and inf.bundle:
				bundle = inf.bundle
				bundleInfluence = inf

	drops.sort_custom(sort_by_distance_asc)

	while(drops.size() > max):
		drops.pop_back()

	return drops
