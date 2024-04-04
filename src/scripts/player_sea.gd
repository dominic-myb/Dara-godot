extends CharacterBody2D

const SPEED = 600.0
const PROJECTILE_PATH = preload("res://src/scenes/projectile.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var joystick = $"../../CanvasLayer/joystick"
@onready var player_sprite = $AnimatedSprite2D
@onready var player_anim = $AnimationPlayer
@onready var attack_js = $"../../CanvasLayer/attack"
@onready var player_aim = $Aim
@onready var inner = $"../../CanvasLayer/attack/inner"
var attack_dir
var is_shooting = false
func _ready():
	player_anim.play("Idle")

func _physics_process(delta):
	var direction = joystick.vector_pos
	attack_dir = attack_js.vector_pos
	var angle_rad = atan2(attack_dir.y, attack_dir.x)
	var angle_deg = rad_to_deg(angle_rad)
	#var rotation_offset = attack_dir
	player_aim.rotation = deg_to_rad(angle_deg)
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5
	if direction:
		player_anim.play("Move")
		velocity = direction * SPEED * 0.5
	else:
		player_anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(0, velocity.y, 10)
	if velocity.x > 0:
		player_sprite.flip_h = false
	elif velocity.x < 0:
		player_sprite.flip_h = true
	if is_shooting:
		shoot(attack_dir)
	move_and_slide()
func shoot(aim_direction):
	var proj = PROJECTILE_PATH.instantiate()
	get_parent().add_child(proj)
	proj.position = $Aim/Marker2D.global_position  # Optional: Use Aim marker for initial position
	proj.velocity = aim_direction
