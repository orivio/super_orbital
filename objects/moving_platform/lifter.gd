@tool
class_name Lifter
extends Path2D

@export var time: float = 1
@export var forward_direction: float = 0
@export_tool_button("Update Follow Visual") var update_line_button = update_follow_visual

var speed: float = 1

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var rect: NinePatchRect = $AnimatableBody2D/NinePatchRect
@onready var follow_visual: Line2D = $FollowVisual
@onready var player_detector: Area2D = $AnimatableBody2D/Area2D

func _ready() -> void:
	speed = 1 / time
	
	update_follow_visual()

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if time == 0:
			return
		
		if path_follow_2d.progress_ratio >= 1:
			path_follow_2d.progress_ratio = 1
			if forward_direction == 1:
				return
		if path_follow_2d.progress_ratio <= 0:
			path_follow_2d.progress_ratio = 0
			if forward_direction == -1:
				return
		path_follow_2d.progress_ratio += speed * delta * GameManager.time_scale * forward_direction

func update_follow_visual() -> void:
	follow_visual.points = curve.get_baked_points()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		forward_direction = 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	forward_direction = -1
