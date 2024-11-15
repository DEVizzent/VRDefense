extends CenterContainer

var turret_stats : TurretStatsResource


func update_content() -> void:
	$VBoxContainer/Title.text = turret_stats.getName()
	$VBoxContainer/Description.text = turret_stats.getDescription()
	
func set_turret_stats(stats : TurretStatsResource)-> void:
	turret_stats = stats
	update_content()
