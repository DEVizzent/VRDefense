extends PanelContainer

var turret_bow_info : TurretStatsResource = load("res://scenes/elements/Turrets/Bow/stats/bow1.tres")
var turret_bomb_info : TurretStatsResource = load("res://scenes/elements/Turrets/Bombs/stats/bomb1.tres")

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

func _on_bow_turret_button_mouse_entered() -> void:
	CommandBus.command_show_bracelet_info(turret_bow_info)


func _on_bomb_turret_button_mouse_entered() -> void:
	CommandBus.command_show_bracelet_info(turret_bomb_info)


func _on_mouse_exited() -> void:
	CommandBus.command_hide_bracelet_info()
