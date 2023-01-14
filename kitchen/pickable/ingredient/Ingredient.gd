extends Pickable
class_name Ingredient


var ready_to_plate = true setget , ready_to_plate
var ingredient_name: String setget set_name, get_name

var ingredient_img_path = {
	"Tomato": "res://addons/kenney_prototype_textures/red/texture_01.png",
	"Lettuce": "res://addons/kenney_prototype_textures/green/texture_01.png",
	"Eggplant": "res://addons/kenney_prototype_textures/purple/texture_01.png"
}

onready var sprite = $Sprite


func _ready():
	set_texture()


func set_texture() -> void:
	sprite.texture = load(ingredient_img_path[ingredient_name])


func set_name(value: String) -> void:
	ingredient_name = value
	if sprite:
		set_texture()


func get_name() -> String:
	return ingredient_name


func ready_to_plate() -> bool:
	return ready_to_plate


func process_and_clone() -> Ingredient:
	var ing = self.duplicate()
	ing.ingredient_name = self.ingredient_name
	ing.get_node("CollisionShape2D").set_deferred("disabled", true)
	ing.get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
	ing.mode = RigidBody2D.MODE_STATIC
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
