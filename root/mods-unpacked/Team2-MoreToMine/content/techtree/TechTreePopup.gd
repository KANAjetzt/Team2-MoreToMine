extends "res://content/techtree/TechTreePopup.gd"

func _ready():
	position.y += size.y
	find_child("TechTree").build(prefixMappings, rootsToIgnore)
	var gContainer = $PanelContainer/VBoxContainer/BoxContainer/TechInfo/Inventory/PanelContainer/MarginContainer/VBoxContainer/GridContainer
	var materials = [
	{ "name": "Copper", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/copper/icon_copper.png" },
	{ "name": "Tungsten", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/tungsten/icon_tungsten.png" },
	{ "name": "Quartz", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/quartz/icon_quartz.png" },
	{ "name": "Ruby", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/ruby/icon_ruby.png" },
	{ "name": "Ionic_dust", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/ionic_dust/icon_ionic_dust.png" },
	{ "name": "Cryoflux", "texture": "res://mods-unpacked/Team2-MoreToMine/content/drop/cryoflux/icon_cryoflux.png" }
	]
	var base_texture_rect = $PanelContainer/VBoxContainer/BoxContainer/TechInfo/Inventory/PanelContainer/MarginContainer/VBoxContainer/GridContainer/TextureRect
	var base_label = $PanelContainer/VBoxContainer/BoxContainer/TechInfo/Inventory/PanelContainer/MarginContainer/VBoxContainer/GridContainer/LabelIron
	var base_cost_label = %LabelIronCost
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
		gContainer.add_child(label)
		var cost_label = base_cost_label.duplicate()
		cost_label.name = "Label" + material["name"] + "Cost"
		gContainer.add_child(cost_label)
	
	find_child("Inventory").visible = true
	find_child("LabelIron").text = str(Data.getInventory(CONST.IRON))
	find_child("LabelWater").text = str(Data.getInventory(CONST.WATER))
	find_child("LabelSand").text = str(Data.getInventory(CONST.SAND))
	find_child("LabelCopper", true, false).text = str(Data.getInventory("copper"))
	find_child("LabelTungsten", true, false).text = str(Data.getInventory("tungsten"))
	find_child("LabelQuartz", true, false).text = str(Data.getInventory("quartz"))
	find_child("LabelRuby", true, false).text = str(Data.getInventory("ruby"))
	find_child("LabelIonic_dust", true, false).text = str(Data.getInventory("ionic_dust"))
	find_child("LabelCryoflux", true, false).text = str(Data.getInventory("cryoflux"))

	Data.listen(self, "inventory.iron")
	Data.listen(self, "inventory.water")
	Data.listen(self, "inventory.sand")
	Data.listen(self, "inventory.copper")
	Data.listen(self, "inventory.tungsten")
	Data.listen(self, "inventory.quartz")
	Data.listen(self, "inventory.ruby")
	Data.listen(self, "inventory.ionic_dust")
	Data.listen(self, "inventory.cryoflux")
	
	Style.init(self)
	
	#duplicate to override color
	%LabelIronCost.label_settings = %LabelIronCost.label_settings.duplicate()
	%LabelWaterCost.label_settings = %LabelWaterCost.label_settings.duplicate()
	%LabelSandCost.label_settings  =%LabelSandCost.label_settings.duplicate()
	find_child("LabelCopperCost", true, false).label_settings = find_child("LabelCopperCost", true, false).label_settings.duplicate()
	find_child("LabelTungstenCost", true, false).label_settings = find_child("LabelTungstenCost", true, false).label_settings.duplicate()
	find_child("LabelQuartzCost", true, false).label_settings = find_child("LabelQuartzCost", true, false).label_settings.duplicate()
	find_child("LabelRubyCost", true, false).label_settings = find_child("LabelRubyCost", true, false).label_settings.duplicate()
	find_child("LabelIonic_dustCost", true, false).label_settings = find_child("LabelIonic_dustCost", true, false).label_settings.duplicate()
	find_child("LabelCryofluxCost", true, false).label_settings = find_child("LabelCryofluxCost", true, false).label_settings.duplicate()
	
	defaultFontColor = %LabelIronCost.label_settings.font_color

func propertyChanged(property:String, oldValue, newValue):
	match property:
		"inventory.iron":
			find_child("LabelIron").text = str(clamp(newValue, 0, 999))
		"inventory.water":
			find_child("LabelWater").text = str(clamp(newValue, 0, 999))
		"inventory.sand":
			find_child("LabelSand").text = str(clamp(newValue, 0, 999))
		"inventory.copper":
			find_child("LabelCopper", true, false).text = str(clamp(newValue, 0, 999))
		"inventory.tungsten":
			find_child("LabelTungsten", true, false).text = str(clamp(newValue, 0, 999))
		"inventory.quartz":
			find_child("LabelQuartz", true, false).text = str(clamp(newValue, 0, 999))
		"inventory.ruby":
			find_child("LabelRuby", true, false).text = str(clamp(newValue, 0, 999))
		"inventory.ionic_dust":
			find_child("LabelIonic_dust", true, false).text = str(clamp(newValue, 0, 999))
		"inventory.cryoflux":
			find_child("LabelCryoflux", true, false).text = str(clamp(newValue, 0, 999))
	updateCostLabels()

func moveOut():
	if not isIn:
		return
	
	isIn = false
	
	Data.unlisten(self, "inventory.iron")
	Data.unlisten(self, "inventory.water")
	Data.unlisten(self, "inventory.sand")
	Data.unlisten(self, "inventory.copper")
	Data.unlisten(self, "inventory.tungsten")
	Data.unlisten(self, "inventory.quartz")
	Data.unlisten(self, "inventory.ruby")
	Data.unlisten(self, "inventory.ionic_dust")
	Data.unlisten(self, "inventory.cryoflux")
	Data.apply("dome.potentialrepair", 0)

	$Tween.interpolate_property(self, "position:y", position.y, get_viewport_rect().size.y, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.interpolate_callback(self, 0.5, "queue_free")
	$Tween.start()
	
	if focussedPanel:
		focussedPanel.release_focus()
	focussedPanel = null

func updateCostLabels():
	find_child("LabelIronCost").text = ""
	find_child("LabelWaterCost").text = ""
	find_child("LabelSandCost").text = ""
	find_child("LabelCopperCost", true, false).text = ""
	find_child("LabelTungstenCost", true, false).text = ""
	find_child("LabelQuartzCost", true, false).text = ""
	find_child("LabelRubyCost", true, false).text = ""
	find_child("LabelIonic_dustCost", true, false).text = ""
	find_child("LabelCryofluxCost", true, false).text = ""
	
	if not focussedPanel:
		return
	
	var upgrade = GameWorld.upgrades[focussedPanel.techId]
	var costs = upgrade.get("cost", [])
	for costType in costs:
		var cost = costs[costType]
		var newInventory = int(Data.getInventory(costType)) - int(cost)
		var color = defaultFontColor
		if GameWorld.boughtUpgrades.has(focussedPanel.techId) and not upgrade.has("repeatable"):
			newInventory = 0
		if newInventory < 0:
			color = Style.FONT_COLOR_WARNING
		if costType in ["iron", "water", "sand", "copper", "tungsten", "quartz", "ruby", "ionic_dust", "cryoflux"]:
			print("----------------")
			print(costType)
			find_child("Label"+costType.capitalize()+"Cost", true, false).text = "%s" % cost
			find_child("Label"+costType.capitalize()+"Cost", true, false).label_settings.font_color = color
