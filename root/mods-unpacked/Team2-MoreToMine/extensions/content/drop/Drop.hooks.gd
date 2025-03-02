extends Object


func _physics_process(chain: ModLoaderHookChain, delta) -> void:
	chain.execute_next([delta])
	var ref: Drop = chain.reference_object

	if not ref.get("data"):
		return

	if not ref.isCarried() and not ref.dropTargetRef and ref.data.reverse_gravity:
		ref.apply_central_force(Vector2(0, -ref.data.reverse_gravity_strength))


func onCarried(chain: ModLoaderHookChain, p) -> void:
	chain.execute_next([p])
	var ref: Drop = chain.reference_object

	if not ref.get("data"):
		return

	if ref.data.increase_speed_los_per_carry:
		Data.changeByInt("player1.keeper1.speedLossPerCarry", ref.data.increase_speed_los_per_carry_amount)


func onDropped(chain: ModLoaderHookChain, p) -> void:
	chain.execute_next([p])
	var ref: Drop = chain.reference_object

	if not ref.get("data"):
		return

	if ref.data.increase_speed_los_per_carry:
		Data.changeByInt("player1.keeper1.speedLossPerCarry", -ref.data.increase_speed_los_per_carry_amount)
