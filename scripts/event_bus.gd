extends Node
class_name EventBusScript

signal enemy_defeated(enemy: Enemy)

signal gears_updated(amount: int)

signal turret_type_selected(turret_type: AbstractTurret.Type)

signal turret_type_unblocked(turret_type: AbstractTurret.Type)

signal round_finished()

signal level_finished()

signal turret_built(cost: int, turret_position: Vector3)#Next step should be send the turret information
signal turret_upgrated(upgrated_stats:TurretStatsResource)

signal arrow_created()

signal arrow_thrown()

signal bomb_grabbed()

signal bomb_thrown()

func send_enemy_defeated(enemy: Enemy) -> void:
	enemy_defeated.emit(enemy)

func send_gears_updated(amount: int) -> void:
	gears_updated.emit(amount)

func send_turret_built(cost: int, turret_position: Vector3) -> void:
	turret_built.emit(cost, turret_position)

func send_turret_upgraded(upgrated_stats:TurretStatsResource) -> void:
	turret_upgrated.emit(upgrated_stats)

func send_turret_type_selected(turret_type: AbstractTurret.Type) -> void:
	turret_type_selected.emit(turret_type)

func send_turret_type_unblocked(turret_type: AbstractTurret.Type) -> void:
	turret_type_unblocked.emit(turret_type)

func send_round_finished() -> void:
	round_finished.emit()

func send_level_finished() -> void:
	level_finished.emit()
	
func send_arrow_created() -> void:
	arrow_created.emit()
	
func send_arrow_thrown() -> void:
	arrow_thrown.emit()
	
func send_bomb_grabbed() -> void:
	bomb_grabbed.emit()
	
func send_bomb_thrown() -> void:
	bomb_thrown.emit()
