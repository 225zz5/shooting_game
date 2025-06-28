extends Node2D

@onready var timer_speed: Timer = $Timer_speed
@onready var timer_attack: Timer = $Timer_attack
@onready var time_onshot :Timer = $Timer_onshot
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var speed: float = 200.0
var move_range: float = 480.0 #往復する距離
var start_position: float = 0.0
var direction: int = 1 #向きを決める
var attackmotion: int = 9
const  SPEED_LIST: Array[float] = [150,160,170,180,190,200,210,220,230,240,250] # 速度パターン
const  ATTACK_LIST: Array[float] = [5,10,7] #攻撃間隔
const BULLET_SCENE :PackedScene = preload("res://bullet_enemy/bullet_enemy.tscn")
const BULLET_SCENE2 :PackedScene = preload("res://bullet/bullet_enemy_onshot.tscn")

func _ready() -> void:
	sprite.flip_h = not sprite.flip_h
	$AnimatedSprite2D.play("run")
	start_position = position.x   #  初期位置を保存
	$Timer_speed.start()
	$Timer_attack.start()
	$Timer_onshot.start()

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == attackmotion:
		shoot()
	


func _process(delta: float) -> void:
	
	# 移動処理
	position.x += speed * direction * delta
	# 範囲外なら方向反転
	if abs(position.x - start_position) > move_range:
		direction *= -1
		sprite.flip_h = not sprite.flip_h
		
#時間がたつとスピードを変える
func _on_timer_speed_timeout() -> void:
	var random_speed: float = SPEED_LIST.pick_random()
	speed = random_speed


func _on_timer_attack_timeout() -> void:
	$AnimatedSprite2D.stop()
	speed = 0
	$AnimatedSprite2D.play("attack")
	$Timer_attack.stop()


	
func _on_animated_sprite_2d_animation_finished() -> void:
	print("アニメ終わり")
	if $AnimatedSprite2D.animation == "attack":
		print("attack終わり")
		$AnimatedSprite2D.play("run")
		var random_speed: float = SPEED_LIST.pick_random()
		speed = random_speed
		var attack_list: float = ATTACK_LIST.pick_random()
		$Timer_attack.wait_time = attack_list
		$Timer_attack.start()


func shoot():
	print("弾")
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = global_position + Vector2(0, 30)
	# 撃った瞬間のplayer座標を取得して方向計算
	var direction = (player.global_position - bullet.global_position).normalized()
	bullet.direction = direction
	get_tree().current_scene.add_child(bullet)

func _on_timer_onshot_timeout() -> void:
	onshot()

func onshot():
	$Timer_onshot.start()
	var bullet2 = BULLET_SCENE2.instantiate()
	bullet2.global_position = global_position + Vector2(0, 30)
	# 撃った瞬間のplayer座標を取得して方向計算
	var direction = (player.global_position - bullet2.global_position).normalized()
	bullet2.direction = direction
	get_tree().current_scene.add_child(bullet2)
