@tool
class_name DebugOverlay
extends Node2D

@export var dash_breakdown_thickness: float
@export var dash_breakdown_first_color: Color
@export var dash_breakdown_second_color: Color

@onready var player: Player = $".."


func _draw() -> void:
	if Engine.is_editor_hint():
		if player.movement_settings.show_dash_breakdown:
			var center: Vector2 = player.get_center_of_mass()
			var dash_exit_pos: Vector2 = center + Vector2.RIGHT * player.movement_settings.dash_distance
			var dash_final_pos: Vector2 = dash_exit_pos + Vector2.RIGHT * player.movement_settings.dash_exit_distance
			draw_line(center, dash_exit_pos, dash_breakdown_first_color, dash_breakdown_thickness)
			draw_line(dash_exit_pos, dash_final_pos, dash_breakdown_second_color, dash_breakdown_thickness)
