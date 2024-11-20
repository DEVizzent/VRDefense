extends Node
class_name CommandBusScript

## Turret managetment
signal build_turret(turret_position: Vector3)
signal upgrade_turret()
signal control_turret(turret_position: Vector3)
signal exit_turret()
## Level Flow
signal start_spawner()
## Information
signal show_bracelet_info(info_resource: Resource)
signal hide_bracelet_info()

func command_build_turret(turret_position: Vector3) -> void:
	build_turret.emit(turret_position)

func command_upgrade_turret() -> void:
	upgrade_turret.emit()

func command_control_turret(turret_position: Vector3) -> void:
	control_turret.emit(turret_position)

func command_exit_turret() -> void:
	exit_turret.emit()

func command_start_spawner() -> void:
	start_spawner.emit()
	
func command_show_bracelet_info(info_resource: Resource) -> void:
	show_bracelet_info.emit(info_resource)
	
func command_hide_bracelet_info() -> void:
	hide_bracelet_info.emit()
