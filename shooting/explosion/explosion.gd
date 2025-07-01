extends Node

@onready var player: CharacterBody2D = $"../player"
@onready var enemy: Node2D = $"../enemy"
@onready var explosion_enemy: Sprite2D = $explosion_enemy
@onready var explosion_player: Sprite2D = $explosion_player

var judgment: bool = false
var explosion_target: Node2D = null # 追尾対象
var is_exploding: bool = false

const MIN_EXPLOSION: Vector2 = Vector2(0, 0)
const MIN_HP: int = 0

func _ready() -> void:
	_reset_character(explosion_enemy)
	_reset_character(explosion_player)

func _reset_character(exp_name):
	exp_name.scale = MIN_EXPLOSION
	exp_name.visible = false
	exp_name.process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	# 爆発中の追尾処理
	if is_exploding and explosion_target != null:
		if explosion_enemy.visible:
			explosion_enemy.global_position = explosion_target.global_position
		elif explosion_player.visible:
			explosion_player.global_position = explosion_target.global_position

	# 敵が死んだ場合
	if global.enemy_hp <= MIN_HP and not judgment:
		_dead_character(explosion_enemy, enemy)

	# プレイヤーが死んだ場合
	if global.player_hp <= MIN_HP and not judgment:
		_dead_character(explosion_player, player)

func _dead_character(exp_name, chara_name):
		explosion_target = chara_name	# 追尾対象設定
		is_exploding = true
		exp_name.global_position = chara_name.global_position
		exp_name.visible = true
		var tween = create_tween()
		tween.tween_property(exp_name, "scale", Vector2.ONE, 1.0)
		tween.connect("finished", Callable(self, "_on_explosion_finished"))
		judgment = true

func _on_explosion_finished():
	is_exploding = false	# 追尾停止
	get_tree().paused = true
