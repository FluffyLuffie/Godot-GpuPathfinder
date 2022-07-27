extends TileMap

export var generation_mode: int = 0

export var width: int = 256
export var height: int = 256

export var random_seed: bool = true
export var world_seed: int = 0
export var noise_octaves: int = 8
export var noise_period: int = 5
export var noise_persistence: float = 0.7
export var noise_lacunarity: float = 0.4
export var noise_threshold = 0.04

func generate_border() -> void:
	for x in range(width):
		set_cell(x, 0, 0)
		set_cell(x, height - 1, 0)
	for y in range(1, height - 1):
		set_cell(0, y, 0)
		set_cell(width - 1, y, 0)

func _ready() -> void:
	Globals.cave = self
	
	match generation_mode:
		# keep from editor, update cave width/height
		0:
			var rect: Rect2 = get_used_rect()
			width = int(rect.end.x)
			height = int(rect.end.y)
			
			assert(rect.position.x >= 0.0 and rect.position.y >= 0.0, 'No negative tile coordinates allowed.')
		# empty cave
		1:
			clear()
		# generate cave from noise
		2:
			clear()
			
			var rand: RandomNumberGenerator = RandomNumberGenerator.new()
			if random_seed:
				rand.randomize()
				print("World seed: ", rand.seed)
			else:
				rand.seed = world_seed
			
			var sn: OpenSimplexNoise = OpenSimplexNoise.new()
			sn.seed = rand.randi()
			sn.octaves = noise_octaves
			sn.period = noise_period
			sn.persistence = noise_persistence
			sn.lacunarity = noise_lacunarity
			
			for y in range(1, height - 1):
				for x in range(1, width - 1):
					if sn.get_noise_2d(x, y) > noise_threshold:
						set_cell(x, y, 0)
			
	#make sure nothing escapes the box
	generate_border()
