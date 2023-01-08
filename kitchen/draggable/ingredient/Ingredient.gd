extends Draggable
class_name Ingredient


var ready_to_plate = true setget , ready_to_plate
var ingredient_name = "tomato" setget set_ingredient_name, get_ingredient_name
var tomato_texture = preload("res://addons/kenney_prototype_textures/red/texture_01.png")
var lettuce_texture = preload("res://addons/kenney_prototype_textures/green/texture_01.png")
var eggplant_texture = preload("res://addons/kenney_prototype_textures/purple/texture_01.png")

onready var sprite = $Sprite


func _ready() -> void:
	if ingredient_name == "tomato":
		sprite.texture = tomato_texture
	elif ingredient_name == "lettuce":
		sprite.texture = lettuce_texture
	else:
		sprite.texture = eggplant_texture
			

func set_ingredient_name(value: String) -> void:
	ingredient_name = value


func get_ingredient_name() -> String:
	return ingredient_name


func ready_to_plate() -> bool:
	return ready_to_plate


func _on_Hitbox_body_entered(body: Node) -> void:
	if body == self:
		return
	if body as Ingredient:
		$Hitbox/CollisionShape2D.queue_free()
		$CollisionShape2D.queue_free()
		print(str(body))
