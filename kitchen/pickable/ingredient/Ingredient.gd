extends Pickable
class_name Ingredient


var type: String setget set_type, get_type
var is_prepped: bool = false
var chop_speed = 1

onready var sprite: Sprite = $Sprite
onready var progress_bar: TextureProgress = $ProgressBar
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	progress_bar.value = 0
	update_texture()


func chop():
	if is_prepped:
		return
	if not progress_bar.visible:
		progress_bar.show()
	if progress_bar.value < progress_bar.max_value:
		progress_bar.value += chop_speed
	elif progress_bar.value >= progress_bar.max_value:
		is_prepped = true
		progress_bar.hide()
	update_texture()


func update_texture() -> void:
	if progress_bar.value < progress_bar.max_value / 2:
		sprite.texture = load(Data.textures[type].raw)
	elif progress_bar.value < progress_bar.max_value:
		sprite.texture = load(Data.textures[type].progress)
	else:
		sprite.texture = load(Data.textures[type].prepped)


func set_type(value: String) -> void:
	type = value
	if sprite:
		update_texture()


func get_type() -> String:
	return type


func disable() -> void:
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	collision_shape.set_deferred("disabled", true)
	can_pickup = false
	input_pickable = false


func enable() -> void:
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	collision_shape.set_deferred("disabled", false)
	can_pickup = true
	input_pickable = true


func trash() -> void:
	queue_free()


func same_as(other: Ingredient) -> bool:
	return get_name() == other.get_name()

