extends CharacterBody2D

const SPEED = 1000

func _physics_process(delta):
	var _collision_info = move_and_collide(velocity.normalized() * delta * SPEED)
	get_node("AnimatedSprite2D").play("Move")
