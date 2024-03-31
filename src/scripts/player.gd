extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = -500.0
var health = 10
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
func _physics_process(delta):
	
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
