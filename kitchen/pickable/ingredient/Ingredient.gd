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


func get_nested_ingredients() -> Array:
	var ingred = get_child(0)
	if not ingred as Ingredient:
		return []
	var list = [ingred]
	return list.append_array(ingred.get_nested_ingredients())


func get_nested_ingredient_types() -> Array:
	var ingredients = get_nested_ingredients()
	if not ingredients:
		return []
	var ingred_types = []
	for ingredient in ingredients:
		ingred_types.append(ingredient.type)
	return ingred_types


func nest(ingredient: Ingredient) -> void:
	# If incoming ingredient should be parent
	if ingredient.plate_layer < plate_layer:
		G.relocate_node(ingredient, get_parent(), 1)
		G.relocate_node(self, ingredient, 1)
		disable()
		return
	# If no other ingredient is nested
	var ingred = get_child(1)
	if not ingred as Ingredient:
		G.relocate_node(ingredient, self, 1)
		ingredient.disable()
#		ingredient.set_plated()
		ingredient.rotation = rotation
	else:
		ingred.nest(ingredient)


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

