class_name ControlPrefs
extends Resource

@export var left_key: InputEvent
@export var right_key: InputEvent
@export var up_key: InputEvent
@export var down_key: InputEvent
@export var jump_key: InputEvent
@export var dash_key: InputEvent
@export var gravity_switch_key: InputEvent
@export var throw_wrench_key: InputEvent
@export var confirm_key: InputEvent

func get_json() -> Dictionary:
	return {
		"left": left_key,
		"right": right_key,
		"up": up_key,
		"down": down_key,
		"jump": jump_key,
		"dash": dash_key,
		"gravity_switch": gravity_switch_key,
		"throw_wrench": throw_wrench_key,
		"confirm": confirm_key,
	}

static func from_json(json: Dictionary) -> ControlPrefs:
	var abilities: ControlPrefs = ControlPrefs.new()
	abilities.abilities = json
	return abilities
