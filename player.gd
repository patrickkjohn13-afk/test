extends CharacterBody2D

@onready var sprite_2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const SPEED = 400
const JUMP_VELOCITY = -900.00
var hearts = 3


func _physics_process(delta: float) -> void:
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2D.animation = "run"
	else:
		sprite_2D.animation = "default"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2D.animation = "jump"


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AudioStreamPlayer.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 14)

	move_and_slide()

	var isleft = velocity.x < 0 
	sprite_2D.flip_h = isleft
	
func take_damage():
	hearts -= 1
	print("القلوب: ", hearts)

	if hearts <= 0:
		queue_free() # أو أعد تشغيل المرحلة
