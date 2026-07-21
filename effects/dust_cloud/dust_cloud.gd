extends CPUParticles2D

@export var emission_time: float = 0.4

@onready var timer: Timer = $Timer

func start() -> void:
	emitting = true
	timer.start(emission_time)

func _on_timer_timeout() -> void:
	emitting = false
