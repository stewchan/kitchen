extends Draggable
class_name Ingredient


var ready_to_plate = true setget , ready_to_plate
var ingredient_name: String setget set_name, get_name
var tomato_img = preload("res://addons/kenney_prototype_textures/red/texture_01.png")
var lettuce_img = preload("res://addons/kenney_prototype_textures/green/texture_01.png")
var eggplant_img = preload("res://addons/kenney_prototype_textures/purple/texture_01.png")


onready var sprite = $Sprite


func _ready() -> void:
	set_texture()


func set_texture() -> void:
	if ingredient_name == "tomato":
		sprite.texture = tomato_img
	elif ingredient_name == "lettuce":
		sprite.texture = lettuce_img
	else:
		sprite.texture = eggplant_img


func set_name(value: String) -> void:
	ingredient_name = value


func get_name() -> String:
	return ingredient_name


func ready_to_plate() -> bool:
	return ready_to_plate


func process_and_clone() -> Ingredient:
	var ing = self.duplicate()
	ing.ingredient_name = self.ingredient_name
	ing.get_node("CollisionShape2D").set_deferred("disabled", true)
	ing.get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
	ing.name = ingredient_name
#	ing.set_texture()
	return ing


func same_as(other: Ingredient) -> bool:
	return get_name() == other.get_name()

	
func _on_Hitbox_body_entered(body: Node) -> void:
	if body == self:
		return
#	if body as Ingredient:
#		$Hitbox/CollisionShape2D.queue_free()
#		$CollisionShape2D.queue_free()
#		print(str(body))
