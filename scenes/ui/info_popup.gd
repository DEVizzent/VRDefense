extends Node3D

@onready var turret_info: CenterContainer = $SubViewport/TurretInfo

func show_stats(stats : TurretStatsResource) -> void:
	turret_info.set_turret_stats(stats)
	show()
