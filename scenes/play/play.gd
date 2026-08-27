extends Node2D

enum PlayState {
	UNINITIALIZED,
	GAMEPLAY,
	TRANSITIONING_ROOMS,
	OPENING_PAUSE_MENU,
	IN_PAUSE_MENU,
	CLOSING_PAUSE_MENU,
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
	current_state = PlayState.UNINITIALIZED
	world.room_transition.connect(_on_world_room_transition)
	world.init_room()
	current_state = PlayState.GAMEPLAY


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match current_state:
			PlayState.GAMEPLAY: open_pause_menu()
			PlayState.IN_PAUSE_MENU: close_pause_menu()
			PlayState.OPENING_PAUSE_MENU: return
			PlayState.CLOSING_PAUSE_MENU: return
			PlayState.UNINITIALIZED: return
			PlayState.TRANSITIONING_ROOMS: return


func _on_pause_menu_close_pressed() -> void:
	match current_state:
		PlayState.IN_PAUSE_MENU: close_pause_menu()
		PlayState.GAMEPLAY: return
		PlayState.OPENING_PAUSE_MENU: return
		PlayState.CLOSING_PAUSE_MENU: return
		PlayState.UNINITIALIZED: return
		PlayState.TRANSITIONING_ROOMS: return


func open_pause_menu() -> void:
	print("Opening pause menu")
	# Change state
	current_state = PlayState.OPENING_PAUSE_MENU
	# Freeze the game
	GameManager.time_scale = 0
	# Instantiate the pause menu
	pause_menu = PAUSE_MENU.instantiate()
	ui_layer.add_child(pause_menu)
	# Don't accept input just yet
	pause_menu.disable_input = true
	pause_menu.close_pressed.connect(_on_pause_menu_close_pressed)
	# Hide the pause menu below the screen
	pause_menu.position.y = get_viewport_rect().size.y
	# Animate the pause menu sliding upwards
	pause_menu_enter_tween = create_tween()
	pause_menu_enter_tween.tween_property(pause_menu, "position:y", 0, pause_menu_enter_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Wait for the animation to complete
	await pause_menu_enter_tween.finished
	# Clean up everything
	pause_menu_enter_tween = null
	pause_menu.disable_input = false
	current_state = PlayState.IN_PAUSE_MENU
	print("Finished opening pause menu")


func close_pause_menu() -> void:
	print("Closing pause menu")
	# Change state
	current_state = PlayState.CLOSING_PAUSE_MENU
	# Don't accept input while the animation is playing
	pause_menu.disable_input = true
	# Animate the pause menu sliding downwards
	pause_menu_exit_tween = create_tween()
	pause_menu_exit_tween.tween_property(pause_menu, "position:y", get_viewport_rect().size.y, pause_menu_exit_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Wait for the animation to finish
	await pause_menu_exit_tween.finished
	# Unfreeze the game
	GameManager.time_scale = 1
	# Clean up
	pause_menu_exit_tween = null
	pause_menu.queue_free()
	pause_menu = null
	current_state = PlayState.GAMEPLAY
	print("Finished closing pause menu")


func do_room_transition(dest_room: String, dest_door_tag: String) -> void:
	current_state = PlayState.TRANSITIONING_ROOMS
	world.do_room_transition(dest_room, dest_door_tag)
	current_state = PlayState.GAMEPLAY


func _on_world_room_transition(dest_room: String, dest_door_tag: String) -> void:
	match current_state:
		PlayState.UNINITIALIZED: return
		PlayState.TRANSITIONING_ROOMS: return
		PlayState.OPENING_PAUSE_MENU: return
		PlayState.IN_PAUSE_MENU: return
		PlayState.CLOSING_PAUSE_MENU: return
		PlayState.GAMEPLAY: do_room_transition(dest_room, dest_door_tag)
