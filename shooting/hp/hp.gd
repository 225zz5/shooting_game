extends Control
@onready var player_hp :Label = $Label_hp
@onready var hp_bar: TextureProgressBar = $player_hp
const MIN_HP : int = 0

func _ready() -> void:
	player_hp.text = str(global.hp)
	hp_bar.max_value = 100
	
func _physics_process(delta: float) -> void:
	player_hp.text = str(max(global.hp, MIN_HP))
	hp_bar.value = global.hp
