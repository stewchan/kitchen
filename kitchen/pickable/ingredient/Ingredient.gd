extends Pickable
class_name Ingredient


var ingredient_name: String setget set_name, get_name
var is_prepped: bool = false
var progress = 0
var prep_speed = 10


onready var sprite: Sprite = $Sprite
onready var progress_bar: ProgressBar = $ProgressBar
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	update_texture()


func chop():
	if is_prepped:
		return
	if progress < progress_bar.max_value:
		progress += prep_speed
	elif progress >= progress_bar.max_value:
		is_prepped = true
	update_texture()


func update_texture() -> void:
	if progress < progress_bar.max_value / 2:
		sprite.texture = load(Data.textures[ingredient_name].raw)
	elif progress < progress_bar.max_value:
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
	can_pickup = false
	collision_shape.set_deferred("disabled", true)


func enable() -> void:
	can_pickup = true
	collision_shape.disabled = false


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

