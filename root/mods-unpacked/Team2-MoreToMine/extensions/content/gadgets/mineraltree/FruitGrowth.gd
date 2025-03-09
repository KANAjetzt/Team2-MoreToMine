extends "res://content/gadgets/mineraltree/FruitGrowth.gd"


@onready var team_2_mod_node: Node = ModLoader.get_node("Team2-MoreToMine")
@onready var team_2_globals = team_2_mod_node.globals


func setType(type:String):
	var is_modded_resource := false

	for resource in team_2_globals.resources:
		if resource.type == type:
			frame = -1 + int(name.substr(name.find("_") + 1))
			$Sprite2D.texture = resource.texture
			$Sprite2D.material = null
			cyclesToGrow = resource.mineral_tree_cycles_to_grow
			is_modded_resource = true
			break

	if not is_modded_resource:
		$Sprite2D.remove_from_group("styled")
		Style.init($Sprite2D)

	super.setType(type)
