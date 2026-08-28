class_name SoundDirectory
extends Resource

@export var sounds: Dictionary[StringName,AudioStream]


func get_sound(name: StringName) -> AudioStream:
	return sounds.get(name)
