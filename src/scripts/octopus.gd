extends CharacterBody2D
const PROJECTILE = preload("res://src/scripts/projectile.gd")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"../../Player/PlayerOnSea"
@onready var anim = $AnimatedSprite2D
@onready var hurtbox = $hurtbox
@onready var collider = $CollisionShape2D
var health = 1
const SPEED = 150.0
var in_range = false
var is_alive = true
func _ready():
	anim.play("Idle")
func _physics_process(_delta):
	if is_alive and in_range:
		var direction = (player.position - self.position).normalized()
		velocity = direction * SPEED
	move_and_slide()
func _process(delta):
	if is_alive:
		if velocity.x > 0: anim.flip_h = false
		elif velocity.x < 0:
			anim.flip_h = true
			collider.position.x = -collider.position.x
			hurtbox.position.x = -hurtbox.position.x
		anim.play("Move" if in_range else "Idle")
func _on_player_detection_body_entered(body):
	if body.name == "PlayerOnSea":
		in_range = true

func _on_player_detection_body_exited(body):
	if body.name == "PlayerOnSea":
		in_range = false
		
func take_damage(damage):
	health = health - damage
	if health <= 0:
		death()
	else:
		return health

func death():
	is_alive = false
	velocity = Vector2.ZERO
	anim.play("Death")
	await anim.animation_finished
	queue_free()

func _on_hurtbox_body_entered(body):
	if body.name == "Projectile":
		take_damage(1)
	if body.name == "PlayerOnSea":
		take_damage(1)
