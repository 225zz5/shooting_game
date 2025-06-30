extends Node2D

@onready var normal: Sprite2D = $BackgroundNormal
@onready var heaven: Sprite2D = $Tenngoku
@onready var hell: Sprite2D = $Jigoku
const MIN_HP = 0
var result_shown: bool = false

func hide_all():
	heaven.visible = false
	hell.visible = false
	$win.visible = false
	$lose.visible = false

func _ready() -> void:
	hide_all()

func _process(delta: float) -> void:
	if not result_shown:
		if global.enemy_hp <= MIN_HP:
			normal.visible = false
			heaven.visible = true
			$win.visible = true
			result_shown = true
		elif global.player_hp <= MIN_HP:
			normal.visible = false
			hell.visible = true
			$lose.visible = true
			result_shown = true
