class_name StateMachine extends Node

@export var default_state: State

var states: Array[State]
var prev_state: State
var current_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	var new_state: State = current_state.process(delta)
	change_state(new_state)

func _physics_process(delta: float) -> void:
	var new_state: State = current_state.physics_process(delta)
	change_state(new_state)

func initialize() -> void:
	states = []
	
	for state in get_children():
		if state is State:
			states.append(state)
	
	change_state(default_state)
	
	process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state: State) -> void:
	
	if new_state == null or new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	prev_state = current_state
	current_state = new_state
	current_state.enter()
