extends KinematicBody2D

var speed: float = 100.0
var target: Node2D

var next_tile: Vector2
var cur_interval: int = 0

# calculate every 6 ticks
const interval: int = 6
const offsets: Array = [Vector2(0.0, -1.0), Vector2(1.0, 0.0), Vector2(0.0, 1.0), Vector2(-1.0, 0.0)]

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if cur_interval == 0:
		var cur_tile: Vector2 = Globals.cave.world_to_map(position)
		
		# if inside wall
		if Globals.cave.get_cellv(cur_tile) == 0:
			queue_free()
			return
		
		var best_score: float = 0.0
		var best_step: int = -1
		var base_index:int = int(cur_tile.x) + int(cur_tile.y) * Globals.cave.width
		
		# calculate which tile to move next
		for i in range(4):
			var cur_index: int = (base_index + int(offsets[i][0]) + int(offsets[i][1] * Globals.cave.width)) * 4
			var alpha: float = Globals.path_img[cur_index + 3] / 255.0
			var neighbor_score: float = (int(Globals.path_img[cur_index] * alpha) << 16) + (int(Globals.path_img[cur_index + 1] * alpha) << 8) + (int(Globals.path_img[cur_index + 2] * alpha))
			neighbor_score += 1.0 / ((cur_tile + offsets[i]).distance_to(Globals.cave.world_to_map(target.position)) + 0.1)
			if neighbor_score > best_score:
				best_score = neighbor_score
				best_step = i
		
		if (best_step != -1):
			look_at(Globals.cave.map_to_world(cur_tile + offsets[best_step]) + Vector2(Globals.cave.cell_size.x / 2.0, Globals.cave.cell_size.y / 2.0))
	
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(cos(rotation), sin(rotation)) * speed)
	cur_interval = (cur_interval + 1) % interval
