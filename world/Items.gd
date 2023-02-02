extends Node

var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")

var ingred_count: int = 0
var items: Dictionary = {
	"Plate": preload("res://kitchen/pickable/plate/Plate.tscn"),
	"CuttingBoard": preload("res://kitchen/pickable/tools/cutting_board/CuttingBoard.tscn"),
	"Ingredient": preload("res://kitchen/pickable/ingredient/Ingredient.tscn"),
	"CookPot": preload("res://kitchen/pickable/tools/cook_pot/CookPot.tscn"),
	"Box": preload("res://kitchen/pickable/tools/spawn_box/SpawnBox.tscn")
}

onready var portal_spawn_point: Position2D = $PortalSpawnPoint


func spawn(item_name: String, pos: Vector2 = G.world_node.get_viewport_rect().size/2) -> Pickable:
	assert(items.has(item_name))
	var item = items[item_name].instance()
	item.name = item_name
	item.connect("picked_up", get_parent(), "on_pickup")
	item.connect("dropped", get_parent(), "on_dropped")
	call_deferred("add_child", item, true)
	item.position = pos
	return item


remotesync func spawn_tool(tool_name: String, pos: Vector2 = G.world_node.get_viewport_rect().size/2) -> void:
	var spawned_tool = spawn(tool_name, pos)
	call_deferred("move_child", spawned_tool, 0)


remotesync func spawn_box(ingred_type: String, pos: Vector2 = G.world_node.get_viewport_rect().size/2) -> void:
	var box = spawn("Box", pos)
	call_deferred("move_child", box, 0)
	box.ingred_type = ingred_type


func random_ingred_type() -> String:
	var i = int(randi() % G.ingredient_options.size())
	return G.ingredient_options[i]


remotesync func on_Portal_spawn_ingredient(
		type: String = random_ingred_type(),
		pos: Vector2 = portal_spawn_point.global_position,
		impulse: Vector2 = Vector2.ZERO) -> void:
	var ingred = spawn("Ingredient", pos)	
	ingred_count += 1
	ingred.type = type
	print(G.ingredient_options)
	var index = G.ingredient_options.find(ingred.type)
	assert(index >= 0)
	ingred.plate_layer = index
	ingred.name = ingred.type + str(ingred_count)
	ingred.apply_impulse(Vector2.ZERO, impulse)


