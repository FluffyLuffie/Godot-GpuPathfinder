extends Node2D

var path_vp: Viewport
var path_image: Sprite
var cave: TileMap
var player: KinematicBody2D

var waited_frames: int = 0
var cur_img: Image

func _ready() -> void:
	path_vp = get_node("../PathViewport")
	path_image = get_node("../PathViewport/Terrain")
	cave = get_node("../Cave")
	player = get_node("../Player")

	path_vp.size = cave.get_used_rect().size
	path_image.texture.set_size_override((path_vp.size))
	
	#create path texture
	cur_img = Image.new()
	cur_img.create(int(path_vp.size.x), int(path_vp.size.y), false, Image.FORMAT_RGBA8)
	cur_img.lock()
	for y in range(int(path_vp.size.y)):
		for x in range(int(path_vp.size.x)):
			if cave.get_cell(x, y) == -1:
				cur_img.set_pixel(x, y, Color(0.0, 0.0, 0.0, 1.0))
	cur_img.unlock()
	
	path_image.texture.create_from_image(cur_img)
	VisualServer.force_draw(false)

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	#need to wait a few frames for viewport
	if waited_frames > 1:
		cur_img = path_vp.get_texture().get_data()
		cur_img.lock()
		
		if Input.is_action_pressed('m1'):
			var mouse_tile: Vector2 = cave.world_to_map(get_global_mouse_position())
			edit_tile(int(mouse_tile.x), int(mouse_tile.y), 0, false)
		elif Input.is_action_pressed('m2'):
			var mouse_tile: Vector2 = cave.world_to_map(get_global_mouse_position())
			edit_tile(int(mouse_tile.x), int(mouse_tile.y), -1, true)
		
		# set player's tile to white
		if cur_img.get_pixelv(cave.world_to_map(player.position)).a != 0.0:
			cur_img.set_pixelv(cave.world_to_map(player.position), Color(1.0, 1.0, 1.0, 1.0))
			
		path_image.texture.create_from_image(cur_img)
	else:
		waited_frames += 1
	
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	Globals.path_img = cur_img.get_data()

func edit_tile(x: int, y: int, id: int, walkable: bool) -> void:
	# prevent editing edge
	if x < 1 or x >= cave.width - 1 or y < 1 or y >= cave.height - 1:
		return
	
	cave.set_cell(x, y, id)
	cur_img.set_pixel(x, y, Color(0.0, 0.0, 0.0, float(walkable)))
