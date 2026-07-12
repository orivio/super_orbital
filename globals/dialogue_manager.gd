extends Node

signal dialogue_requested
signal line_ready(line: DialogueLine)
signal dialogue_ended

var line_index: int = 0
var current_convo: Conversation = null

func start_dialogue(convo: Conversation):
	if current_convo:
		return
	line_index = 0
	current_convo = convo
	GameManager.lock_input()
	dialogue_requested.emit()

func advance():
	if not current_convo:
		return
	if line_index >= current_convo.lines.size():
		end_dialogue()
	else:
		line_ready.emit(current_convo.lines[line_index])
	
	line_index += 1

func end_dialogue():
	dialogue_ended.emit()
	GameManager.unlock_input()
	current_convo = null
