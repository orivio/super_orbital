@tool
class_name Door extends Area2D

signal door_entered(dest_room_path: String, dest_door_tag: String)

const GRID_SIZE: float = 100

@export var door_tag: String
@export var dest_door_tag: String
@export_file("*.tscn") var dest_room_path: String

@onready var spawn: Marker2D = $Spawn
@onready var bounds: CollisionShape2D = $DoorBounds

func _enter_tree() -> void:
	$Label.set_meta("_edit_lock_", true)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		
		# Snap bounds to grid
		
		var door_bounds: RectangleShape2D = $DoorBounds.shape
		var grid: Vector2 = Vector2(GRID_SIZE, GRID_SIZE)
		var top_left: Vector2 = ($DoorBounds.position - door_bounds.size / 2).snapped(grid)
		var bottom_right: Vector2 = ($DoorBounds.position + door_bounds.size / 2).snapped(grid)

		#$DoorBounds.shape.set_size(bottom_right - top_left)
		#$DoorBounds.position = (top_left + bottom_right) / 2
		
		# Align label
		
		$Label.size.x = bottom_right.x - top_left.x
		$Label.size.y = GRID_SIZE
		$Label.position.x = top_left.x
		$Label.position.y = top_left.y - GRID_SIZE
		#$Label.text = door_tag
		$Label.text = ""
		$Label.visible = true
	else:
		$Label.visible = true

func _ready() -> void:
	monitoring = false
	get_tree().create_timer(0.1).timeout.connect(func(): monitoring = true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		#print("Door ", door_tag, " is colliding with player at ", body.position, ", and they are going to go to ", dest_door_tag, " in room ", ResourceUID.get_id_path(ResourceUID.text_to_id(dest_room_path)))
		#print("Player position: ", body.global_position, ", my position: ", bounds.global_position)
		#print("The room manager looks like this:")
		#self.get_parent().get_parent().get_parent().get_parent().print_tree_pretty()
		#print("Body name: ", body.name)
		#print("Entered door: ", door_tag, ", going to door: ", dest_door_tag, ", to room: ", dest_room_path)
		door_entered.emit(dest_room_path, dest_door_tag)
