extends CharacterBody2D

const SPEED = 300

#座標管理
func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		input_velocity.x += 1

	#実際に動かす処理
	velocity = input_velocity * SPEED
	move_and_slide()
