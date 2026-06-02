class_name PlayerStateMachine extends StateMachine

var player_movement_settings: PlayerMovementSettings

@onready var player: Player = $".."

func initialize() -> void:
	states = []
	
	for state in get_children():
		if state is PlayerState:
			states.append(state)
			state.player = player
			state.player_movement_settings = player_movement_settings
	
	change_state(default_state)
	
	process_mode = Node.PROCESS_MODE_INHERIT
