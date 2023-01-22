extends RigidBody2D
class_name Pickable

signal picked_up(pick_object)
signal dropped(pick_object)

# The default game interaction is to pick up a single item
var selected = false
var speed = 100
var default_mode: int
var immovable = false


func _ready() -> void:
	default_mode = mode
	gravity_scale = 0
	linear_damp = 5
	input_pickable = true


func _physics_process(_delta: float) -> void:
	if selected:
		if not immovable:
			global_transform.origin = get_global_mouse_position()
		action()


func pickup() -> void:
	if selected:
		return
	selected = true	
	if not immovable:
		mode = RigidBody2D.MODE_CHARACTER
		if get_node_or_null("CollisionShape2D"):
			get_node("CollisionShape2D").disabled = true


func drop(impulse = Vector2.ZERO) -> void:
	if selected:
		mode = default_mode
		selected = false
		var collisionShape = get_node("CollisionShape2D") as CollisionShape2D
		if collisionShape:
			collisionShape.disabled = false
		if not immovable:
			apply_central_impulse(impulse.limit_length(1000000))
		# Confirm object has been dropped by emitting a signal
		emit_signal("dropped", self)


# Override action to be performed when picked up
func action() -> void:
	pass


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("picked_up", self)

