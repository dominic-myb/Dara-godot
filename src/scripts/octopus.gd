extends CharacterBody2D
class_name OctoEnemy
const PROJECTILE = preload("res://src/scripts/projectile.gd")
var GOLD = preload("res://src/collectibles/sea_gold.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"../../Player/Player"
@onready var enemy_sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var collider = $CollisionShape2D
var health = Game.enemy_hp
var speed = Game.enemy_speed
var damage = Game.enemy_damage
var in_range = false
var is_alive = true
var is_hurt = false
var in_attack_range = false
var can_attack = true
var attack_cooldown = 3.0
var attack_timer = 0.0
func _physics_process(_delta):
	move_and_slide()
	#if velocity.length() > 0:
		#$AnimationPlayer.play("move")
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

func take_damage(amount):
	is_hurt = true
	health -= amount
	if health <= 0: 
		death()
	else: 
		return health

func death():
	is_alive = false
	velocity = Vector2.ZERO #stays where the object is
	collider.disabled = true # collider off, can't detect projectiles
	anim.play("death")
	await anim.animation_finished
	enemy_loot()
	Game.player_exp += 1000
	Utils.saveGame()
	queue_free()

func enemy_loot():
	var gold_temp = GOLD.instantiate()
	gold_temp.position = $".".position
	$"../../Collectibles".add_child(gold_temp)
