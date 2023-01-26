extends Pickable
class_name KitchenTool

var captured_ingredient: Ingredient = null

onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
onready var visibility_notifier = $VisibilityNotifier2D
onready var visibility_timer = $VisibilityDetectorTimer
onready var tool_respawn_timer = $ToolRespawnTimer


func _init() -> void:
	mode = RigidBody2D.MODE_CHARACTER
	._init()


func capture(ingredient: Ingredient):
	ingredient.disable()
	G.reparent_to_node(ingredient, self)
	ingredient.rotation = rotation
	captured_ingredient = ingredient


func release() -> void:
	if captured_ingredient:
		captured_ingredient.enable()
		G.reparent_to_world(captured_ingredient, captured_ingredient.global_position)
		drop() # Drop the kitchen tool
		yield(get_tree(), "idle_frame") # Required so pick up signal not called before drop
		emit_signal("picked_up", captured_ingredient)
		captured_ingredient = null


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if not ingredient.is_chopped and not captured_ingredient:
		capture(ingredient)


# Check if tool was thrown off screen
func _on_VisibilityDetectorTimer_timeout() -> void:
	if not visibility_notifier.is_on_screen():
		visibility_timer.stop()
		tool_respawn_timer.start()


# Reposition tool
func _on_ToolRespawnTimer_timeout() -> void:
	position = G.world_node.get_viewport_rect().size/2
	visibility_timer.start()
