extends Area2D


@export var tilemap: TileMapLayer
@export var spike_appear_delay: float = 0.2
@export var spike_dissappear_delay: float = 0.2
@export var spike_array: Array[Vector2i]


var spike_appear_timer: float = 0
var spike_dissappear_timer: float = 0


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		spike_appear_timer = spike_appear_delay

func _on_body_exited(body: Node2D) -> void:
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
	for coord in spike_array:
		tilemap.set_cell(coord, 0, Vector2i(1, 0))

func destroy_spikes() -> void:
	for coord in spike_array:
		tilemap.set_cell(coord, 0, Vector2i(9, 0))
