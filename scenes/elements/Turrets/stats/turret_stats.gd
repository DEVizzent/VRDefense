extends Resource
class_name TurretStatsResource

var turret_name: String = 'ExampleTurret'
@export var turret_level: int
@export var cost: int
@export var shot_coldown: float
@export var shot_damage: int
@export var shot_range: float

func getName() -> String:
	return turret_name + ' ' + tr('lvl') + str(turret_level)

func getDescription() -> String:
	var description = tr('Cost: ') + str(cost) + '\n'
	description += tr('Shots per second: ') + str(1/shot_coldown) + '\n'
	description += tr('Damage per shot: ') + str(shot_damage) + '\n'
	description += tr('Range: ') + str(shot_range)
	
	return description
