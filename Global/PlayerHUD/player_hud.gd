extends CanvasLayer

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HPBar


func _ready() -> void:
	MessageBus.player_health_changed.connect(update_healthbar)
	

func update_healthbar(hp: float, max_hp: float) -> void:
	var value : float = (hp / max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = 22 + max_hp
