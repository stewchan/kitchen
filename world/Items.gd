extends Node

var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")


var ingred_count: int = 0
var ingredient_options: Array = []
var items: Dictionary = {
	"Plate": preload("res://kitchen/pickable/plate/Plate.tscn"),
	"CuttingBoard": preload("res://kitchen/pickable/tools/cutting_board/CuttingBoard.tscn"),
	"Ingredient": preload("res://kitchen/pickable/ingredient/Ingredient.tscn"),
	"CookPot": preload("res://kitchen/pickable/tools/cook_pot/CookPot.tscn"),
	"SpawnBox": preload("res://kitchen/pickable/tools/spawn_box/SpawnBox.tscn")
}


func spawn(item_name: String, pos: Vector2 = Vector2.ZERO) -> Pickable:
	assert(items.has(item_name))
	var item = items[item_name].instance()
	item.name = item_name
	item.connect("picked_up", get_parent(), "on_pickup")
	item.connect("dropped", get_parent(), "on_dropped")
	call_deferred("add_child", item, true)
	item.position = pos
	return item


func spawn_plate(pos: Vector2 = Vector2.ZERO) -> void:
	var plate = spawn("Plate", pos)
	call_deferred("move_child", plate, 0)


func spawn_cutting_board(pos: Vector2 = Vector2.ZERO) -> void:
	var board = spawn("CuttingBoard", pos)
	call_deferred("move_child", board, 0)


func spawn_cookpot(pos: Vector2 = Vector2.ZERO) -> void:
	var pot = spawn("CookPot", pos)
	call_deferred("move_child", pot, 0)


# Set up ingredient boxes
func spawn_boxes() -> void:
	for i in range(0, ingredient_options.size()): # in items.ingredient_options:
		var x_mid = get_parent().get_viewport_rect().size.x/2
		var y_bot = get_parent().get_viewport_rect().size.y
		var pos = Vector2(x_mid - 200 + 200 * i, y_bot - 70)
		var box = spawn("SpawnBox", pos)
		call_deferred("move_child", box, 0)
		box.ingred_name = ingredient_options[i]

#		box.connect("spawn_ingredient", self, "on_spawn_ingredient")


func random_ingred_type() -> String:
	var i = int(randi() % ingredient_options.size())
	return ingredient_options[i]


remote func on_spawn_ingredient(
		type: String = random_ingred_type(),
		pos: Vector2 = Vector2.ZERO,
		impulse: Vector2 = Vector2.ZERO) -> void:
	var ingred = spawn("Ingredient", pos)	
	ingred_count += 1
	ingred.type = type
	var index = ingredient_options.find(ingred.type)
	assert(index >= 0)
	ingred.plate_layer = index
	ingred.name = ingred.type + str(ingred_count)
	ingred.apply_impulse(Vector2.ZERO, impulse)


