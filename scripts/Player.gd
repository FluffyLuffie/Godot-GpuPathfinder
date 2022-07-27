extends KinematicBody2D

export var speed: float = 120.0

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	var velocity: Vector2 = Vector2.ZERO
	velocity.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	velocity.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	# warning-ignore:return_value_discarded
	move_and_slide(velocity.normalized() * speed)

# just so player doesn't get stuck
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_class('KinematicBody2D') and body != self:
		body.queue_free()
