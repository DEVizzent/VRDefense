extends TurretStatsResource
class_name TurretBombStatsResource

@export var shot_area: float
func _init():
	turret_name = tr('Bomber Turret')

func getDescription() -> String:
	var description = super.getDescription()
	description += '\n' + tr('Area: ') + str(shot_area)
	
	return description
