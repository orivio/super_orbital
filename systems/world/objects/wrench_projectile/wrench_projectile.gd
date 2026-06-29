extends Area2D

var velocity: Vector2 = Vector2.ZERO
var rotation_speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	rotation += rotation_speed * delta


func _on_body_entered(body: Node2D) -> void:
	# Collision with level
	queue_free()
