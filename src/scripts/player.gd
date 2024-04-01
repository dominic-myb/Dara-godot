extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isDead = false
@onready var anim = get_node("AnimationPlayer")

func _ready(): 
	anim.play("Idle")
func _physics_process(delta):
	if not isDead:
		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true;
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false;
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("Move")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim.play("Idle")
		move_and_slide()

func take_damage(damage):
	Game.playerHP -= damage
	if Game.playerHP <= 0:
		isDead = true
		death()
	return Game.playerHP

func death():
	get_node("AnimatedSprite2D").play("Attack")
	await get_node("AnimatedSprite2D").animation_finished
	get_tree().change_scene_to_file("res://src/scenes/main.tscn")
