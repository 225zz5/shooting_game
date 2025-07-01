extends Node2D

@onready var timer_speed: Timer = $Timer_speed
@onready var timer_attack: Timer = $Timer_attack
@onready var timer_onshot: Timer = $Timer_onshot
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

#移動・向き変数
var speed: float = 200.0
var move_range: float = 480.0 #往復する距離
var start_position: float = 0.0
var direction: int = 1 #向きを決める

#攻撃変数
var attackmotion: int = 9
var hitmotion: bool = false
var prev_enemy_hp: int = 100

#定数
const hit_thresholds: Array[int] = [75, 50, 25]
const SPEED_LIST: Array[int] = [150,160,170,180,190,200,210,220,230,240,250] # 速度パターン
const ATTACK_LIST: Array[int] = [5,10,7] #攻撃間隔

#preload
const BULLET_HIGH: PackedScene = preload("res://attack/bullet_enemy/high/bullet_enemy_high.tscn")
const BULLET_LOW: PackedScene = preload("res://attack/bullet_enemy/low/bullet_enemy_low.tscn")

func _ready() -> void:
	add_to_group("enemy")
	sprite.flip_h = not sprite.flip_h
	sprite.play("run")
	start_position = position.x   #  初期位置を保存
	timer_speed.start()
	timer_attack.start()
	timer_onshot.start()

func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "attack" and sprite.frame == attackmotion:
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
	sprite.stop()
	speed = 0
	sprite.play("attack")
	timer_attack.stop()

func _on_animated_sprite_2d_animation_finished() -> void:
		#attackするときは止まるように　
	if sprite.animation == "attack":
		sprite.play("run")
		var random_speed: float = SPEED_LIST.pick_random()
		speed = random_speed
		var attack_list: float = ATTACK_LIST.pick_random()
		timer_attack.wait_time = attack_list
		timer_attack.start()
		#ヒットモーション終わったらの処理
	if sprite.animation == "hit":
		timer_attack.start()
		sprite.play("run")

func shoot():
	var bullet = BULLET_HIGH.instantiate()
	bullet.global_position = global_position + Vector2(0.0, 30.0)
	# 撃った瞬間のplayer座標を取得して方向計算
	var direction_2 = (player.global_position - bullet.global_position).normalized()
	bullet.direction = direction_2
	get_tree().current_scene.add_child(bullet)

func _on_timer_onshot_timeout() -> void:
	onshot()

func onshot():
	timer_onshot.start()
	var bullet2 = BULLET_LOW.instantiate()
	bullet2.global_position = global_position + Vector2(0.0, 30.0)
	# 撃った瞬間のplayer座標を取得して方向計算
	var direction_2 = (player.global_position - bullet2.global_position).normalized()
	bullet2.direction = direction_2
	get_tree().current_scene.add_child(bullet2)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet_player"):
		damage()
		area.get_parent().queue_free() 

func damage():
	const HP_DAMAGE: Array[float] = [1,2,3,4,5,6,7,8,9,10]
	var hp_damage : int = HP_DAMAGE.pick_random()
	global.enemy_hp -= hp_damage
	
	for threshold in hit_thresholds:
		if prev_enemy_hp > threshold and global.enemy_hp <= threshold:
			sprite.play("hit")
			timer_attack.stop()
	
	prev_enemy_hp = global.enemy_hp
