extends "res://content/hud/inventory/Inventory.gd"


func init():
	super.init()
	#0 iron, 1 water, 2 cobalt, 3 copper, 4 tungsten, 5 quartz, 6 ruby, 7 ionic_dust, 8 cryoflux
	#9 magnetic_screws, 10 sintered_metal, 11 absorption_hull, 12 micro_gear, 13 liquefier
	#14 coated_lens, 15 dampener_ring, 16 dynamic_dampener, 17 ruby_coated_lens
	#18 lens_array, 19 energy_casing, 20 fusion_cell, 21 plasma_cell, 22 vacuum_energy_cell
	#23 nano_circuit_board, 24 data_matrix, 25 crystalic_filter, 26 phase_coil 27 coil_grid
	#28 pulse_emitter, 29 modular_pulse_emitter, 30 modular_beam_emitter, 31 overload_buffer
	#32 pivot_mechanism, 33 feedback_buffer, 34 rail_track, 35 magnetic_rail_system
	#36 cryo_magnet_rail_system, 37 servo_motor, 38 servo_drive, 39 absorption_field_generator
	cache = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	element_size = Vector2(5, 18)
	request_rebuild.emit()
	var gContainer = $GridContainer
	var materials = [
	{ "name": "Copper", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/copper/icon_copper.png" },
	{ "name": "Tungsten", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/tungsten/icon_tungsten.png" },
	{ "name": "Quartz", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/quartz/icon_quartz.png" },
	{ "name": "Ruby", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/ruby/icon_ruby.png" },
	{ "name": "Ionic_dust", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/ionic_dust/icon_ionic_dust.png" },
	{ "name": "Cryoflux", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/cryoflux/icon_cryoflux.png" }
	]
	var base_texture_rect = $GridContainer/TextureRect1
	var base_label = %LabelIron
	for i in range(materials.size()):
		var material = materials[i]
		var index = i + 4
		var texture_rect = base_texture_rect.duplicate()
		texture_rect.texture = load(material["texture"])
		texture_rect.name = "TextureRect" + str(index)
		texture_rect.material = null
		texture_rect.add_to_group("unstyled")
		gContainer.add_child(texture_rect)
		var label = base_label.duplicate()
		label.name = "Label" + material["name"]
		label.text = str(0)
		gContainer.add_child(label)

	Data.listen(self, "inventory.copper", true)
	Data.listen(self, "inventory.tungsten", true)
	Data.listen(self, "inventory.quartz", true)
	Data.listen(self, "inventory.ruby", true)
	Data.listen(self, "inventory.ionic_dust", true)
	Data.listen(self, "inventory.cryoflux", true)


func propertyChanged(property:String, oldValue, newValue):
	match property:
		"inventory.iron":
			cache[0] = newValue
			updateSize()
			find_child("LabelIron").text = str(newValue)
		"inventory.water":
			cache[1] = newValue
			updateSize()
			find_child("LabelWater").text = str(newValue)
		"inventory.sand":
			cache[2] = newValue
			updateSize()
			find_child("LabelSand").text = str(newValue)
		"inventory.copper":
			cache[3] = newValue
			updateSize()
			$GridContainer/LabelCopper.text = str(newValue)
		"inventory.tungsten":
			cache[4] = newValue
			updateSize()
			$GridContainer/LabelTungsten.text = str(newValue)
		"inventory.quartz":
			cache[5] = newValue
			updateSize()
			$GridContainer/LabelQuartz.text = str(newValue)
		"inventory.ruby":
			cache[6] = newValue
			updateSize()
			$GridContainer/LabelRuby.text = str(newValue)
		"inventory.ionic_dust":
			cache[7] = newValue
			updateSize()
			$GridContainer/LabelIonic_dust.text = str(newValue)
		"inventory.cryoflux":
			cache[8] = newValue
			updateSize()
			$GridContainer/LabelCryoflux.text = str(newValue)


func updateSize():
	super.updateSize()

	var label_copper = get_node_or_null("GridContainer/LabelCopper")
	var width_default = 5
	var width_extended = 6

	if not label_copper:
		return

	var limit := 0
	for v in cache:
		limit = max(v, limit)
	if limit >= 100 and element_size.x != width_extended:
		element_size.x = width_extended
		%LabelIron.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		%LabelWater.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		%LabelSand.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$GridContainer/LabelCopper.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$GridContainer/LabelTungsten.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$GridContainer/LabelQuartz.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$GridContainer/LabelRuby.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$GridContainer/LabelIonic_dust.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$GridContainer/LabelCryoflux.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		request_rebuild.emit()
	elif limit < 100 and element_size.x != width_default:
		element_size.x = width_default
		%LabelIron.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		%LabelWater.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		%LabelSand.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$GridContainer/LabelCopper.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$GridContainer/LabelTungsten.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$GridContainer/LabelQuartz.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$GridContainer/LabelRuby.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$GridContainer/LabelIonic_dust.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$GridContainer/LabelCryoflux.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		request_rebuild.emit()
