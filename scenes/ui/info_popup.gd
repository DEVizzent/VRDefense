extends Node3D
class_name InfoPopUp
@onready var turret_info: CenterContainer = $SubViewport/TurretInfo

func show_stats(stats : TurretStatsResource) -> void:
	turret_info.set_turret_stats(stats)
	turret_info.set_turret_next_stats(null)
	show()
	
func show_compared_stats(stats : TurretStatsResource, upgrade : TurretStatsResource) -> void:
	if stats.turret_level == upgrade.turret_level:
		show_stats(stats)
		return
	turret_info.set_turret_next_stats(upgrade)
	turret_info.set_turret_stats(stats)
	show()
