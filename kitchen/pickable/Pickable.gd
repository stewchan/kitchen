extends RigidBody2D
class_name Pickable

signal picked_up(pick_object)
signal dropped(pick_object)

# The default game interaction is to pick up a single item
var selected = false
var can_pickup = true	# For items that are fixed
var speed = 100
var default_mode = RigidBody2D.MODE_RIGID


func _ready() -> void:
	gravity_scale = 0
	linear_damp = 1
	input_pickable = true


func _physics_process(delta: float) -> void:
	if selected:
		if can_pickup:
			global_transform.origin = get_global_mouse_position()
		action()


func pickup() -> void:
	if selected:
		return
	selected = true	
	if can_pickup:
		mode = RigidBody2D.MODE_STATIC
		if get_node_or_null("CollisionShape2D"):
			get_node("CollisionShape2D").disabled = true


func drop(impulse = Vector2.ZERO) -> void:
	if selected:
		mode = default_mode
		selected = false
		var collisionShape = get_node("CollisionShape2D") as CollisionShape2D
		if collisionShape:
			collisionShape.disabled = false
		if not can_pickup:
			apply_central_impulse(impulse.clamped(5))
		# Confirm object has been dropped by emitting a signal
		emit_signal("dropped", self)



# Override action to be performed when picked up
func action() -> void:
	pass


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("picked_up", self)

