extends CPUParticles2D

@export var emission_time: float = 0.4

@onready var timer: Timer = $Timer

func _ready() -> void:
	print("READY: ", global_position)
	emitting = false

func start() -> void:
	print("START: ", global_position)
	emitting = true
	timer.start(emission_time)

func _on_timer_timeout() -> void:
	emitting = false

func _physics_process(delta: float) -> void:
	print("UPDATE: ", global_position)
