extends "res://content/gadgets/teleporter/Teleporter.gd"


@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals = team_2_mod_node.globals


func canTeleportDrop(body):
	var can_teleport: bool = super.canTeleportDrop(body)

	for resource in team_2_globals.resources:
		if resource.type == body.type:
			can_teleport = true
			break

	return can_teleport
