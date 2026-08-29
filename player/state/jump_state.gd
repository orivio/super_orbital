class_name JumpState
extends State

@onready var walk: State = $"../Walk"


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	actor.move_and_slide()
	return null
