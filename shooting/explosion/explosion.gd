extends Node
@onready var player: CharacterBody2D = $"../player"
@onready var enemy: Node2D = $"../enemy"
@onready var explosion_enemy: Sprite2D = $explosion_enemy
@onready var explosion_player: Sprite2D = $explosion_player
const MIN_EXPLOSION: Vector2 = Vector2(0, 0)
const MIN_HP: int = 0
var judgment: bool = false



func _ready() -> void:
	explosion_enemy.scale = MIN_EXPLOSION
	explosion_player.scale = MIN_EXPLOSION
	explosion_enemy.visible = false
	explosion_player.visible = false
	#ほかのシーンを止めてもこのシーンだけは動くように
	explosion_enemy.process_mode = Node2D.PROCESS_MODE_ALWAYS
	explosion_player.process_mode = Node2D.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	# 敵が死んだ場合
	if global.enemy_hp <= MIN_HP and not judgment:
		explosion_enemy.global_position = enemy.global_position
		explosion_enemy.visible = true
		var tween = create_tween()
		tween.tween_property(explosion_enemy, "scale", Vector2.ONE, 1.0)
		tween.connect("finished", Callable(self, "_on_explosion_finished"))
		judgment = true

	# プレイヤーが死んだ場合
	if global.player_hp <= MIN_HP and not judgment:
		explosion_player.global_position = player.global_position
		explosion_player.visible = true
		var tween = create_tween()
		tween.tween_property(explosion_player, "scale", Vector2.ONE, 1.0)
		tween.connect("finished", Callable(self, "_on_explosion_finished"))
		judgment = true

func _on_explosion_finished():
	get_tree().paused = true
