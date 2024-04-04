extends CharacterBody2D
const PROJECTILE = preload("res://src/scripts/projectile.gd")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"../../Player/PlayerOnSea"
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
	if body.name == "PlayerOnSea":
		in_range = true

func _on_player_detection_body_exited(body):
	if body.name == "PlayerOnSea":
		in_range = false

func _on_hitbox_body_entered(body):
	if body.name == "PlayerOnSea":
		print("player enters")
	if body.name == "Projectile":
		print("hit!")
		
func take_damage(damage):
	health -= damage
	print("HP: ", health)
	if health <= 0:
		death()
	return health

func death():
	is_alive = false
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()
