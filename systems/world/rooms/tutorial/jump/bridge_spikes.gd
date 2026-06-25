extends Node

const SPIKE_TIME: float = 0.8

var timer_a: float
var state_a: bool

@onready var tilemap: TileMapLayer = $"../../TileMapLayer"

func _ready() -> void:
	timer_a = 0
	state_a = false

func _process(delta: float) -> void:
	timer_a += delta
	if timer_a >= SPIKE_TIME:
		timer_a = 0
		spike_switch()

func spike_switch() -> void:
	if !state_a:
		tilemap.set_cell(Vector2i(25, -5), 0, Vector2i(1, 0))
		tilemap.set_cell(Vector2i(26, -5), 0, Vector2i(1, 0))
		tilemap.set_cell(Vector2i(25, -3), 0, Vector2i(2, 0))
		tilemap.set_cell(Vector2i(26, -3), 0, Vector2i(2, 0))
		tilemap.set_cell(Vector2i(24, -4), 0, Vector2i(3, 0))
		tilemap.set_cell(Vector2i(27, -4), 0, Vector2i(4, 0))
		
		tilemap.set_cell(Vector2i(26, -11), 0, Vector2i(1, 0))
		tilemap.set_cell(Vector2i(27, -11), 0, Vector2i(1, 0))
		tilemap.set_cell(Vector2i(26, -9), 0, Vector2i(2, 0))
		tilemap.set_cell(Vector2i(27, -9), 0, Vector2i(2, 0))
		tilemap.set_cell(Vector2i(25, -10), 0, Vector2i(3, 0))
		tilemap.set_cell(Vector2i(28, -10), 0, Vector2i(4, 0))
		
		
		
		tilemap.set_cell(Vector2i(21, -8), -1)
		tilemap.set_cell(Vector2i(22, -8), -1)
		tilemap.set_cell(Vector2i(21, -6), -1)
		tilemap.set_cell(Vector2i(22, -6), -1)
		tilemap.set_cell(Vector2i(23, -7), -1)
		tilemap.set_cell(Vector2i(20, -7), -1)
	else:
		tilemap.set_cell(Vector2i(25, -5), -1)
		tilemap.set_cell(Vector2i(26, -5), -1)
		tilemap.set_cell(Vector2i(25, -3), -1)
		tilemap.set_cell(Vector2i(26, -3), -1)
		tilemap.set_cell(Vector2i(24, -4), -1)
		tilemap.set_cell(Vector2i(27, -4), -1)
		
		tilemap.set_cell(Vector2i(26, -11), -1)
		tilemap.set_cell(Vector2i(27, -11), -1)
		tilemap.set_cell(Vector2i(26, -9), -1)
		tilemap.set_cell(Vector2i(27, -9), -1)
		tilemap.set_cell(Vector2i(25, -10), -1)
		tilemap.set_cell(Vector2i(28, -10), -1)
		
		
		
		tilemap.set_cell(Vector2i(21, -8), 0, Vector2i(1, 0))
		tilemap.set_cell(Vector2i(22, -8), 0, Vector2i(1, 0))
		tilemap.set_cell(Vector2i(21, -6), 0, Vector2i(2, 0))
		tilemap.set_cell(Vector2i(22, -6), 0, Vector2i(2, 0))
		tilemap.set_cell(Vector2i(20, -7), 0, Vector2i(3, 0))
		tilemap.set_cell(Vector2i(23, -7), 0, Vector2i(4, 0))
	state_a = not state_a
