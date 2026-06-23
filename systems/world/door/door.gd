@tool
class_name Door extends Area2D

signal door_entered(dest_room_path: String, dest_door_tag: String)

const GRID_SIZE: float = 100

@export var door_tag: String
@export var dest_door_tag: String
@export_file("*.tscn") var dest_room_path: String

@onready var spawn: Marker2D = $Spawn

func _enter_tree() -> void:
	$Label.set_meta("_edit_lock_", true)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		
		# Snap bounds to grid
		
		var bounds: RectangleShape2D = $DoorBounds.shape
		var grid: Vector2 = Vector2(GRID_SIZE, GRID_SIZE)
		var top_left: Vector2 = ($DoorBounds.position - bounds.size / 2).snapped(grid)
		var bottom_right: Vector2 = ($DoorBounds.position + bounds.size / 2).snapped(grid)

		#$DoorBounds.shape.set_size(bottom_right - top_left)
		#$DoorBounds.position = (top_left + bottom_right) / 2
		
		# Align label
		
		$Label.size.x = bottom_right.x - top_left.x
		$Label.size.y = GRID_SIZE
		$Label.position.x = top_left.x
		$Label.position.y = top_left.y - GRID_SIZE
		#$Label.text = door_tag
		$Label.text = ""
		$Label.visible = false
	else:
		$Label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# print("Entered door: ", door_tag, ", going to door: ", dest_door_tag, ", to room: ", dest_room_path)
		door_entered.emit(dest_room_path, dest_door_tag)
