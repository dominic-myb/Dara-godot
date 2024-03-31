extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var inRange = false
var isDead = false
var health = 10
@onready var anim = get_node("AnimatedSprite2D")

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
func _physics_process(delta):
	velocity.y += gravity * delta
	if inRange == true and not isDead:
		anim.play("Move")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
		velocity.x = direction.x * SPEED
	else:
		if not isDead:
			anim.play("Idle")
		velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		inRange = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		inRange = false

func _on_player_death_body_entered(body):
	if body.name == "Player":
		_death()

func _on_player_collision_body_entered(body):
	if body.name == "Player":
		velocity.x = 0
		player._take_damage(3)
		_death()
		
func _take_damage(damage):
	health -= damage
	#hurt animation
	#hurt sfx
	if health <= 0:
		#loot out
		_death()
	return health

func _death():
	isDead = true
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()
