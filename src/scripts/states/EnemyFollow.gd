extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var anim: AnimationPlayer
@export var move_speed := 150.0
 
var player: CharacterBody2D
var in_range = false

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	if in_range:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()

	if not in_range:
		Transitioned.emit(self, "idle")

func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
