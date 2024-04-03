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

	var h_direction = Input.get_axis("ui_left", "ui_right")
	var v_direction = Input.get_axis("ui_up","ui_down")

	if h_direction == -1:
		player_sprite.flip_h = true
	elif h_direction == 1:
		player_sprite.flip_h = false
	if h_direction or v_direction:
		player_anim.play("Move")
		if h_direction:
			velocity.x = h_direction * SPEED * 0.5
			velocity.y = 0
		if v_direction:
			velocity.y = v_direction * SPEED * 0.5
			#velocity.x = 0
	else:
		player_anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, 30)
		velocity.y = move_toward(0, velocity.y, 10)
	move_and_slide()
