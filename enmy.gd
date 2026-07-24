extends CharacterBody2D
@onready var gamemanger: Node = %gamemanger

@export var speed := 50.0
var direction := 1

@onready var floor_ray: RayCast2D = $FloorRay2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_ray_3: RayCast2D = $FloorRay3

func _physics_process(delta):
	if !is_on_floor():
		velocity += get_gravity() * delta

	if is_on_wall() or !floor_ray.is_colliding():
		direction *= -1
		floor_ray.position.x *= -1
		sprite.flip_h = direction < 0

	velocity.x = -speed * direction
	move_and_slide()

	if !is_on_floor():
		velocity += get_gravity() * delta

	if is_on_wall() or !floor_ray_3.is_colliding():
		direction *= -1
		floor_ray_3.position.x *= -1
		sprite.flip_h = direction < 0

	velocity.x = -speed * direction
	move_and_slide()





func _on_body_body_entered(body: Node2D) -> void:
	if (body.name == "player"):
				body.velocity.x = -500  # يجعل اللاعب يرتد للأعلى
				gamemanger.halth()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.velocity.y = -250  # يجعل اللاعب يرتد للأعلى
		queue_free()            #
