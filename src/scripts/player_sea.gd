extends CharacterBody2D

const SPEED = 600.0
const PROJECTILE_PATH = preload("res://src/scenes/projectile.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var moveJoystick = $"../../CanvasLayer/HBoxContainer/joystick"
@onready var attackJoystick = $"../../CanvasLayer/HBoxContainer2/attack"
@onready var innerAttackJoystick = $"../../CanvasLayer/HBoxContainer2/attack/inner"
@onready var playerSprite = $AnimatedSprite2D
@onready var playerAnim = $AnimationPlayer
@onready var playerAim = $Aim
var canAttack = true
var attackCooldown = 0.5
var attackTimer = 0.0
var attackDirection
func _ready():
	playerAnim.play("Idle")
func _physics_process(delta):
	attackDirection = attackJoystick.vector_pos
	playerAim.rotation = atan2(attackDirection.y, attackDirection.x)
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5
	var direction = moveJoystick.vector_pos.normalized()
	if direction: velocity = direction * SPEED * 0.5
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(0, velocity.y, 10)
	if innerAttackJoystick.pressing and canAttack: shoot(attackDirection)
	move_and_slide()
func _process(delta):
	if not canAttack:
		attackTimer += delta
		if attackTimer >= attackCooldown:
			canAttack = true
			attackTimer = 0.0
	if velocity.x > 0: playerSprite.flip_h = false
	elif velocity.x < 0: playerSprite.flip_h = true
	if innerAttackJoystick.pressing:
		if attackDirection.x > 0: playerSprite.flip_h = false
		elif attackDirection.x < 0: playerSprite.flip_h = true
		playerAnim.play("Attack")
	else:
		var direction = moveJoystick.vector_pos
		playerAnim.play("Move" if direction else "Idle")
		
func shoot(aim_direction):
	if canAttack:
		var projectile = PROJECTILE_PATH.instantiate()
		get_parent().add_child(projectile)
		projectile.position = $Aim/Marker2D.global_position
		projectile.velocity = aim_direction
		canAttack = false
#func _input(event):
	#if event.is_action_pressed("shoot"):
		#shoot(attackDirection)
