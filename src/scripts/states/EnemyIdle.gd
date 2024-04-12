extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var anim: AnimationPlayer
@export var move_speed := 100.0
var in_range = false
var move_direction: Vector2
var wander_time: float
var player: CharacterBody2D

func patrol():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	anim.play("idle")
	patrol()
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		patrol()

func Physics_Update(_delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
	if in_range:
		var direction = player.global_position - enemy.global_position
		Transitioned.emit(self, "follow")


func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true


func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
