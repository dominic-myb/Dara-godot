extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"../../Player/Player"
@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var collider = $CollisionShape2D
const SPEED = 150.0
var in_range = false
var is_alive = true
var health = 10
var direction
func _ready():
	anim.play("Idle")
func _physics_process(_delta):
	if is_alive and in_range:
		anim.play("Move")
		direction = (player.position - self.position).normalized()
		if direction.x > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
			collider.position.x = -collider.position.x
		velocity = direction * SPEED
	if not in_range:
		anim.play("Idle")
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		in_range = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		in_range = false

func _on_hitbox_body_entered(body):
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
	is_alive = false
	hitbox.queue_free()
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()
