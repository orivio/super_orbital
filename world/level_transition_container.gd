@tool
class_name LevelTransitionContainer
extends Node2D


@export var new_transition_direction: Types.EastWestNoneDirection = Types.EastWestNoneDirection.EAST
@export var new_transition_height: int = 3
@export_tool_button("Add Level Transition") var add_level_transition_button: Callable = add_level_transition
@export var west_transition: LevelTransition = null
@export var east_transition: LevelTransition = null

var level_transition_scene_path: String = "uid://7q0weygp4gex"


@onready var camera_bounds: Area2D = $"../CameraBounds"


func add_level_transition() -> void:
	# Quick validation check
	if new_transition_direction == Types.EastWestNoneDirection.NONE:
		print("Can't add a transition with no direction!")
		return
	
	# Instantiate the scene
	var level_transition_scene: PackedScene = load(level_transition_scene_path)
	var level_transition_instance: LevelTransition = level_transition_scene.instantiate()
	
	
	# Set up the transition
	match new_transition_direction:
		Types.EastWestNoneDirection.WEST:
			level_transition_instance.set_name("LevelTransition_West")
		Types.EastWestNoneDirection.EAST:
			level_transition_instance.set_name("LevelTransition_East")
		Types.EastWestNoneDirection.NONE:
			level_transition_instance.set_name("LevelTransition")
	
	add_child(level_transition_instance)
	level_transition_instance.owner = get_tree().edited_scene_root
	
	if not level_transition_instance.is_node_ready():
		await level_transition_instance.ready
	
	level_transition_instance.direction = new_transition_direction
	level_transition_instance.height = new_transition_height
	
	# Assign transition variables in the inspector
	match new_transition_direction:
		Types.EastWestNoneDirection.EAST:
			east_transition = level_transition_instance
		Types.EastWestNoneDirection.WEST:
			west_transition = level_transition_instance
	
	# Make it a little easier to position the level transitions
	new_transition_direction = Types.EastWestNoneDirection.EAST
	camera_bounds.visible = true

func get_level_transitions() -> Array[LevelTransition]:
	return get_children() as Array[LevelTransition]

func get_level_transition(direction: Types.EastWestNoneDirection) -> LevelTransition:
	match direction:
		Types.EastWestNoneDirection.EAST:
			return east_transition
		Types.EastWestNoneDirection.WEST:
			return west_transition
		_:
			return null
