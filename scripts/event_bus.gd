extends Node
class_name EventBusScript

signal enemy_defeated(enemy: Enemy)

signal gears_updated(amount: int)

signal turret_type_selected(turret_type: AbstractTurret.Type)

signal turret_built(cost: int, turret_position: Vector3)#Next step should be send the turret information

func send_enemy_defeated(enemy: Enemy) -> void:
	enemy_defeated.emit(enemy)

func send_gears_updated(amount: int) -> void:
	gears_updated.emit(amount)

func send_turret_built(cost: int, turret_position: Vector3) -> void:
	turret_built.emit(cost, turret_position)

func send_turret_type_selected(turret_type: AbstractTurret.Type) -> void:
	turret_type_selected.emit(turret_type)
	print_debug("Turret type selected: ", turret_type)