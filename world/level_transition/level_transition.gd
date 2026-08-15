@tool
class_name LevelTransition
extends Area2D


signal player_entered(dir: Types.EastWestNoneDirection)


const TILE_SIZE = 32
const WIDTH = 6


@export var direction: Types.EastWestNoneDirection = Types.EastWestNoneDirection.NONE:
	set(value):
		direction = value
		if not is_node_ready():
			return
		update_shape(direction, height, WIDTH)
@export var height: int = 3:
	set(value):
		height = value
		if not is_node_ready():
			return
		update_shape(direction, height, WIDTH)
@export var na: String

var display_rect: Rect2


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered) and not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)
	
	update_shape(direction, height, WIDTH)

func _on_body_entered(body: Node2D):
	if body is Player:
		print("LTRANS: Player: ", body.global_position, ", transition bounds: ", Rect2(collision_shape_2d.global_position, collision_shape_2d.shape.size))
		print("I am LTRANS: ", na)
		player_entered.emit(direction)

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(display_rect, Color(0.43, 1, 0, 0.3), true)
		if direction != Types.EastWestNoneDirection.NONE:
			draw_line(Vector2(direction * 2, 0), Vector2(direction * 2, -height * TILE_SIZE), Color.AQUA, 4)

func update_shape(new_direction: Types.EastWestNoneDirection, height_in_tiles: int, width_in_tiles: int) -> void:
	
	if width_in_tiles == 0:
		print("Warning: width is zero!")
	
	var new_width: float = width_in_tiles * TILE_SIZE
	var new_height: float = height_in_tiles * TILE_SIZE
	var new_size: Vector2 = Vector2(new_width, new_height)
	
	collision_shape_2d.shape.size = new_size - Vector2(2.0 * TILE_SIZE, 0)
	
	var y_pos: float = -new_height / 2.0
	var x_pos: float = new_direction * new_width / 2.0
	var new_pos: Vector2 = Vector2(x_pos, y_pos)
	
	collision_shape_2d.position = new_pos + Vector2(1.0 * TILE_SIZE * direction, 0)
	
	set_display_rect(new_pos, new_size)

func set_display_rect(pos: Vector2, size: Vector2) -> void:
	display_rect.position = pos - size / 2
	display_rect.size = size
	queue_redraw()

func get_player_spawn_position() -> Vector2:
	var spawn_pos: Vector2 = Vector2(global_position.x - 2 * TILE_SIZE * direction, global_position.y)
	return spawn_pos
