extends PanelContainer

func _on_bow_turret_button_pressed() -> void:
	EventBus.send_turret_type_selected(AbstractTurret.Type.BOW)
	print_debug("Bow turret button pressed")

func _on_bomb_turret_button_pressed() -> void:
	EventBus.send_turret_type_selected(AbstractTurret.Type.BOMB)
	print_debug("Bomb turret button pressed")
