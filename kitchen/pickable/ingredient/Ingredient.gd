extends Pickable
class_name Ingredient


var ingredient_name: String setget set_name, get_name
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
		sprite.texture = load(Data.textures[ingredient_name].raw)
	elif progress_bar.value < progress_bar.max_value:
		sprite.texture = load(Data.textures[ingredient_name].progress)
	else:
		sprite.texture = load(Data.textures[ingredient_name].prepped)


func set_name(value: String) -> void:
	ingredient_name = value
	if sprite:
		update_texture()


func get_name() -> String:
	return ingredient_name


func disable() -> void:
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	can_pickup = false
	input_pickable = false
	collision_shape.set_deferred("disabled", true)


func enable() -> void:
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	can_pickup = true
	input_pickable = true
	collision_shape.set_deferred("disabled", false)


func process_and_clone() -> Ingredient:
	var ing = self.duplicate()
	ing.ingredient_name = self.ingredient_name
	ing.get_node("CollisionShape2D").set_deferred("disabled", true)
	ing.mode = RigidBody2D.MODE_STATIC
	ing.name = ingredient_name
	call_deferred("queue_free")
#	ing.set_texture()
	return ing


func same_as(other: Ingredient) -> bool:
	return get_name() == other.get_name()

