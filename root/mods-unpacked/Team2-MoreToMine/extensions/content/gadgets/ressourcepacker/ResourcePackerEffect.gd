extends "res://content/gadgets/ressourcepacker/ResourcePackerEffect.gd"


func _getRelevantBodies(area:Area2D) -> Array:
	var max = Data.of("resourcepacker.packcount")
	var used :=0
	var drops := []
	for drop in area.get_overlapping_bodies():
		if drop is Drop and (
			drop.type == "iron" or
			drop.type == "water" or
			drop.type == "sand" or
			drop.type == "copper" or
			drop.type == "cryoflux" or
			drop.type == "ionic_dust" or
			drop.type == "quartz" or
			drop.type == "ruby" or
			drop.type == "tungsten"
			):
			drops.append(drop)
			var inf = drop.getCarryInfluence()
			if inf and inf.bundle:
				bundle = inf.bundle
				bundleInfluence = inf

	drops.sort_custom(sort_by_distance_asc)

	while(drops.size() > max):
		drops.pop_back()

	return drops
