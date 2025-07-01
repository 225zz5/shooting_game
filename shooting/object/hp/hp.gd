extends Control

@onready var player_hp_label: Label = $player_hp_label
@onready var player_hp_bar: TextureProgressBar = $player_hp_bar
@onready var enemy_hp_label: Label = $enemy_hp_label
@onready var enemy_hp_bar: TextureProgressBar = $enemy_hp_bar

const MIN_HP: int = 0

func _ready() -> void:
	player_hp_bar.max_value = 100
	enemy_hp_bar.max_value = 100
	_update_bars()

func _physics_process(_delta: float) -> void:
	_update_bars()

func _update_bars() -> void:
	player_hp_label.text = str(max(global.player_hp, MIN_HP)) + "/103r3232r3r20"
	player_hp_bar.value = max(global.player_hp, MIN_HP)
	enemy_hp_label.text = str(max(global.enemy_hp, MIN_HP)) 
	enemy_hp_bar.value = max(global.enemy_hp, MIN_HP)
