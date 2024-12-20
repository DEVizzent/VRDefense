extends Node
class_name GameInfoScript

const INITIAL_GEARS_AMOUNT = 90

var gears_amount :int:
	set(new_amount):
		gears_amount = new_amount
		EventBus.send_gears_updated(new_amount)
		if new_amount < 0:
			push_error("gears can't be less than 0")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gears_amount = INITIAL_GEARS_AMOUNT
	EventBus.enemy_defeated.connect(add_enemy_gears)
	EventBus.turret_built.connect(sub_enemy_gears)
	EventBus.turret_upgrated.connect(_on_turret_upgrated)

func add_enemy_gears(enemy: Enemy) -> void:
	gears_amount += enemy.reward_gears

func sub_enemy_gears(cost: int, _position: Vector3) -> void:
	gears_amount -= cost
func _on_turret_upgrated(upgrated_stats: TurretStatsResource) -> void:
	gears_amount -= upgrated_stats.cost
