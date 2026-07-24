extends Node2D


const PAUSE_MENU: PackedScene = preload("res://scenes/pause_menu/pause_menu.tscn")


@export var pause_menu_enter_duration: float
@export var pause_menu_exit_duration: float


var pause_menu: PauseMenu = null
var pause_menu_enter_tween: Tween
var pause_menu_exit_tween: Tween


@onready var world: World = $World
@onready var ui_layer: CanvasLayer = $UI


func _ready() -> void:
	world.init_room()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not pause_menu:
			if pause_menu_enter_tween:
				return
			if pause_menu_exit_tween:
				return
			
			pause_menu = PAUSE_MENU.instantiate()
			ui_layer.add_child(pause_menu)
			pause_menu.disable_input = true
			pause_menu.close.connect(_on_pause_menu_close)
			
			pause_menu.position.y = get_viewport_rect().size.y
			
			pause_menu_enter_tween = create_tween()
			pause_menu_enter_tween.tween_property(pause_menu, "position:y", 0, pause_menu_enter_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
			await pause_menu_enter_tween.finished
			
			pause_menu_enter_tween = null
			pause_menu.disable_input = false
		
		else:
			if pause_menu_enter_tween:
				return
			if pause_menu_exit_tween:
				return
			
			pause_menu.disable_input = true
			
			pause_menu_exit_tween = create_tween()
			pause_menu_exit_tween.tween_property(pause_menu, "position:y", get_viewport_rect().size.y, pause_menu_exit_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			
			await pause_menu_exit_tween.finished
			
			pause_menu_exit_tween = null
			
			pause_menu.queue_free()
			pause_menu = null

func _on_pause_menu_close() -> void:
	if pause_menu_enter_tween:
		pause_menu_enter_tween.kill()
		pause_menu_enter_tween = null
	if pause_menu_exit_tween:
		return
	
	pause_menu.disable_input = true
	
	pause_menu_exit_tween = create_tween()
	pause_menu_exit_tween.tween_property(pause_menu, "position:y", get_viewport_rect().size.y, pause_menu_exit_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	await pause_menu_exit_tween.finished
	
	pause_menu_exit_tween = null
	
	pause_menu.queue_free()
	pause_menu = null
