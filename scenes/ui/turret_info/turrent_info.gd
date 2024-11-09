extends CenterContainer

@export var turret_stats : TurretStatsResource = load("res://scenes/elements/Turrets/stats/example_turret.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Title.text = turret_stats.getName()
	$VBoxContainer/Description.text = turret_stats.getDescription()
