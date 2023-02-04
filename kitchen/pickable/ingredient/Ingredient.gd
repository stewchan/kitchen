extends Pickable
class_name Ingredient


export var chop_speed = 100
export var cook_speed = 5

var type: String setget set_type, get_type # eg "tomato"
var state: String = "raw" # chopped, cooked
var _doneness = 0
var image_path: String = "res://assets/images/ingredients/"
var plate_layer: int = 0

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var steam_particles2D: Particles2D = $SteamParticles2D


func _ready():
	update_texture(state)


func set_is_chopped(is_chopped: bool) -> void:
	if is_chopped:
		state = "chopped"	
		update_texture(state)


func is_chopped() -> bool:
	return state == "chopped"


func is_cooked() -> bool:
	return state == "cooked"


func set_doneness(val: int) -> void:
	_doneness = val
	if _doneness >= 100:
		set_is_cooked(true)


func set_is_cooked(is_cooked: bool) -> void:
	if is_cooked:
		state = "cooked"
		update_texture(state)
		steam_particles2D.emitting = true


func set_plated():
	sprite.texture = load(image_path + str(type) + "-plated.png")


func update_texture(_state: String) -> void:
	if _state == "raw":
		sprite.texture = load(image_path + str(type) + ".png")
	elif _state == "chopped":
		print(sprite)
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


func disable() -> void:
#	disconnect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	collision_shape.set_deferred("disabled", true)
	input_pickable = false


func enable() -> void:
#	connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")	
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	collision_shape.set_deferred("disabled", false)
	input_pickable = true


func trash() -> void:
	queue_free()


func is_plateable():
	return is_cooked() and _doneness <= 200 || is_chopped()


func same_as(other: Ingredient) -> bool:
	return get_type() == other.get_type()

