extends Node

@export var spike_appear_delay: float
@export var spike_dissappear_delay: float


var spike_appear_timer: float = 0
var spike_dissappear_timer: float = 0


@onready var area_2d: Area2D = $"../PlayerDetector"
@onready var tilemap: TileMapLayer = $"../../TileMapLayer"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		spike_appear_timer = spike_appear_delay

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		spike_dissappear_timer = spike_dissappear_delay

# Potentially reconsider whether updating the tilemap logic should really go in _physics_process, maybe it should go in _process instead

func _physics_process(delta: float) -> void:
	if spike_appear_timer > 0:
		spike_appear_timer -= delta * GameManager.time_scale
	elif spike_appear_timer < 0:
		spike_appear_timer = 0
		reveal_spikes()
	
	
	if spike_dissappear_timer > 0:
		spike_dissappear_timer -= delta * GameManager.time_scale
	elif spike_dissappear_timer < 0:
		spike_dissappear_timer = 0
		destroy_spikes()

func reveal_spikes() -> void:
	tilemap.set_cell(Vector2i(-23, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-22, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-21, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-20, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-19, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-18, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-17, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-16, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-15, -15), 0, Vector2i(1, 0))
	tilemap.set_cell(Vector2i(-14, -15), 0, Vector2i(1, 0))

func destroy_spikes() -> void:
	tilemap.set_cell(Vector2i(-23, -15), -1)
	tilemap.set_cell(Vector2i(-22, -15), -1)
	tilemap.set_cell(Vector2i(-21, -15), -1)
	tilemap.set_cell(Vector2i(-20, -15), -1)
	tilemap.set_cell(Vector2i(-19, -15), -1)
	tilemap.set_cell(Vector2i(-18, -15), -1)
	tilemap.set_cell(Vector2i(-17, -15), -1)
	tilemap.set_cell(Vector2i(-16, -15), -1)
	tilemap.set_cell(Vector2i(-15, -15), -1)
	tilemap.set_cell(Vector2i(-14, -15), -1)
