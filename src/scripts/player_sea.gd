extends CharacterBody2D

const SPEED = 600.0
const PROJECTILE_PATH = preload("res://src/scenes/projectile.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var joystick = $"../../CanvasLayer/joystick"
@onready var player_sprite = $AnimatedSprite2D
@onready var player_anim = $AnimationPlayer
@onready var attack = $"../../CanvasLayer/Attack"
@onready var inner = $"../../CanvasLayer/Attack/inner"

func _ready():
	player_anim.play("Idle")

func _physics_process(delta):
	var direction = joystick.vector_pos
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
	move_and_slide()
func _process(_delta):
	if inner.handle_press():
		shoot()
func shoot():
	var proj = PROJECTILE_PATH.instantiate()
	get_parent().add_child(proj)
	proj.position = $Aim/Marker2D.global_position
	proj.velocity = get_global_mouse_position() - proj.position
