extends Node

signal dialogue_requested
signal line_ready(line: DialogueLine)
signal dialogue_ended(tag: StringName)

var line_index: int = 0
var current_convo: Conversation = null
var current_convo_tag: StringName

func start_dialogue(convo: Conversation, convo_tag: StringName):
	if current_convo:
		return
	line_index = 0
	current_convo = convo
	current_convo_tag = convo_tag
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
	dialogue_ended.emit(current_convo_tag)
	GameManager.unlock_input()
	current_convo = null
	current_convo_tag = &""
