class_name PlayerAbilities extends Resource

@export var can_move: bool = false
@export var can_jump: bool = false
@export var can_dash: bool = false
@export var can_gravity_switch: bool = false
@export var can_throw_wrench: bool = false

func unlock(ability: String) -> void:
	match ability:
		"move":
			can_move = true
		"jump":
			can_jump = true
		"dash":
			can_dash = true
		"gravity_switch":
			can_gravity_switch = true
		"throw_wrench":
			can_throw_wrench = true
		_:
			pass

func lock(ability: String) -> void:
	match ability:
		"move":
			can_move = false
		"jump":
			can_jump = false
		"dash":
			can_dash = false
		"gravity_switch":
			can_gravity_switch = false
		"throw_wrench":
			can_throw_wrench = false
		_:
			pass
