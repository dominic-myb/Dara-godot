extends CharacterBody2D
const PROJECTILE = preload("res://src/scripts/projectile.gd")
var GOLD = preload("res://src/collectibles/sea_gold.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"../../Player/PlayerOnSea"
@onready var enemySprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var collider = $CollisionShape2D
@onready var attackRange = $AttackRange/CollisionShape2D
var health = Game.enemyHP
var speed = Game.enemySpeed
var inRange = false
var isAlive = true
var isHurt = false
var inAttackRange = false
var canAttack = true
var attackCooldown = 0.0
var attackTimer = 0.0
func _ready():
	anim.play("Idle")
func _physics_process(_delta):
	if isAlive and inRange:
		var direction = (player.position - self.position).normalized()
		velocity = direction * speed
	else:
		# you can change this to patrol
		velocity = Vector2.ZERO
	move_and_slide()
func _process(delta):
	if isAlive:
		if velocity.x > 0: 
			enemySprite.flip_h = false
		elif velocity.x < 0:
			enemySprite.flip_h = true
			collider.position.x = -collider.position.x
			attackRange.position.x = -attackRange.position.x

		if not canAttack:
			attackTimer += delta
			if attackTimer>=attackCooldown:
				canAttack = true
				attackTimer = 0.0

		if inAttackRange and canAttack:
			anim.play("Attack")
			await anim.animation_finished
			canAttack = false

		if isHurt:
			anim.play("Hurt")
			await anim.animation_finished
			isHurt = false

		if inRange:
			anim.play("Move")
		else:
			anim.play("Idle")

func take_damage(damage: int):
	isHurt = true
	health -= damage
	if health <= 0: 
		death()
	else: 
		return health

func death():
	isAlive = false
	velocity = Vector2.ZERO #stays where the object is
	collider.disabled = true # collider off, can't detect projectiles
	anim.play("Death")
	await anim.animation_finished
	enemy_loot()
	Game.playerExp += 1000
	Utils.saveGame()
	queue_free()
func enemy_loot():
	var goldTemp = GOLD.instantiate()
	goldTemp.position = $".".position
	$"../../Collectibles".add_child(goldTemp)
func _on_player_detection_body_entered(_body):
	if get_collision_mask_value(3): inRange = true

func _on_player_detection_body_exited(_body):
	if get_collision_mask_value(3): inRange = false

func _on_attack_range_body_entered(_body):
	if get_collision_mask_value(3): inAttackRange = true

func _on_attack_range_body_exited(_body):
	if get_collision_mask_value(3): inAttackRange = false

func _on_attack_area_2d_body_entered(_body):
	if get_collision_mask_value(3): print("player hit")
