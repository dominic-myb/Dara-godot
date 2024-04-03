extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_sprite = $AnimatedSprite2D
@onready var player_anim = $AnimationPlayer
const SPEED = 700.0
const JUMP_VELOCITY = -500.0
var is_alive = true

func _ready(): 
	player_anim.play("Idle")
func _physics_process(delta):
	if is_alive:
		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			player_sprite.flip_h = true
		elif direction == 1:
			player_sprite.flip_h = false

		if velocity == Vector2.ZERO:
			player_anim.play("Idle")
		else:
			player_anim.play("Move")

		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 35)
		move_and_slide()

func take_damage(damage):
	Game.playerHP -= damage
	if Game.playerHP <= 0:
		is_alive = false
		death()
	return Game.playerHP

func death():
	player_sprite.play("Attack")
	await player_sprite.animation_finished
	get_tree().change_scene_to_file("res://src/scenes/main.tscn")

