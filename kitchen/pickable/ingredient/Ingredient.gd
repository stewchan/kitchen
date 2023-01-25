extends Pickable
class_name Ingredient


var type: String setget set_type, get_type # eg "tomato"
var is_chopped: bool = false
var doneness = 0 # 0 - 100 where 100 is done
var chop_speed = 100
var cook_speed = 5
var image_path: String = "res://assets/ingredients/"
var plate_layer: int = 0

onready var sprite: Sprite = $Sprite
onready var progress_bar: TextureProgress = $ProgressBar
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	progress_bar.value = 0
	update_texture()


func chop(delta: float):
	if is_chopped:
		return
	if not progress_bar.visible:
		progress_bar.show()
	if progress_bar.value < progress_bar.max_value:
		progress_bar.value += chop_speed * delta
	elif progress_bar.value >= progress_bar.max_value:
		is_chopped = true
		progress_bar.hide()
	update_texture()


func cook():
	if doneness >= 100 and progress_bar.visible:
		progress_bar.hide()
	elif doneness < 100 and not progress_bar.visible:
		progress_bar.visible = true
	doneness += cook_speed
	if progress_bar.visible:
		progress_bar.value = doneness
	update_texture()
	if doneness  > 150 and doneness < 200:
		print("overcooked")
	elif doneness > 200 and doneness < 250:
		print("inedible")
	elif doneness > 250:
		print("burnt")


func set_plated():
	sprite.texture = load(image_path + str(type) + "-plated.png")


func update_texture() -> void:
	if progress_bar.value < progress_bar.max_value:
		sprite.texture = load(image_path + str(type) + ".png")
	else:
		sprite.texture = load(image_path + str(type) + "-cut.png")


func set_type(value: String) -> void:
	type = value
	if sprite:
		update_texture()


func get_type() -> String:
	return type


func disable() -> void:
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	collision_shape.set_deferred("disabled", true)
	input_pickable = false


func enable() -> void:
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	collision_shape.set_deferred("disabled", false)
	input_pickable = true


func trash() -> void:
	queue_free()


func is_plateable():
	return is_cooked() and doneness <= 200 || is_chopped


func is_cooked():
	return doneness >= 100


func same_as(other: Ingredient) -> bool:
	return get_type() == other.get_type()

