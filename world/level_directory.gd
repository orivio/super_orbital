class_name LevelDirectory
extends Resource

@export var levels: Array[LevelMeta]


func get_level_meta(level_idx: int) -> LevelMeta:
	return levels[level_idx]
