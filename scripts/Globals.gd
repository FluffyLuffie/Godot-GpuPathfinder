extends Node

var cave: TileMap
var tile_size: float
var path_img: PoolByteArray

func _ready() -> void:
	OS.window_maximized = true
