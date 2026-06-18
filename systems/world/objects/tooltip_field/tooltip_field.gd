@tool
class_name TooltipField extends Area2D

@export var message: String

func _enter_tree() -> void:
	#$Label.set_meta("_edit_lock_", true)
	pass


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		var bounds: RectangleShape2D = $CollisionShape2D.shape
		var top_left: Vector2 = $CollisionShape2D.position - bounds.size / 2
		var bottom_right: Vector2 = $CollisionShape2D.position + bounds.size / 2

		$Label.size.x = bottom_right.x - top_left.x
		$Label.size.y = 100
		$Label.position.x = top_left.x
		$Label.position.y = top_left.y - 100
		$Label.text = message
		$Label.visible = true
	else:
		$Label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and "show_tooltip" in body and not body.disabled:
		body.show_tooltip(message)
		#print("Showing tooltip: ", message)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and "hide_tooltip" in body and not body.disabled:
		body.hide_tooltip()
		#print("Hiding tooltip: ", message)
