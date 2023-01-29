extends Pickable
class_name Ingredient


export var chop_speed = 100
export var cook_speed = 5

var type: String setget set_type, get_type # eg "tomato"
var _is_chopped: bool setget , is_chopped
var _is_cooked: bool setget , is_cooked
var _doneness = 0
var image_path: String = "res://assets/images/ingredients/"
var plate_layer: int = 0

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	update_texture("raw")


func is_chopped() -> bool:
	return _is_chopped


func is_cooked() -> bool:
	return _is_cooked


func set_is_chopped() -> void:
	_is_chopped = true
	update_texture("chopped")


func set_is_cooked(doneness: int) -> void:
	_is_cooked = true
	_doneness = doneness
	update_texture("cooked")


func set_plated():
	sprite.texture = load(image_path + str(type) + "-plated.png")


func update_texture(state: String) -> void:
	if state == "raw":
		sprite.texture = load(image_path + str(type) + ".png")
	elif state == "chopped":
		sprite.texture = load(image_path + str(type) + "-cut.png")
	elif state == "cooked":
		sprite.texture = load(image_path + str(type) + "-cut.png")
		print("TODO: create ingredient cooked texture")


func set_type(value: String) -> void:
	type = value
	if sprite:
		update_texture("raw")


func get_type() -> String:
	return type


func disable() -> void:
	disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	collision_shape.set_deferred("disabled", true)
	input_pickable = false


func enable() -> void:
	connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")	
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	collision_shape.set_deferred("disabled", false)
	input_pickable = true


func trash() -> void:
	queue_free()


func is_plateable():
	return is_cooked() and _doneness <= 200 || is_chopped()


func same_as(other: Ingredient) -> bool:
	return get_type() == other.get_type()

