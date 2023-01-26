extends RigidBody2D
class_name Pickable

signal picked_up(pick_object)
signal dropped(pick_object)

# The default game interaction is to pick up a single item
var selected = false
var speed = 100
var default_mode: int


func _init() -> void:
	default_mode = mode
	gravity_scale = 0
	linear_damp = 5
	input_pickable = true


func _physics_process(delta: float) -> void:
	if selected:
		global_transform.origin = get_global_mouse_position()
		action(delta)


func pickup() -> void:
	if selected:
		return
	selected = true	
	mode = RigidBody2D.MODE_CHARACTER
	if get_node_or_null("CollisionShape2D"):
		get_node("CollisionShape2D").disabled = true


func drop(impulse = Vector2.ZERO) -> void:
	if selected:
		mode = default_mode
		selected = false
		get_node("CollisionShape2D").disabled = false
		apply_central_impulse(impulse.limit_length(1000))
		# Confirm object has been dropped by emitting a signal
		emit_signal("dropped", self)
		print("Pickable drop" + str(self))


# Override action to be performed when picked up
func action(_delta: float) -> void:
	pass


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("picked_up", self)

