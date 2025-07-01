extends CharacterBody2D

@onready var time_shot :Timer = $Timer_shot

var canshot : bool = false

const SPEED :float = 300.0
const BULLET_SCENE :PackedScene = preload("res://attack/bullet_player/bullet_player.tscn")
const ACCELERATION :float = 20.0  # 加速度
const FRICTION :float = 0.12  # 摩擦

func _ready():
	add_to_group("player")

#playerの座標管理
func _physics_process(delta):
	_move_process(delta)
	_attack_input()

func _move_process(delta):
	var input_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		input_velocity.x += 1
	
	#playerを実際に動かす処理
	if input_velocity != Vector2.ZERO:
		# 滑らかに加速
		velocity = velocity.lerp(input_velocity.normalized() * SPEED, ACCELERATION * delta)
	else:
		# 滑らかに減速・停止
		velocity = velocity.lerp(Vector2.ZERO, FRICTION)
	
	move_and_slide()

func _attack_input():
	if  Input.is_action_just_pressed("shot"):
		if canshot == false:
			bullet()
	
	#0.5秒おきに弾が出る処理
	if Input.is_action_pressed("shot"):
		if time_shot.is_stopped():
			time_shot.start()
			canshot = true
	else:
		time_shot.stop()

func _on_timer_shot_timeout():
	if Input.is_action_pressed("shot"):
		canshot = false
		bullet()

#弾の処理
func bullet():
	var bullet_2 = BULLET_SCENE.instantiate()
	bullet_2.global_position = global_position + Vector2(0, -20)
	get_tree().current_scene.add_child(bullet_2)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet_enemy_onshot") or area.is_in_group("bullet_enemy"):
		damege()
		area.queue_free()


func damege():
	const  HP_DAMEAG: Array[float] = [1,2,3,4,5,6,7,8,9,10] # 受けるダメージ
	var hp_damege :int = HP_DAMEAG.pick_random()
	global.player_hp -= hp_damege
	
