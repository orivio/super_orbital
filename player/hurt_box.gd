extends Area2D

@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer and not player.disabled:
		# print("Colliding with spike on TMAP: ", body.get_parent())
		player.die()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("black_hole") and not player.disabled:
		player.die()
