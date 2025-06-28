extends Area2D

const SPEED: int = 300.0
var direction: Vector2

func _process(delta):
	position += direction * SPEED * delta

func _ready():
	$Timer.start()
	add_to_group("bullet_enemy_onshot")
func _on_timer_timeout() -> void:
	queue_free()
