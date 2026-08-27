class_name LevelButton
extends Button

@export var disabled_icon: Texture
@export var normal_icon: Texture
@export var hover_icon: Texture


func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	icon = normal_icon

func _on_button_down() -> void:
	icon = disabled_icon

func _on_button_up() -> void:
	icon = normal_icon

func _on_mouse_entered() -> void:
	icon = hover_icon

func _on_mouse_exited() -> void:
	icon = normal_icon
