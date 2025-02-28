extends "res://content/techtree/Tech2.gd"

var parts = ['magnetic_screws', 'sintered_metal', 'absorption_hull', 'micro_gear', 'liquefier', 'coated_lens', 'dampener_ring', 'dynamic_dampener',
	'ruby_coated_lens', 'lens_array', 'energy_casing', 'fusion_cell', 'plasma_cell', 'vacuum_energy_cell', 'nano_circuit_board', 'data_matrix', 'crystalic_filter',
	'phase_coil', 'coil_grid', 'pulse_emitter', 'modular_pulse_emitter', 'modular_beam_emitter', 'overload_buffer', 'pivot_mechanism', 'feedback_buffer',
	'rail_track', 'magnetic_rail_system', 'cryo_magnet_rail_system', 'servo_motor', 'servo_drive', 'absorption_field_generator']

func build(id:String, tier := -1):
	Data.apply("inventory.iron", 10)
	Data.apply("inventory.water", 10)
	Data.apply("inventory.cobalt", 10)
	Data.apply("inventory.copper", 10)
	Data.apply("inventory.tungsten", 0)
	Data.apply("inventory.quartz", 10)
	Data.apply("inventory.ruby", 0)
	Data.apply("inventory.ionic_dust", 0)
	Data.apply("inventory.cryoflux", 0)
	
	#0 iron, 1 water, 2 cobalt, 3 copper, 4 tungsten, 5 quartz, 6 ruby, 7 ionic_dust, 8 cryoflux
	#9 magnetic_screws, 10 sintered_metal, 11 absorption_hull, 12 micro_gear, 13 liquefier
	#14 coated_lens, 15 dampener_ring, 16 dynamic_dampener, 17 ruby_coated_lens
	#18 lens_array, 19 energy_casing, 20 fusion_cell, 21 plasma_cell, 22 vacuum_energy_cell
	#23 nano_circuit_board, 24 data_matrix, 25 crystalic_filter, 26 phase_coil 27 coil_grid
	#28 pulse_emitter, 29 modular_pulse_emitter, 30 modular_beam_emitter, 31 overload_buffer
	#32 pivot_mechanism, 33 feedback_buffer, 34 rail_track, 35 magnetic_rail_system
	#36 cryo_magnet_rail_system, 37 servo_motor, 38 servo_drive, 39 absorption_field_generator
	
	for part in parts:
		Data.apply("inventory." + part, 0)
	
	self.techId = id
	var data = GameWorld.upgrades.get(id)
	visualTechId = data.get("shadowing", techId)
	$Costs.columns = 4
	if tier == 1:
		state = State.INITIAL
		$Icon.custom_minimum_size = Vector2.ONE * 144
		texture = preload("res://content/techtree/panels/big.png")
		$SelectedPanel.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		$SelectedPanel.texture = preload("res://content/techtree/panels/big_focus.png")
	$SelectedPanel.visible = false
	if data.has("cost"):
		var cost = data.get("cost")
		var costsBox = find_child("Costs")
		for costType in cost:
			var label = Label.new()
			label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
			label.size_flags_horizontal = label.SIZE_EXPAND_FILL 
			label.text = str(cost[costType])
			label.label_settings = preload("res://gui/fontsettings/NumbersFontSettings.tres")
			costsBox.add_child(label)
			costLabels[costType] = label
			
			var rect = TextureRect.new()
			var no_style = false
			rect.stretch_mode = TextureRect.STRETCH_KEEP
			var tex:Texture2D
			match costType:
				CONST.WATER:
					tex = preload("res://content/icons/icon_water.png")
				CONST.IRON:
					tex = preload("res://content/icons/icon_iron.png")
				CONST.SAND:
					tex = preload("res://content/icons/icon_sand.png")
				"copper":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/drop/copper/icon_copper.png")
					no_style = true
				"tungsten":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/drop/tungsten/icon_tungsten.png")
					no_style = true
				"quartz":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/drop/quartz/icon_quartz.png")
					no_style = true
				"ruby":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/drop/ruby/icon_ruby.png")
					no_style = true
				"ionic_dust":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/drop/ionic_dust/icon_ionic_dust.png")
					no_style = true
				"cryoflux":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/drop/cryoflux/icon_cryoflux.png")
					no_style = true
					
				"magnetic_screws":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/magnetic_screws.png")
					no_style = true
				"sintered_metal":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/sintered_metal.png")
					no_style = true
				"absorption_hull":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/absorption_hull.png")
					no_style = true
				"micro_gear":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/micro_gear.png")
					no_style = true
				"liquefier":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/liquefier.png")
					no_style = true
				"coated_lens":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/coated_lens.png")
					no_style = true
				"dampener_ring":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/dampener_ring.png")
					no_style = true
				"dynamic_dampener":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/dynamic_dampener.png")
					no_style = true
				"ruby_coated_lens":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/ruby_coated_lens.png")
					no_style = true
				"lens_array":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/lens_array.png")
					no_style = true
				"energy_casing":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/energy_casing.png")
					no_style = true
				"fusion_cell":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/fusion_cell.png")
					no_style = true
				"plasma_cell":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/plasma_cell.png")
					no_style = true
				"vacuum_energy_cell":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/vacuum_energy_cell.png")
					no_style = true
				"nano_circuit_board":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/nano_circuit_board.png")
					no_style = true
				"data_matrix":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/data_matrix.png")
					no_style = true
				"crystalic_filter":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/crystalic_filter.png")
					no_style = true
				"phase_coil":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/phase_coil.png")
					no_style = true
				"coil_grid":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/coil_grid.png")
					no_style = true
				"pulse_emitter":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/pulse_emitter.png")
					no_style = true
				"modular_pulse_emitter":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/modular_pulse_emitter.png")
					no_style = true
				"modular_beam_emitter":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/modular_beam_emitter.png")
					no_style = true
				"overload_buffer":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/overload_buffer.png")
					no_style = true
				"pivot_mechanism":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/pivot_mechanism.png")
					no_style = true
				"feedback_buffer":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/feedback_buffer.png")
					no_style = true
				"rail_track":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/rail_track.png")
					no_style = true
				"magnetic_rail_system":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/magnetic_rail_system.png")
					no_style = true
				"cryo_magnet_rail_system":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/cryo_magnet_rail_system.png")
					no_style = true
				"servo_motor":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/servo_motor.png")
					no_style = true
				"servo_drive":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/servo_drive.png")
					no_style = true
				"absorption_field_generator":
					tex = preload("res://mods-unpacked/Team2-MoreToMine/content/techtree/icons/absorption_field_generator.png")
					no_style = true
					
			if no_style:
				rect.material = null
				rect.add_to_group("unstyled")
			
			rect.texture = tex
			costsBox.add_child(rect)
	
	propertyChanges = data.get("propertychanges", [])
	if data.has("overwriteTitleKey"):
		title = tr(data.get("overwriteTitleKey"))
	else:
		title = tr("upgrades." + visualTechId + ".title")
	if data.has("overwriteDescKey"):
		explanationBb = tr(data.get("overwriteDescKey"))
	else:
		explanationBb = GameWorld.iconify(tr("upgrades." + visualTechId + ".desc"))
	
	updateState()
	
	icon = Data.loadIconOrFallback("res://content/icons/" + visualTechId + ".png")
	
	if visualTechId in parts or visualTechId in ['crafting1', 'crafting2', 'crafting3']:
		$Icon.add_to_group("unstyled")
	
	find_child("Icon").texture = icon
	
	_on_Tech_focus_exited()

