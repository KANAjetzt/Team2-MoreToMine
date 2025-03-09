extends "res://content/gadgets/droneyard/Squidley.gd"


@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals = team_2_mod_node.globals


func setCarriedResource(res:String):
	for resource in team_2_globals.resources:
		if resource.type == res:
			$CarriedResource.texture = resource.texture
			$Sprite2D.play("idle")
			$PickupSound.play()
			break

	super.setCarriedResource(res)
