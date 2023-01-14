extends RigidBody2D
class_name Pickable

signal clicked(drag_object)

var held = false
var speed = 100


func _ready() -> void:
	input_pickable = true
	gravity_scale = 0
	linear_damp = 1


func _physics_process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()


func pickup() -> void:
	if held:
		return
	mode = RigidBody2D.MODE_STATIC
	if get_node_or_null("CollisionShape2D"):
		get_node("CollisionShape2D").disabled = true
	held = true


func drop(impulse = Vector2.ZERO) -> void:
	if held:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse.clamped(5))
		held = false
		var collisionShape = get_node("CollisionShape2D") as CollisionShape2D
		if collisionShape:
			collisionShape.disabled = false


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", self)

