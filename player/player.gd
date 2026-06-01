extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -800.0
const GRAVITY = 100000000

var gravity = true

@onready var black_holes = $"../BlackHoles"


func _physics_process(delta: float) -> void:
	if gravity:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	else:
		var y = 0;
		for ch in black_holes.get_children():
			var distance = ch.position.distance_to(position);
			var direction = (ch.position - position);
			velocity += GRAVITY * delta * direction.normalized() / (distance * distance)
			print(velocity)
		move_and_slide()
	
	if Input.is_action_just_pressed("Gravity Switch"):
		gravity = !gravity