func updateState():
	var tech = GameWorld.upgrades.get(techId)
	var isRepeatable:bool
	var repeatableTimes := -1
	if tech.has("repeatable"):
		var repdata = tech.get("repeatable")
		for change in repdata:
			if change.keyClass == "times":
				repeatableTimes = change.value
		isRepeatable = repeatableTimes != 0
		$RepetitionCountLabel.text = str(repeatableTimes)
	else:
		isRepeatable = false
	$RepetitionCountLabel.visible = repeatableTimes > 0
	
	$AnyAll.hide()
	
	var cost = tech.get("cost", [])
	for costType in cost:
		if costLabels.has(costType):
			costLabels[costType].text = str(cost[costType])
	
	if state != State.INITIAL:
		state = State.UNAVAILABLE
		if GameWorld.lockedUpgrades.has(techId):
			state = State.LOCKED
		elif (GameWorld.boughtUpgrades.has(techId) and not isRepeatable) or Data.gadgets.has(techId):
			state = State.BOUGHT
		else:
			if GameWorld.upgrades.has(techId):
				var unlocked = GameWorld.isUpgradeAddable(techId)
				if unlocked:
					state = State.AVAILABLE
				else:
					state = State.UNAVAILABLE
		
		if not has_focus():
			_on_Tech_focus_exited()
	
		var open = state == State.UNAVAILABLE or state == State.AVAILABLE
		find_child("Costs").visible = open
		var costsAmount = GameWorld.upgrades[techId].get("cost", []).size()
		match state:
			State.UNAVAILABLE:
				if costsAmount == 1:
					if isRepeatable:
						if repeatableTimes != -1:
							$RepetitionCountLabel.position.y = 81
							texture = preload("res://content/techtree/panels/one_reload_extra_dark.png")
						else:
							texture = preload("res://content/techtree/panels/one_reload_dark.png")
					else:
						texture = preload("res://content/techtree/panels/one_dark.png")
					
					if $AnyAll.visible:
						$AnyAll.texture = preload("res://content/techtree/panels/lock_dark.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/one_focus.png")
				else:
					if isRepeatable:
						if repeatableTimes != -1:
							$RepetitionCountLabel.position.y = 85
							texture = preload("res://content/techtree/panels/two_reload_extra_dark.png")
						else:
							texture = preload("res://content/techtree/panels/two_reload_dark.png")
					else:
						texture = preload("res://content/techtree/panels/two_dark.png")
					if $AnyAll.visible:
						$AnyAll.texture = preload("res://content/techtree/panels/lock_dark.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/two_focus.png")
			State.AVAILABLE:
				if costsAmount == 1:
					if isRepeatable:
						if repeatableTimes != -1:
							$RepetitionCountLabel.position.y = 81
							texture = preload("res://content/techtree/panels/one_reload_extra_bright.png")
						else:
							texture = preload("res://content/techtree/panels/one_reload_bright.png")
					else:
						texture = preload("res://content/techtree/panels/one_bright.png")
					if $AnyAll.visible:
						$AnyAll.texture = preload("res://content/techtree/panels/lock_bright.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/one_focus.png")
				else:
					if isRepeatable:
						if repeatableTimes != -1:
							$RepetitionCountLabel.position.y = 85
							texture = preload("res://content/techtree/panels/two_reload_extra_bright.png")
						else:
							texture = preload("res://content/techtree/panels/two_reload_bright.png")
					else:
						texture = preload("res://content/techtree/panels/two_bright.png")
					if $AnyAll.visible:
						$AnyAll.texture = preload("res://content/techtree/panels/lock_bright.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/two_focus.png")
			State.BOUGHT:
				if Data.supplements.has(techId):
					texture = preload("res://content/techtree/panels/square_bright.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/square_focus.png")
				else:
					texture = preload("res://content/techtree/panels/zero_bright.png")
					if $AnyAll.visible:
						$AnyAll.texture = preload("res://content/techtree/panels/lock_bright.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/zero_focus.png")
			State.LOCKED:
				if Data.supplements.has(techId):
					texture = preload("res://content/techtree/panels/square_dark.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/square_focus.png")
				else:
					texture = preload("res://content/techtree/panels/zero_dark.png")
					if $AnyAll.visible:
						$AnyAll.texture = preload("res://content/techtree/panels/lock_dark.png")
					$SelectedPanel.texture = preload("res://content/techtree/panels/zero_focus.png")
	
	pivot_offset = texture.get_size() * 0.5
	
	if tech.has("craftable"):
		$RepetitionCountLabel.text = str(Data.of("inventory." + str(tech.get("id"))))
		$RepetitionCountLabel.visible = true
		texture = preload("res://content/techtree/panels/one_reload_extra_dark.png")
	
