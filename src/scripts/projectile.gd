extends CharacterBody2D
@onready var spawnTimer = $SpawnTimer
@onready var projectileSprite = $AnimatedSprite2D
const SPEED = 1000
var damage = Game.playerDamage
func _ready():
	spawnTimer.start(3)
func _physics_process(delta):
	var collisionInfo = move_and_collide(velocity.normalized() * delta * SPEED)
	if collisionInfo:
		var collider = collisionInfo.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)
		queue_free()
func _process(_delta):
	projectileSprite.play("Move")
func _on_spawn_timer_timeout():
	self.queue_free()
