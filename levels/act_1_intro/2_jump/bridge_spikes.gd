extends Node

@export var spike_change_time: float
@export var spike_A_changers: Array[TileMapChanger]
@export var spike_b_changers: Array[TileMapChanger]

var switch: bool = false

@onready var tilemap: TileMapLayer = $"../../TileMapLayer"
@onready var spike_timer: Timer = $SpikeTimer


func _ready() -> void:
	spike_timer.start(spike_change_time)
	spike_switch.call_deferred()


func spike_switch() -> void:
	var changers: Array[TileMapChanger]
	
	if switch:
		changers = spike_A_changers
	else:
		changers = spike_b_changers
	
	for node in changers:
		if node.has_method("change"):
			node.change()
	
	switch = not switch


func _on_spike_timer_timeout() -> void:
	spike_switch()
