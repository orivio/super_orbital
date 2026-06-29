class_name PlayerStateMachine extends StateMachine

@onready var player: Player = $".."

func initialize() -> void:
	states = []
	
	for state in get_children():
		if state is PlayerState:
			states.append(state)
			state.player = player
	
	change_state(default_state)
	
	process_mode = Node.PROCESS_MODE_INHERIT
