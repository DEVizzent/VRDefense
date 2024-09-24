extends PanelContainer

func _on_bow_turret_button_pressed() -> void:
	EventBus.send_turret_type_selected(AbstractTurret.Type.BOW)

func _on_bomb_turret_button_pressed() -> void:
	EventBus.send_turret_type_selected(AbstractTurret.Type.BOMB)
