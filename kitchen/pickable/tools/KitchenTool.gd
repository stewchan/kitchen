extends Pickable
class_name KitchenTool

var captured_item: Pickable = null

onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
onready var progress_bar: TextureProgress = $ProgressBar
onready var audio_player: AudioStreamPlayer2D = $AudioPlayer


func _init() -> void:
	mode = RigidBody2D.MODE_CHARACTER
	._init()


# Override to stop sounds playing on drop
func drop(_impulse: Vector2 = Vector2.ZERO) -> void:
	var stream: AudioStream = audio_player.stream
	stream.loop_mode = AudioStreamSample.LOOP_DISABLED
	.drop(_impulse)


func capture(item: Pickable):
	if item.has_method("disable"):
		item.disable()
	G.relocate_node(item, self)
	item.rotation = rotation
	captured_item = item


func release() -> void:
	if captured_item:
		captured_item.enable()
		G.relocate_to_world(captured_item, captured_item.global_position)
		# Drop the kitchen tool
		drop()
		# Required so pick up signal not called before drop
		yield(get_tree(), "idle_frame") 
		# Immediately pick up released ingredient
		emit_signal("picked_up", captured_item) 
		captured_item = null


# Override in subclass
func _on_Hitbox_body_entered(item) -> void:
	pass
