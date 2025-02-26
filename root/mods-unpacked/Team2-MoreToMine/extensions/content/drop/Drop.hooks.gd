extends Object


func _physics_process(chain: ModLoaderHookChain, delta) -> void:
	chain.execute_next()
	var ref: Drop = chain.reference_object

	if not ref.isCarried():
		ref.apply_central_force(Vector2(0, 10))
