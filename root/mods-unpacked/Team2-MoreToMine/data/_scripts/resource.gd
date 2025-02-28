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
## Drop mass in kg - does not affect the ammount that can be carried.
@export var mass := 1.0
@export var increase_speed_los_per_carry := false
## This will add to speedLossPerCarry if a drop is picked up.
## Check jetpackStrength1 upgrade for reference
## jetpackStrength1 = keeper1.speedLossPerCarry = 2.15
## jetpackStrength2 = keeper1.speedLossPerCarry = 0.9
@export var increase_speed_los_per_carry_amount := 0.5
## This is an additional hardness multiplier to the one
## applied based on the rock type.
@export var hardness_multiplier := 1.0
## Use this to adjust the depth where the resource will start to spawn.
## Example: 0.0 = starts to spawn at the top of the map.
## Example: 0.5 = starts to spawn at half of the maps depth.
@export_range(0.0, 1.0) var spawn_depth_min_multiplier := 0.0
## The maximum depth of tiles where a resource will spawn.
## Example: 1.0 = ends to spawn at the end of the map.
## Example: 0.5 = will stop spawning at half of the maps depth.
@export_range(0.0, 1.0) var spawn_depth_max_multiplier := 1.0
