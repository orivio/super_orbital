class_name InputComponent
extends Node

enum InputComponentState {
	NOT_RECORDING,
	RECORDING,
	PLAYING_BACK
}

var horizontal_input_direction: float
var left_pressed: bool
var right_pressed: bool
var current_state: InputComponentState


func _ready() -> void:
	current_state = InputComponentState.NOT_RECORDING


func _process(_delta: float) -> void:
	horizontal_input_direction = float(right_pressed) - float(left_pressed)
	print(horizontal_input_direction)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		left_pressed = true
	elif event.is_action_released("left"):
		left_pressed = false
	elif event.is_action_pressed("right"):
		right_pressed = true
	elif event.is_action_released("right"):
		right_pressed = false
