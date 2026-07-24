extends CharacterBody2D


@onready var sprite_2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape = $CollisionShape2D

# --- الثوابت والحركة الأساسية ---
const SPEED = 400.0
const JUMP_VELOCITY = -900.0
const MIN_JUMP_VELOCITY = -300.0
var hearts = 3

# --- 1. Variable Jump & Mechanics Timers ---
const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.15

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

# --- 2. Dash Mechanics ---
const DASH_SPEED = 1000.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: float = 0.0

# --- 3. Wall Jump & Slide Mechanics ---
const WALL_SLIDE_SPEED = 150.0
const WALL_JUMP_VELOCITY = Vector2(600, -800)

var is_wall_sliding: bool = false

# --- 4. Ground Slide Mechanics ---
const SLIDE_SPEED = 600.0
const SLIDE_DURATION = 0.4
const SLIDE_FRICTION = 800.0

var is_sliding: bool = false
var slide_timer: float = 0.0
var slide_direction: float = 0.0
var original_capsule_height: float = 0.0


func _ready() -> void:
	# حفظ الارتفاع الأصلي للـ Collision
	if collision_shape and collision_shape.shape is CapsuleShape2D:
		original_capsule_height = collision_shape.shape.height


func _physics_process(delta: float) -> void:
	# تحديث المؤقتات
	if coyote_timer > 0: coyote_timer -= delta
	if jump_buffer_timer > 0: jump_buffer_timer -= delta
	if dash_cooldown_timer > 0: dash_cooldown_timer -= delta

	# 1. إدارة الـ DASH
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0
		
		if dash_timer <= 0:
			is_dashing = false
			
		move_and_slide()
		return

	# 2. إدارة الـ GROUND SLIDE (الانزلاق على الأرض)
	if is_sliding:
		slide_timer -= delta
		velocity.x = move_toward(velocity.x, 0, SLIDE_FRICTION * delta)
		
		if slide_timer <= 0 or not is_on_floor():
			stop_slide()
			
		move_and_slide()
		update_animations(Input.get_axis("ui_left", "ui_right"))
		return

	var direction := Input.get_axis("ui_left", "ui_right")

	# الجاذبية و Coyote Time
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		velocity += get_gravity() * delta

	# Wall Slide (انزلاق الجدار)
	is_wall_sliding = is_on_wall() and not is_on_floor() and velocity.y > 0 and direction != 0
	
	if is_wall_sliding:
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)

	# Jump Buffer
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME

	# القفز (Jump Logic)
	if jump_buffer_timer > 0:
		if is_on_floor() or coyote_timer > 0:
			execute_jump(JUMP_VELOCITY)
		elif is_on_wall() and not is_on_floor():
			var wall_normal = get_wall_normal()
			velocity.x = wall_normal.x * WALL_JUMP_VELOCITY.x
			velocity.y = WALL_JUMP_VELOCITY.y
			execute_jump(velocity.y)

	# Variable Jump Height
	if Input.is_action_just_released("ui_accept") and velocity.y < MIN_JUMP_VELOCITY:
		velocity.y = MIN_JUMP_VELOCITY

	# تفعيل الـ DASH
	if Input.is_action_just_pressed("ui_focus_next") and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = direction if direction != 0 else (-1.0 if sprite_2D.flip_h else 1.0)

	# تفعيل الـ GROUND SLIDE
	if Input.is_action_just_pressed("slide") and is_on_floor() and abs(velocity.x) > 100:
		start_slide()

	# الحركة والمشي العادي
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 14)

	move_and_slide()

	# تحديث الأنيميشن
	update_animations(direction)


func start_slide() -> void:
	is_sliding = true
	slide_timer = SLIDE_DURATION
	slide_direction = -1.0 if sprite_2D.flip_h else 1.0
	velocity.x = slide_direction * SLIDE_SPEED
	
	# تقليل ارتفاع الـ Collision عند الانزلاق
	if collision_shape and collision_shape.shape is CapsuleShape2D:
		collision_shape.shape.height = original_capsule_height / 2.0


func stop_slide() -> void:
	is_sliding = false
	# إرجاع الـ Collision لارتفاعه الطبيعي
	if collision_shape and collision_shape.shape is CapsuleShape2D:
		collision_shape.shape.height = original_capsule_height


func execute_jump(jump_force: float) -> void:
	if is_sliding:
		stop_slide()
	velocity.y = jump_force
	$AudioStreamPlayer.play()
	jump_buffer_timer = 0.0
	coyote_timer = 0.0


func update_animations(direction: float) -> void:
	if velocity.x != 0:
		sprite_2D.flip_h = velocity.x < 0

	if is_sliding:
		sprite_2D.animation = "run" # أو يمكنك استخدام "duck" إذا كان متوفراً لديك
	elif not is_on_floor():
		sprite_2D.animation = "jump"
	elif abs(velocity.x) > 1:
		sprite_2D.animation = "run"
	else:
		sprite_2D.animation = "default"


func take_damage():
	hearts -= 1
	print("القلوب: ", hearts)

	if hearts <= 0:
		queue_free()
