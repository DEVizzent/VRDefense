extends Node
class_name CommandBusScript

signal build_turret(turret_position: Vector3);
signal control_turret(turret_position: Vector3);
signal exit_turret();

func command_build_turret(turret_position: Vector3) -> void:
	build_turret.emit(turret_position)

func command_control_turret(turret_position: Vector3) -> void:
	control_turret.emit(turret_position)

func command_exit_turret() -> void:
	exit_turret.emit()
