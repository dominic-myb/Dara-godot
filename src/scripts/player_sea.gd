extends CharacterBody2D

const SPEED = 600.0
const PROJECTILE_PATH = preload("res://src/scenes/projectile.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var move_joystick = $"../../CanvasLayer/HBoxContainer/joystick"
@onready var attack_joystick = $"../../CanvasLayer/HBoxContainer2/attack"
@onready var inner_attack_joystick = $"../../CanvasLayer/HBoxContainer2/attack/inner"
@onready var player_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var player_aim = $Aim
@onready var collider = $CollisionShape2D
var can_attack = true
var is_alive = true
var is_hurt = false
var attack_cooldown = 0.0
var attack_timer = 0.0
func _ready():
	animation_player.play("Idle")
func _physics_process(delta):
	player_movement(delta)
	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true
			attack_timer = 0.0
	
	var attack_direction = attack_joystick.vector_pos
	if inner_attack_joystick.pressing: 
		player_attack(delta, attack_direction)
	move_and_slide()
func _process(_delta):
	if velocity.x > 0: 
		player_sprite.flip_h = false
	elif velocity.x < 0: 
		player_sprite.flip_h = true
		collider.scale.x = -collider.scale.x
	if is_hurt:
		animation_player.play("Hurt")
		await animation_player.animation_finished
		is_hurt = false
	if inner_attack_joystick.pressing and can_attack:
		animation_player.play("Attack")
	else:
		var direction = move_joystick.vector_pos
		animation_player.play("Move" if direction else "Idle")
func player_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5
	var direction = move_joystick.vector_pos.normalized()
	if direction: velocity = direction * SPEED * 0.5
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(0, velocity.y, 10)
func player_attack(_delta, direction):
	player_aim.rotation = atan2(direction.y, direction.x)
	if direction.x > 0: player_sprite.flip_h = false
	elif direction.x < 0: player_sprite.flip_h = true
	if can_attack:
		var projectile = PROJECTILE_PATH.instantiate()
		get_parent().add_child(projectile)
		projectile.velocity = direction # * speed
		projectile.global_position = $Aim/Marker2D.global_position
		can_attack = false
func take_damage(damage):
	is_hurt = true
	Game.player_hp -= damage
	if Game.player_hp <= 0: death()
	else: 
		return Game.player_hp
func death():
	is_alive = false
	velocity = Vector2.ZERO
	#death anim
	queue_free()
#func _input(event):
	#if event.is_action_pressed("shoot"):
		#shoot(attack_direction)
