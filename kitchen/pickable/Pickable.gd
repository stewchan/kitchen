extends RigidBody2D
class_name Pickable

signal clicked(drag_object)

var held = false
var speed = 100


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
		# TODO: clamp the impulse
		apply_central_impulse(impulse)
		held = false
		var collisionShape = get_node("CollisionShape2D") as CollisionShape2D
		if collisionShape:
			collisionShape.disabled = true


func _process(delta: float) -> void:
	pass
#	apply_movement(delta)


#func apply_movement(delta) -> void:
#	var direction = Vector2.ZERO
#	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	# If input is digital, normalize it for diagonal movement
#	if abs(direction.x) == 1 and abs(direction.y) == 1:
#		direction = direction.normalized()
#
#	# Calculate movement
#	var movement = speed * direction * delta
#
#	if held:
#		var new_position = get_global_mouse_position()
#		movement = new_position - position;
#
#	move_and_collide(movement)


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked", self)


func _input(event):
	if event is InputEventMouseButton:
		if not event.pressed:
			held = false
