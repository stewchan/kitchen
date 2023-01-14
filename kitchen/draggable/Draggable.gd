extends KinematicBody2D
class_name Draggable


var drag_enabled = false
var speed = 100


func _ready() -> void:
	input_pickable = true


func _process(delta: float) -> void:
	apply_movement(delta)


func apply_movement(delta) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	# Calculate movement
	var movement = speed * direction * delta

	if drag_enabled:
		var new_position = get_global_mouse_position()
		movement = new_position - position;
	
	move_and_collide(movement)


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		drag_enabled = event.pressed


func _input(event):
	if event is InputEventMouseButton:
		if not event.pressed:
			drag_enabled = false
