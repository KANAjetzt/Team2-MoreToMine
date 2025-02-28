extends Drop

@export var data: Resource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var carry_sprite: Sprite2D = $CarrySprite
@onready var focus_sprite: Sprite2D = $FocusSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	type = data.type
	sprite_2d.texture = data.texture
	carry_sprite.texture = data.texture_carry
	focus_sprite.texture = data.texture_focus
	mass = data.mass
