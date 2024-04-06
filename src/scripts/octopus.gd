extends CharacterBody2D
const PROJECTILE = preload("res://src/scripts/projectile.gd")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"../../Player/PlayerOnSea"
@onready var anim = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
var health = 100
const SPEED = 150.0
var inRange = false
var isAlive = true
func _ready():
	anim.play("Idle")
func _physics_process(_delta):
	if isAlive and inRange:
		var direction = (player.position - self.position).normalized()
		velocity = direction * SPEED
	else:
		# you can change this to patrol
		velocity = Vector2.ZERO
	move_and_slide()
func _process(_delta):
	if isAlive:
		if velocity.x > 0: anim.flip_h = false
		elif velocity.x < 0:
			anim.flip_h = true
			collider.position.x = -collider.position.x
		anim.play("Move" if inRange else "Idle")
func _on_player_detection_body_entered(_body):
	if get_collision_mask_value(3): inRange = true

func _on_player_detection_body_exited(_body):
	if get_collision_mask_value(3): inRange = false
		
func take_damage(damage):
	health -= damage
	if health <= 0: death()
	else: return health

func death():
	isAlive = false
	velocity = Vector2.ZERO
	collider.disabled = true
	anim.play("Death")
	await anim.animation_finished
	Game.playerExp += 105
	Utils.saveGame()
	queue_free()
