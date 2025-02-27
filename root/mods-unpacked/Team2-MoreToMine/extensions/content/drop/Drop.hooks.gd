extends Object


func _physics_process(chain: ModLoaderHookChain, delta) -> void:
	chain.execute_next([delta])
	var ref: Drop = chain.reference_object

	if not ref.get("data"):
		return

	if not ref.isCarried() and ref.data.reverse_gravity:
		ref.apply_central_force(Vector2(0, -ref.data.reverse_gravity_strength))
