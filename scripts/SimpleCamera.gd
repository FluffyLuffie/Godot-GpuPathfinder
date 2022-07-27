extends Camera2D

var target: Node2D

func _ready() -> void:
	zoom = Vector2(1.0/3.0, 1.0/3.0)
	
	target = get_node('../Player')

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if target:
		position = target.position
