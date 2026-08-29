extends Node

signal dialogue_requested
signal line_ready(line: DialogueLine)
signal dialogue_ended(tag: StringName)

var line_index: int = 0
var current_convo: Conversation = null
var current_convo_tag: StringName

func start_dialogue(convo: Conversation, convo_tag: StringName) -> bool:
	if current_convo:
		return false
	
	if not GameManager.play.start_dialogue():
		return false
	
	GameManager.player.lock_input()
	
	line_index = 0
	current_convo = convo
	current_convo_tag = convo_tag
	dialogue_requested.emit()
	return true

func advance() -> void:
	if not current_convo:
		return
	if line_index >= current_convo.lines.size():
		end_dialogue()
	else:
		line_ready.emit(current_convo.lines[line_index])
	
	line_index += 1

func end_dialogue() -> void:
	dialogue_ended.emit(current_convo_tag)
	GameManager.play.end_dialogue()
	GameManager.player.unlock_input()
	current_convo = null
	current_convo_tag = &""

func end_dialogue_fast() -> void:
	GameManager.player.unlock_input()
	current_convo = null
	current_convo_tag = &""
	line_index = 0

func get_next_side_speaker(side: Types.ConvoSide) -> Speaker:
	if not current_convo:
		return null
	
	for line in current_convo.lines:
		if line.side == side:
			return line.speaker
	
	return null
