extends "res://content/dome/shredder/Shredder.gd"


@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals = team_2_mod_node.globals


func _on_Shredder_area_entered(area):
	super._on_Shredder_area_entered(area)

	for resorce in team_2_globals.resources:
		var drop = area.getDeliverableDrop(resorce.type)
		if drop:
			drop.floatToDropTarget(self)
			if not dropsInRange.has(drop):
				dropsInRange.append(drop)
			return
