extends CharacterBody2D

const SPEED = 600.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_sprite = $AnimatedSprite2D
@onready var player_anim = $AnimationPlayer
func _ready():
	player_anim.play("Idle")
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5

	var x_direction = Input.get_axis("ui_left", "ui_right")
	var v_direction = Input.get_axis("ui_up","ui_down")

	if x_direction == -1:
		player_sprite.flip_h = true
	elif x_direction == 1:
		player_sprite.flip_h = false

	if velocity == Vector2.ZERO:
		player_anim.play("Idle")
	else:
		player_anim.play("Move")
	velocity.x = x_direction * SPEED * 0.5
	
	if v_direction:
		velocity.y = v_direction * SPEED * 0.5
	else:
		velocity.y = move_toward(0, velocity.y, 35)
	move_and_slide()
