extends CharacterBody2D

const SPEED = 400

func _physics_process(delta):
	velocity = Vector2(0, -SPEED)	# 上に進むように
	move_and_slide()
	
func _ready():
	$Timer.start()
	
func _on_timer_timeout() -> void:
	queue_free()
