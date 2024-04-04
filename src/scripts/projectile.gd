extends CharacterBody2D

const SPEED = 300

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * SPEED)
	get_node("AnimatedSprite2D").play("Move")
