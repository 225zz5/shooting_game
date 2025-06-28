extends CharacterBody2D

const SPEED :int = 400
const rotation_bullt :int = 5
func _physics_process(delta):
	
	rotation += deg_to_rad(rotation_bullt)
	velocity = Vector2(0, -SPEED)	# 上に進むように
	move_and_slide()
	
func _ready():
	$Timer.start()
	
func _on_timer_timeout() -> void:
	queue_free()
