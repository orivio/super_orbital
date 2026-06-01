class_name Player extends CharacterBody2D

const JUMP_VELOCITY = -800.0
const GRAVITY = 100000000

@export var gravity: float = 15
@export var gravity_fall_multiplier: float = 1.5

#var gravity = true
var direction: float

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GameManager.player = self
	state_machine.initialize()

func _process(_delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity
		else:
			velocity.y += gravity * gravity_fall_multiplier
	
	#if gravity:
	#	# Add the gravity.
	#	if not is_on_floor():
	#		velocity += get_gravity() * delta

	#	# Handle jump.
	#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#		velocity.y = JUMP_VELOCITY

	#	# Get the input direction and handle the movement/deceleration.
	#	# As good practice, you should replace UI actions with custom gameplay actions.
	#	var direction := Input.get_axis("ui_left", "ui_right")
	#	if direction:
	#		velocity.x = direction * SPEED
	#	else:
	#		velocity.x = move_toward(velocity.x, 0, SPEED)

	#	move_and_slide()
	#else:
	#	var y = 0;
	#	for ch in PhysicsManager.black_holes:
	#		var distance = ch.position.distance_to(position);
	#		var direction = (ch.position - position);
	#		velocity += GRAVITY * delta * direction.normalized() / (distance * distance)
	#		print(velocity)
	#	move_and_slide()
	
	#if Input.is_action_just_pressed("Gravity Switch"):
	#	gravity = !gravity
	move_and_slide()

func update_animation(animation: String):
	if animation_player.current_animation != animation:
		animation_player.play(animation)
