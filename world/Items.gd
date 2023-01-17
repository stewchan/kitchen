extends Node

var IngredientScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")
var PlateScene = preload("res://kitchen/pickable/plate/Plate.tscn")
var CuttingBoardScene = preload("res://kitchen/pickable/tools/cutting_board/CuttingBoard.tscn")

var items: Dictionary = {
	"Plate": preload("res://kitchen/pickable/plate/Plate.tscn")
}


func spawn(item_name: String, pos: Vector2 = Vector2.ZERO) -> Pickable:
	assert(items.has(item_name))
	var item = items[item_name].instance()
	item.name = item_name
	item.connect("picked_up", get_parent(), "on_pickup")
	call_deferred("add_child", item)
	item.position = pos
	return item


func spawn_plate(pos: Vector2 = Vector2.ZERO) -> void:
	var item = spawn("Plate", pos)
	call_deferred("move_child", item, 0)



