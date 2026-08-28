class_name InputComponent
extends Node

enum InputComponentState {
	NOT_RECORDING,
	RECORDING,
	PLAYING_BACK
}

var horizontal_input_direction: float
var current_state: InputComponentState
var frame_number: int
var current_input_sequence: InputSequence
var sequence_path: String = "user://sequence_2026-08-28T18-07-00.res"


func _ready() -> void:
	current_state = InputComponentState.NOT_RECORDING
	frame_number = -1
	current_input_sequence = null


func _physics_process(_delta: float) -> void:
	var current_frame: InputFrame = null
	
	if current_state == InputComponentState.PLAYING_BACK:
		if frame_number >= current_input_sequence.frames.size():
			stop_playback()
		else:
			current_frame = current_input_sequence.frames[frame_number]
	elif current_state == InputComponentState.RECORDING:
		current_frame = InputFrame.new()
	
	if current_state == InputComponentState.PLAYING_BACK:
		horizontal_input_direction = current_frame.horizontal_input
	else:
		
		horizontal_input_direction = Input.get_axis("left", "right")
		
		
		if current_state == InputComponentState.RECORDING:
			current_frame.horizontal_input = horizontal_input_direction
			current_input_sequence.frames.append(current_frame)
	
	if current_state == InputComponentState.PLAYING_BACK or current_state == InputComponentState.RECORDING:
		frame_number += 1


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_recording"):
		start_recording()
	elif event.is_action_pressed("save_recording"):
		save_recording()
	elif event.is_action_pressed("start_playback"):
		load_playback(sequence_path)
	elif event.is_action_pressed("stop_playback"):
		stop_playback()


func start_recording() -> void:
	if current_state == InputComponentState.PLAYING_BACK or current_state == InputComponentState.RECORDING:
		push_warning("Can't start recording in this state!")
	frame_number = 0
	current_input_sequence = InputSequence.new()
	current_state = InputComponentState.RECORDING
	print("Started recording")


func start_playback(sequence: InputSequence) -> void:
	if current_state == InputComponentState.PLAYING_BACK or current_state == InputComponentState.RECORDING:
		push_warning("Can't start playback in this state!")
	frame_number = 0
	current_input_sequence = sequence
	current_state = InputComponentState.PLAYING_BACK
	print("Started playback")


func stop_playback() -> void:
	if current_state != InputComponentState.PLAYING_BACK:
		push_warning("Can't stop playback in this state!")
	current_state = InputComponentState.NOT_RECORDING
	frame_number = -1
	current_input_sequence = null
	print("Stopped playback")


func save_recording() -> void:
	if current_state != InputComponentState.RECORDING:
		push_warning("Can't save recording in this state!")
		return
	
	frame_number = -1
	current_state = InputComponentState.NOT_RECORDING
	
	var save_path: String = "user://sequence_%s.res" % Time.get_datetime_string_from_system().replace(":", "-")
	sequence_path = save_path
	
	var error: Error = ResourceSaver.save(current_input_sequence, save_path)
	if error == OK:
		print("Saved input sequence to ", save_path)
	else:
		push_error("Failed to save input sequence. Error code: ", error)
	
	current_input_sequence = null


func load_playback(path: String) -> void:
	if FileAccess.file_exists(path):
		var sequence_resource: InputSequence = ResourceLoader.load(path)
		start_playback(sequence_resource)
	else:
		push_error("Nonexistent sequence file: ", path)
