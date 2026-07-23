extends CharacterBody2D

@export var speed := 50.0
var direction := 1

@onready var wall_ray: RayCast2D = $FloorRay
@onready var floor_ray: RayCast2D = $FloorRay2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func turn():
	direction *= -1

	wall_ray.target_position.x *= -1
	floor_ray.position.x *= -1

	sprite.flip_h = direction < 0

func _physics_process(delta):
	if !is_on_floor():
		velocity += get_gravity() * delta

	# إذا اصطدم بحائط
	if wall_ray.is_colliding():
		turn()

	# إذا لم يجد أرضًا أمامه
	if !floor_ray.is_colliding():
		turn()

	velocity.x = speed * direction
	move_and_slide()
