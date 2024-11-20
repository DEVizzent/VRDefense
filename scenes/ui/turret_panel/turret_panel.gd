extends PanelContainer

var turret_bow_info : TurretProgressionResource = load("res://scenes/elements/Turrets/Bow/stats/bow_progression.tres")
var turret_bomb_info : TurretProgressionResource = load("res://scenes/elements/Turrets/Bombs/stats/bomb_progression.tres")

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
	CommandBus.command_show_bracelet_info(turret_bow_info.stats_progression[0])


func _on_bomb_turret_button_mouse_entered() -> void:
	CommandBus.command_show_bracelet_info(turret_bomb_info.stats_progression[0])


func _on_mouse_exited() -> void:
	CommandBus.command_hide_bracelet_info()
