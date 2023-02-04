extends Pickable
class_name Ingredient


export var chop_speed = 100
export var cook_speed = 5

var type: String setget set_type, get_type # eg "tomato"
var state: String = "raw" # chopped, cooked
var doneness: int = 0
var image_path: String = "res://assets/images/ingredients/"
var plate_layer: int = 0

onready var sprite: Sprite = $Sprite
onready var steam: Particles2D = $Steam


func _ready():
	update_texture(state)

func is_chopped() -> bool:
	return state == "chopped"


func is_cooked() -> bool:
	return state == "cooked"


func set_is_chopped(is_chopped: bool) -> void:
	if is_chopped:
		state = "chopped"	
		update_texture(state)


func set_doneness(val: int) -> void:
	doneness = val
	if doneness >= 100:
		set_is_cooked(true)


func set_is_cooked(is_cooked: bool) -> void:
	if is_cooked:
		state = "cooked"
		update_texture(state)
		steam.emitting = true


func set_plated():
	sprite.texture = load(image_path + str(type) + "-plated.png")


func update_texture(_state: String) -> void:
	if _state == "raw":
		sprite.texture = load(image_path + str(type) + ".png")
	elif _state == "chopped":
		$Sprite.texture = load(image_path + str(type) + "-cut.png")
	elif _state == "cooked":
		sprite.texture = load(image_path + str(type) + "-cut.png")
		print("TODO: create ingredient cooked texture")


func set_type(value: String) -> void:
	type = value
	if sprite:
		update_texture("raw")


func get_type() -> String:
	return type


func trash() -> void:
	queue_free()


func is_plateable():
	return is_cooked() and doneness <= 200 || is_chopped()


func same_as(other: Ingredient) -> bool:
	return get_type() == other.get_type()

