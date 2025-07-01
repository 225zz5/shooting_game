extends CharacterBody2D

const SPEED :int = 400
const rotation_bullt :int = 5

func _physics_process(_delta):
	rotation += deg_to_rad(rotation_bullt)
	velocity = Vector2(0, -SPEED)	# 上に進むように
	move_and_slide()

func _ready():
	$Timer.start()
	add_to_group("bullet_player")
	$Area2D.add_to_group("bullet_player")

func _on_timer_timeout() -> void:
	queue_free()
