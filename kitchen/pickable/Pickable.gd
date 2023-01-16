extends RigidBody2D
class_name Pickable

signal clicked(click_object)
signal picked_up(drag_object)

var picked_up = false
var can_pickup = true
var speed = 100
var id: String


func _ready() -> void:
	input_pickable = true


func _physics_process(delta: float) -> void:
	if picked_up:
		global_transform.origin = get_global_mouse_position()


func pickup() -> void:
	if picked_up:
		return
	mode = RigidBody2D.MODE_STATIC
	if get_node_or_null("CollisionShape2D"):
		get_node("CollisionShape2D").disabled = true
	picked_up = true


func drop(impulse = Vector2.ZERO) -> void:
	if picked_up:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse.clamped(5))
		picked_up = false
		var collisionShape = get_node("CollisionShape2D") as CollisionShape2D
		if collisionShape:
			collisionShape.disabled = false


func click_action() -> void:
	print("Unimplemented: override click action in subclass")


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not can_pickup:
			emit_signal("clicked", self)
		else:
			emit_signal("picked_up", self)

