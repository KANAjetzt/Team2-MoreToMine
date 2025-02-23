class_name Team2ResourceData
extends Resource


@export var tile_id: int
@export var tile_string: String
@export var icon: Texture
@export var drop_scene: PackedScene
## The position of the resource sprites in the resources_sheet.png
## [code]res://mods-unpacked/Team2-MoreToMine/content/map/border/resources_sheet.png[/code]
@export var resource_sheet_location_center_start: Vector2
@export var resource_sheet_location_center_end: Vector2
@export var richness: int = 1
@export var drop_min: int = 1
@export var drop_max: int = 3
@export var spawn_per_layer_max: int = 3
