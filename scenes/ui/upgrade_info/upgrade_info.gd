extends CenterContainer

var turret_stats : TurretStatsResource
var turret_next_stats : TurretStatsResource


func update_content() -> void:
	if not turret_stats:
		return
	if turret_next_stats:
		$VBoxContainer/Title.text = turret_stats.getComparedName(turret_next_stats)
		$VBoxContainer/Description.text = turret_stats.getComparedDescription(turret_next_stats)
		return
	$VBoxContainer/Title.text = turret_stats.getName()
	$VBoxContainer/Description.text = turret_stats.getDescription()
	
func set_turret_stats(stats : TurretStatsResource)-> void:
	turret_stats = stats
	update_content()
func set_turret_next_stats(stats : TurretStatsResource)-> void:
	turret_next_stats = stats
	update_content()
