extends PanelContainer

func _ready() -> void:
	EventBus.turret_type_unblocked.connect(unblock_turret_type)

func _on_bow_turret_button_pressed() -> void:
	EventBus.send_turret_type_selected(AbstractTurret.Type.BOW)

func _on_bomb_turret_button_pressed() -> void:
	EventBus.send_turret_type_selected(AbstractTurret.Type.BOMB)

func unblock_turret_type(turret_type : AbstractTurret.Type) -> void:
	match turret_type:
		0:
			$MarginContainer/GridContainer/BowTurretButton.disabled = false
		1:
			$MarginContainer/GridContainer/BombTurretButton.disabled = false
