class_name Play
extends Node2D

enum PlayState {
	UNINITIALIZED,
	GAMEPLAY,
	TRANSITIONING_ROOMS,
	OPENING_PAUSE_MENU,
	IN_PAUSE_MENU,
	CLOSING_PAUSE_MENU,
	DIALOGUE,
}

const PAUSE_MENU: PackedScene = preload("res://scenes/pause_menu/pause_menu.tscn")

@export var pause_menu_enter_duration: float
@export var pause_menu_exit_duration: float

var pause_menu: PauseMenu = null
var pause_menu_enter_tween: Tween
var pause_menu_exit_tween: Tween
var current_state: PlayState

@onready var world: World = $World
@onready var ui_layer: CanvasLayer = $UI


func _ready() -> void:
	GameManager.play = self
	current_state = PlayState.UNINITIALIZED
	world.door_entered.connect(_on_door_entered)
	world.reload_level_requested.connect(_on_reload_level_requested)
	await world.initialize()
	current_state = PlayState.GAMEPLAY


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match current_state:
			PlayState.GAMEPLAY: open_pause_menu()
			PlayState.IN_PAUSE_MENU: close_pause_menu()


func open_pause_menu() -> void:
	# Change state
	current_state = PlayState.OPENING_PAUSE_MENU
	# Freeze the game
	get_tree().paused = true
	# Instantiate the pause menu
	pause_menu = PAUSE_MENU.instantiate()
	ui_layer.add_child(pause_menu)
	# Connect signals
	pause_menu.close_pressed.connect(_on_pause_menu_close_pressed)
	pause_menu.exit_pressed.connect(_on_pause_menu_exit_pressed)
	pause_menu.level_selected.connect(_on_pause_menu_level_selected)
	# Hide the pause menu below the screen
	pause_menu.position.y = get_viewport_rect().size.y
	# Animate the pause menu sliding upwards
	pause_menu_enter_tween = create_tween()
	pause_menu_enter_tween.tween_property(pause_menu, "position:y", 0, pause_menu_enter_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Wait for the animation to complete
	await pause_menu_enter_tween.finished
	# Clean up everything
	pause_menu_enter_tween = null
	current_state = PlayState.IN_PAUSE_MENU


func close_pause_menu() -> void:
	# Change state
	current_state = PlayState.CLOSING_PAUSE_MENU
	# Animate the pause menu sliding downwards
	pause_menu_exit_tween = create_tween()
	pause_menu_exit_tween.tween_property(pause_menu, "position:y", get_viewport_rect().size.y, pause_menu_exit_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Wait for the animation to finish
	await pause_menu_exit_tween.finished
	# Unfreeze the game
	get_tree().paused = false
	# Clean up
	pause_menu_exit_tween = null
	pause_menu.queue_free()
	pause_menu = null
	current_state = PlayState.GAMEPLAY


func do_level_transition(direction: Types.DoorDirection) -> void:
	current_state = PlayState.TRANSITIONING_ROOMS
	await world.do_level_transition(direction)
	current_state = PlayState.GAMEPLAY


func start_dialogue() -> bool:
	match current_state:
		PlayState.GAMEPLAY:
			current_state = PlayState.DIALOGUE
			return true
		_: return false


func end_dialogue() -> void:
	match current_state:
		PlayState.DIALOGUE:
			current_state = PlayState.GAMEPLAY


func _on_door_entered(direction: Types.DoorDirection) -> void:
	match current_state:
		PlayState.GAMEPLAY: do_level_transition.call_deferred(direction)


func _on_pause_menu_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	DialogueManager.end_dialogue_fast()


func _on_pause_menu_close_pressed() -> void:
	match current_state:
		PlayState.IN_PAUSE_MENU: close_pause_menu()


func _on_pause_menu_level_selected(level_idx: int) -> void:
	match current_state:
		PlayState.IN_PAUSE_MENU:
			await close_pause_menu()
			current_state = PlayState.TRANSITIONING_ROOMS
			await world.goto_level(level_idx)
			current_state = PlayState.GAMEPLAY


func _on_reload_level_requested() -> void:
	match current_state:
		PlayState.GAMEPLAY:
			current_state = PlayState.TRANSITIONING_ROOMS
			await world.reload_level()
			current_state = PlayState.GAMEPLAY
