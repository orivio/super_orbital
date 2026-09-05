@tool
class_name Door
extends Area2D

signal door_entered(direction: Types.DoorDirection)

@export var door_tag: String
@export var direction: Types.DoorDirection = Types.DoorDirection.EAST

var enabled: bool

@onready var spawn: Marker2D = $Spawn


func _ready() -> void:
	enabled = false

func get_spawn_pos() -> Vector2:
	return spawn.global_position


func _on_body_entered(body: Node2D) -> void:
	if body is Player and enabled and body.current_player_state == Player.PlayerState.GAMEPLAY:
		# Emit a signal which will bubble up to the play scene to manage level
		# transition
		print("Door entered: ", door_tag)
		door_entered.emit(direction)
