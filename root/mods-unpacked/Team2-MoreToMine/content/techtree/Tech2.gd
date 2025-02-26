extends "res://content/techtree/Tech2.gd"

func build(id:String, tier := -1):
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
		$RepetitionCountLabel.text = str(Data.get("inventory." + str(tech.get("id"))))
		#$RepetitionCountLabel.text = str(Data.of("inventory.iron"))
		$RepetitionCountLabel.visible = true
		texture = preload("res://content/techtree/panels/one_reload_extra_dark.png")
	
