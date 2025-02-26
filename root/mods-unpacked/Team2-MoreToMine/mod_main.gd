extends Node


const TEAM2_MORE_TO_MINE_MOD_DIR := "Team2-MoreToMine"
const TEAM2_MORE_TO_MINE_LOG_NAME := "Team2-MoreToMine:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

var globals: Team2Globals = load("res://mods-unpacked/Team2-MoreToMine/data/globals.tres")


func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(TEAM2_MORE_TO_MINE_MOD_DIR)
	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	# Add translations
	add_translations()


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

	for resource in globals.resources:
		Data.DROP_ICONS[resource.type] = resource.icon
		Data.DROP_SCENES[resource.type] = resource.drop_scene
