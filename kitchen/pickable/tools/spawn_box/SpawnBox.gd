extends KitchenTool
class_name SpawnBox


export var spawn_speed: int = 100

var ingredient_type: String
var can_spawn: bool = false
var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var base_alpha = 0.3


onready var restock_timer = $RestockTimer


func _ready() -> void:
	spawn_ingredient()


func spawn_ingredient() -> void:
	if captured_item or not ingredient_type:
		return
	var ingredient = IngredientScene.instance()
	G.ingredient_count += 1
	ingredient.type = ingredient_type
	add_child(ingredient)
	ingredient.connect("picked_up", G.world_node, "on_pickup")
	ingredient.connect("dropped", G.world_node, "on_dropped")
	ingredient.modulate.a = base_alpha
	var index = G.ingredient_options.find(ingredient.type)
	assert(index >= 0)
	ingredient.plate_layer = index
	ingredient.name = ingredient.type + str(G.ingredient_count)
	capture(ingredient)


func action(delta: float) -> void:
	if not captured_item:
		return
	if not progress_bar.visible:
		progress_bar.show()
	if can_spawn:
		progress_bar.hide()		
		can_spawn = false
		release()
		restock_timer.start()
	else:
		progress_bar.value += spawn_speed * delta
		captured_item.modulate.a = base_alpha \
			if progress_bar.value < progress_bar.max_value * base_alpha \
			else progress_bar.value/progress_bar.max_value
		if progress_bar.value >= progress_bar.max_value:
			progress_bar.value = 0
			can_spawn = true


func _on_RestockTimer_timeout() -> void:
	if not captured_item:
		spawn_ingredient()
