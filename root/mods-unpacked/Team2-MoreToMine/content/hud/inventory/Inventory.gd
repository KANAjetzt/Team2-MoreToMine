extends "res://content/hud/inventory/Inventory.gd"

func init():
	super.init()
	cache = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	set("element_size", Vector2(6, 18))
	Data.listen(self, "inventory.copper", true)
	Data.listen(self, "inventory.tungsten", true)
	Data.listen(self, "inventory.quartz", true)
	Data.listen(self, "inventory.ruby", true)
	Data.listen(self, "inventory.ionic_dust", true)
	Data.listen(self, "inventory.cryoflux", true)
	
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
		gContainer.add_child(label)

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
			cache[2] = newValue
			updateSize()
			find_child("LabelCopper", false, true).text = str(newValue)
		"inventory.tungsten":
			cache[2] = newValue
			updateSize()
			find_child("LabelTungsten", false, true).text = str(newValue)
		"inventory.quartz":
			cache[2] = newValue
			updateSize()
			find_child("LabelQuartz", false, true).text = str(newValue)
		"inventory.ruby":
			cache[2] = newValue
			updateSize()
			find_child("LabelRuby", false, true).text = str(newValue)
		"inventory.ionic_dust":
			cache[2] = newValue
			updateSize()
			find_child("LabelIonic_dust", false, true).text = str(newValue)
		"inventory.cryoflux":
			cache[2] = newValue
			updateSize()
			find_child("LabelCryoflux", false, true).text = str(newValue)
