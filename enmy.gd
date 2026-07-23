extends CharacterBody2D

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


func _on_head_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		body.velocity.y = -250  # يجعل اللاعب يرتد للأعلى
		queue_free()            # حذف العدو




func _on_body_body_entered(body: Node2D) -> void:
	if (body.name == "player"):
		get_tree().reload_current_scene()
