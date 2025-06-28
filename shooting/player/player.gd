extends CharacterBody2D

const SPEED :float = 300.0
const BULLET_SCENE :PackedScene = preload("res://bullet/bullet.tscn")
@onready var time_shot :Timer = $Timer_shot
@onready var time_onshot :Timer = $Timer_onshot

func _ready():
	add_to_group("player")



#playerの座標管理
func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		input_velocity.x += 1

	#playerを実際に動かす処理
	velocity = input_velocity * SPEED
	move_and_slide()

	#0.5秒おきに弾が出る処理
	if Input.is_action_pressed("shot"):
		if time_shot.is_stopped():
			time_shot.start()
	else:
		time_shot.stop()

func _on_timer_shot_timeout():
	if Input.is_action_pressed("shot"):
		bullet()
	
#弾の処理
func bullet():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = global_position + Vector2(0, -20)
	get_tree().current_scene.add_child(bullet)
