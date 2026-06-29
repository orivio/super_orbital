@tool
extends Area2D

const GRID_SIZE: float = 100 / 2

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		var bounds: RectangleShape2D = $CollisionShape2D.shape
		var grid: Vector2 = Vector2(GRID_SIZE, GRID_SIZE)
		var top_left: Vector2 = ($CollisionShape2D.position - bounds.size / 2).snapped(grid)
		var bottom_right: Vector2 = ($CollisionShape2D.position + bounds.size / 2).snapped(grid)

		#$CollisionShape2D.shape.set_size(bottom_right - top_left)
		#$CollisionShape2D.position = (top_left + bottom_right) / 2
