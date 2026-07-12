extends Resource
class_name DialogueLine

@export var speaker: Speaker = preload("res://dialogue/speaker/narrator/narrator.tres")
@export var side: Types.ConvoSide = Types.ConvoSide.RIGHT
@export var text: String = ""
@export var typing_speed: float = 0.05
