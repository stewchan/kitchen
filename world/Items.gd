extends Node

var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")


var ingred_count: int = 0
var ingredient_options: Array = []
var items: Dictionary = {
	"Plate": preload("res://kitchen/pickable/plate/Plate.tscn"),
	"CuttingBoard": preload("res://kitchen/pickable/tools/cutting_board/CuttingBoard.tscn"),
	"Ingredient": preload("res://kitchen/pickable/ingredient/Ingredient.tscn"),
}


func spawn(item_name: String, pos: Vector2 = Vector2.ZERO) -> Pickable:
	assert(items.has(item_name))
	var item = items[item_name].instance()
	item.name = item_name
	item.connect("picked_up", get_parent(), "on_pickup")
	call_deferred("add_child", item, true)
	item.position = pos
	return item


func spawn_plate(pos: Vector2 = Vector2.ZERO) -> void:
	var plate = spawn("Plate", pos)
	call_deferred("move_child", plate, 0)


func spawn_cutting_board(pos: Vector2 = Vector2.ZERO) -> void:
	var board = spawn("CuttingBoard", pos)
	call_deferred("move_child", board, 0)


func random_ingred_type() -> String:
	var i = int(randi() % ingredient_options.size())
	return ingredient_options[i]


remote func spawn_ingredient(type: String = random_ingred_type(), pos: Vector2 = Vector2.ZERO) -> void:
	var ingred = spawn("Ingredient", pos)
	ingred_count += 1
	ingred.type = type
	ingred.name = "Ingred" + str(ingred_count)


