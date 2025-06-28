extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var speed: float = 250.0
var move_range: float = 500.0 #往復する距離
var start_position: float = 0.0
var direction: int = 1 #向きを決める
const  SPEED_LIST: Array[float] = [-10,-20,-30,-40,-50,60,70,80,90,100,]	# 速度パターン


func _ready() -> void:
	sprite.flip_h = not sprite.flip_h
	sprite.play("run")
	start_position = position.x   #  初期位置を保存
	$Timer.start()
func _process(delta: float) -> void:
	# 移動処理
	position.x += speed * direction * delta
	# 範囲外なら方向反転
	if abs(position.x - start_position) > move_range:
		direction *= -1
		sprite.flip_h = not sprite.flip_h
		
#時間によってスピードを変える
func _on_timer_timeout() -> void:
	var random_speed: float = SPEED_LIST.pick_random()
	random_speed = SPEED_LIST.pick_random() 
	speed += random_speed
