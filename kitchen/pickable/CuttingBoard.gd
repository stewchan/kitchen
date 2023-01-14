extends Pickable
class_name CuttingBoard

var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var current_ingred: Ingredient = null


func fix_to_board(ingredient: Ingredient):
	var ingred = ingredient.process_and_clone()
	ingred.rotation = rotation
	add_child(ingred, true)
	ingred.position = Vector2.ZERO


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	print("entered")
	if not ingredient.prepped:
		fix_to_board(ingredient)
