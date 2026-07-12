extends Control

const OPENING_NARRATION = preload("res://dialogue/scripts/opening_narration.tres")


@export var target_speaker_rise_height: float = 30.0
@export var target_speaker_rise_scale: float = 1.1
@export var speaker_rise_duration: float = 0.1

@export var target_speaker_fall_scale: float = 0.8
@export var target_speaker_fall_alpha: float = 0.8
@export var speaker_fall_duration: float = 0.1

@export var pedestal_rise_duration: float = 0.1
@export var pedestal_fall_duration: float = 0.1


var current_line: String = "Hello"
var current_side: Types.ConvoSide

var left_portrait_up_tween: Tween
var left_portrait_down_tween: Tween
var right_portrait_up_tween: Tween
var right_portrait_down_tween: Tween
var pedestal_up_tween: Tween
var pedestal_down_tween: Tween
var typewriter_tween: Tween

var pedestal_y_pos: float

var ready_for_next_line: bool


@onready var dialogue_pedestal: NinePatchRect = $DialoguePedestal

@onready var left_portrait_container: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/LeftPortraitContainer
@onready var left_portrait: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/LeftPortraitContainer/VBoxContainer/Control/TextureRect
@onready var left_background: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/LeftPortraitContainer/VBoxContainer/Control/CardBackground
@onready var left_name: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/LeftPortraitContainer/VBoxContainer/Label

@onready var right_portrait_container: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/RightPortraitContainer
@onready var right_portrait: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/RightPortraitContainer/VBoxContainer/Control/TextureRect
@onready var right_background: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/RightPortraitContainer/VBoxContainer/Control/CardBackground
@onready var right_name: Control = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/RightPortraitContainer/VBoxContainer/Label

@onready var dialogue_box: RichTextLabel = $DialoguePedestal/InteriorMarginContainer/HBoxContainer/MarginContainer/DialogueContent


func _ready() -> void:
	DialogueManager.dialogue_requested.connect(_on_dialogue_requested)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.line_ready.connect(_on_line_ready)
	
	pedestal_y_pos = dialogue_pedestal.position.y
	dialogue_pedestal.position.y = get_viewport_rect().size.y
	hide_portrait(left_background, left_portrait, left_name)
	hide_portrait(right_background, right_portrait, right_name)
	
	dialogue_box.text = ""

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		DialogueManager.start_dialogue(OPENING_NARRATION)
	
	if Input.is_action_just_pressed("ui_accept") and ready_for_next_line:
		DialogueManager.advance()

func animate_portrait_up(portrait: Control, tween: Tween):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(portrait, "position:y", -target_speaker_rise_height, speaker_rise_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(portrait, "scale", Vector2(target_speaker_rise_scale, target_speaker_rise_scale), speaker_rise_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(portrait, "modulate:a", 1.0, speaker_rise_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func animate_portrait_down(portrait: Control, tween: Tween):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(portrait, "position:y", 0, speaker_fall_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(portrait, "scale", Vector2(target_speaker_fall_scale, target_speaker_fall_scale), speaker_fall_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(portrait, "modulate:a", target_speaker_fall_alpha, speaker_fall_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func set_speaker_display(portrait: TextureRect, background: ColorRect, label: Label, speaker: Speaker):
	portrait.texture = speaker.portrait
	background.color = speaker.bg_color
	label.text = speaker.name

func change_speaker(speaker: Speaker, side: Types.ConvoSide):
	match current_side:
		Types.ConvoSide.LEFT:
			animate_portrait_down(left_portrait_container, left_portrait_down_tween)
		Types.ConvoSide.RIGHT:
			animate_portrait_down(right_portrait_container, right_portrait_down_tween)
	current_side = side
	match current_side:
		Types.ConvoSide.LEFT:
			animate_portrait_up(left_portrait_container, left_portrait_up_tween)
			set_speaker_display(left_portrait, left_background, left_name, speaker)
		Types.ConvoSide.RIGHT:
			animate_portrait_up(right_portrait_container, right_portrait_up_tween)
			set_speaker_display(right_portrait, right_background, right_name, speaker)

func show_dialogue_pedestal():
	if pedestal_up_tween:
		pedestal_up_tween.kill()
	pedestal_up_tween = create_tween()
	pedestal_up_tween.set_parallel(true)
	pedestal_up_tween.tween_property(dialogue_pedestal, "position:y", 460, pedestal_rise_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	pedestal_up_tween.tween_property(dialogue_pedestal, "modulate:a", 1, pedestal_rise_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	return pedestal_up_tween

func hide_dialogue_pedestal():
	if pedestal_down_tween:
		pedestal_down_tween.kill()
	pedestal_down_tween = create_tween()
	pedestal_down_tween.set_parallel(true)
	pedestal_down_tween.tween_property(dialogue_pedestal, "position:y", get_viewport_rect().size.y, pedestal_fall_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	pedestal_down_tween.tween_property(dialogue_pedestal, "modulate:a", 0, pedestal_fall_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func hide_portrait(background: ColorRect, portrait: TextureRect, name: Label):
	background.color = Color(0, 0, 0, 0)
	portrait.texture = null
	name.text = ""

func _on_dialogue_requested():
	dialogue_box.text = ""
	show_dialogue_pedestal().finished.connect(DialogueManager.advance)
	
func _on_line_ready(line: DialogueLine):
	change_speaker(line.speaker, line.side)
	dialogue_box.text = line.text
	ready_for_next_line = false
	dialogue_box.visible_ratio = 0
	if typewriter_tween:
		typewriter_tween.kill()
	typewriter_tween = create_tween()
	typewriter_tween.tween_property(dialogue_box, "visible_ratio", (line.text.length() + 1)/line.text.length(), line.typing_speed * line.text.length())
	typewriter_tween.finished.connect(_on_typewriter_finished)

func _on_dialogue_ended():
	hide_dialogue_pedestal()
	hide_portrait(left_background, left_portrait, left_name)
	hide_portrait(right_background, right_portrait, right_name)

func _on_typewriter_finished():
	ready_for_next_line = true
