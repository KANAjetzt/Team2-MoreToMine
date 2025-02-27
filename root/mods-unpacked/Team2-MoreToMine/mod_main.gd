extends Node


const TEAM2_MORE_TO_MINE_MOD_DIR := "Team2-MoreToMine"
const TEAM2_MORE_TO_MINE_LOG_NAME := "Team2-MoreToMine:Main"
const DOME_UPGRADE_NAME = "crafting"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var globals: Team2Globals = load("res://mods-unpacked/Team2-MoreToMine/data/globals.tres")


func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(TEAM2_MORE_TO_MINE_MOD_DIR)
	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	ModLoaderMod.install_script_extension(mod_dir_path + "/content/hud/inventory/Inventory.gd")
	ModLoaderMod.install_script_extension(mod_dir_path + "/content/techtree/Tech2.gd")
	ModLoaderMod.install_script_extension(mod_dir_path + "/content/techtree/TechTreePopup.gd")

	# Add translations
	add_translations()

	# TODO: Load fixed hooked vanilla scripts here


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/map/generation/TileDataGenerator.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("game/GameWorld.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("content/dome/shredder/Shredder.gd"))


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_hooks("res://content/map/Map.gd", extensions_dir_path.path_join("content/map/Map.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://content/map/MapData.gd", extensions_dir_path.path_join("content/map/MapData.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://content/map/tile/Tile.gd", extensions_dir_path.path_join("content/map/tile/Tile.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://content/dome/Dome.gd", extensions_dir_path.path_join("content/dome/Dome.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://content/drop/Drop.gd", extensions_dir_path.path_join("content/drop/Drop.hooks.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	ModLoaderLog.debug("%s is ready!" % TEAM2_MORE_TO_MINE_MOD_DIR, TEAM2_MORE_TO_MINE_LOG_NAME)
	add_to_group("mod_init")

	for resource in globals.resources:
		Data.DROP_ICONS[resource.type] = resource.icon
		Data.DROP_SCENES[resource.type] = load(resource.drop_scene_path)

func modInit() -> void:
	var path_to_mod_yaml := "res://mods-unpacked/Team2-MoreToMine/yaml/upgrades.yaml"
	ModLoaderLog.debug("Trying to parse YAML: %s" % path_to_mod_yaml, TEAM2_MORE_TO_MINE_LOG_NAME)
	Data.parseUpgradesYaml(path_to_mod_yaml)
	GameWorld.unlockedElements.push_back(DOME_UPGRADE_NAME)
	StageManager.level_ready.connect(
		func unlock():
			GameWorld.addUpgrade(DOME_UPGRADE_NAME)
	)
