extends CharacterBody2D

const SPEED = 150.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 10
var inRange = false
var isAlive = true
@onready var player = get_node("../../Player/Player")
@onready var anim = $AnimatedSprite2D
var direction
func _ready():
	anim.play("Idle")
func _physics_process(_delta):
	if isAlive and inRange:
		anim.play("Move")
		direction = (player.position - self.position).normalized()
		if direction.x > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
		velocity = direction * SPEED
	if not inRange:
		anim.play("Idle")
		#EnemyPatrol()
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		inRange = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		inRange = false

func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()
		
func take_damage(damage):
	health -= damage
	#hurt animation
	#hurt sfx
	if health <= 0:
		#loot out
		death()
	return health

func death():
	isAlive = false
	get_node("PlayerDeath").queue_free()
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()

#func EnemyPatrol():
	#var min_x = 0
	#var max_x = 3000
	#var min_y = 0
	#var max_y = 1025
	#var X = randf_range(min_x, max_x)
	#var Y = randf_range(min_y, max_y)
	#direction = (Vector2(X, Y) - self.position).normalized()
	#velocity = direction * SPEED
	#print(direction)
	#move_and_slide()
