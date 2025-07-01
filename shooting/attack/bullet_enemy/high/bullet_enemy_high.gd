extends Area2D

const SPEED: float = 400.0
var direction: Vector2

func _process(delta):
	position += direction * SPEED * delta

func _ready():
	$Timer.start()
	add_to_group("bullet_enemy")

func _on_timer_timeout() -> void:
	queue_free()
