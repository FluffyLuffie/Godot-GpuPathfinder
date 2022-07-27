extends Node2D

export var spawn_interval: float = 0.2
var enemy_scene: PackedScene = preload('res://scenes/Enemy.tscn')

var timer: float = 0.0
var player: Node2D
var rand = RandomNumberGenerator.new()
var enemy_map: TileMap

func _ready() -> void:
	player = get_node('../Player')
	rand.randomize()
	enemy_map = get_node('../Minimap/EnemyMap')
	
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	# simple map
	enemy_map.clear()
	for c in get_children():
		enemy_map.set_cellv(Globals.cave.world_to_map(c.position), 1)
	enemy_map.set_cellv(Globals.cave.world_to_map(player.position), 0)

func _physics_process(delta: float) -> void:
	timer += delta
	
	if timer >= spawn_interval:
		timer -= spawn_interval
		
		# attempt to spawn an enemy if not in wall
		for _i in range(10):
			var x: int = rand.randi_range(1, Globals.cave.width - 1)
			var y: int = rand.randi_range(1, Globals.cave.height - 1)
			
			#check if unreachable tile, does not check if path was closed
			var base_index:int = (int(x) + int(y) * Globals.cave.width) * 4
			var valid: bool = Globals.path_img[base_index] + Globals.path_img[base_index + 1] + Globals.path_img[base_index + 2]
			
			if Globals.cave.get_cell(x, y) == -1 and valid:
				var spawned = enemy_scene.instance()
				spawned.target = player
				spawned.position = Globals.cave.map_to_world(Vector2(x, y))
				# adding child to self just for easier management
				add_child(spawned)
				break
