class_name Team2ResourceData
extends Resource


@export var tile_id: int
## Used in many places to reference the resource type
## The "type" for iron is "iron"
## It's better to prefix modded stuff to prevent naming conflicts so all
## oure resources begin with "teamtwo".
@export var type: String
## Thats the small sprite
@export var texture: Texture
@export var texture_carry: Texture
@export var texture_focus: Texture
@export var icon: Texture
@export_file("*.tscn") var drop_scene_path: String
## The position of the resource sprites in the resources_sheet.png
## [code]res://mods-unpacked/Team2-MoreToMine/content/map/border/resources_sheet.png[/code]
@export var resource_sheet_location_center_start: Vector2
@export var resource_sheet_location_center_end: Vector2
@export var richness: int = 1
@export var drop_min: int = 1
@export var drop_max: int = 3
@export var spawn_per_layer_max: int = 3
@export var reverse_gravity := false
@export var reverse_gravity_strength := 100.0
