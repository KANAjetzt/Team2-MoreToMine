extends Object


func _ready(chain: ModLoaderHookChain):
	chain.execute_next()
	var ref: TransportDrone = chain.reference_object
	# Not sure how the style is applied to the carried resources
	# But we need to add it to the styled group so we can
	# call Style.init() after we remove the material from our modded resources.
	# Without that, the vanilla resources have no palette applied.
	ref.get_node("CarriedResource").add_to_group("styled")


func setCarriedResource(chain: ModLoaderHookChain, res:String) -> void:
	var ref: TransportDrone = chain.reference_object
	var mod_node: Node = chain.reference_object.get_node("/root/ModLoader/Team2-MoreToMine")
	var globals = mod_node.globals
	var is_modded_resource := false

	for resource in globals.resources:
		if resource.type == res:
			ref.get_node("CarriedResource").texture = resource.texture
			ref.get_node("CarriedResource").material = null
			ref.get_node("Sprite").play("carry_idle")
			ref.get_node("SpriteOverlay").visible = true
			ref.get_node("SpriteOverlay").play("carry_idle")
			ref.get_node("PickupSound").play()
			is_modded_resource = true
			break

	# Restyle the resource sprite if it is not modded
	if not is_modded_resource:
		Style.init(ref.get_node("CarriedResource"))

	chain.execute_next([res])

