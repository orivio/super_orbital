class_name DialogueTrigger
extends Area2D

signal interaction_finished(dialogue_tag: StringName)

@export var tag: StringName
@export var conversation: Conversation

var visited: bool
var convo_data: Dictionary


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	interaction_finished.connect(SaveManager._on_dialogue_finished)

func load_data_from_savefile(save_file: SaveFile) -> void:
	if save_file.dialogue_data.has(tag):
		var convo_save_data: Dictionary = save_file.dialogue_data.get(tag)
		convo_data = convo_save_data
		visited = convo_data["finished"]
	else:
		convo_data = Dictionary()
		visited = false

func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not visited:
		DialogueManager.start_dialogue(conversation, tag)
		visited = true

func _on_dialogue_ended(dialogue_tag: StringName) -> void:
	if dialogue_tag == tag:
		interaction_finished.emit(tag)
