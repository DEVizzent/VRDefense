extends Node3D

@onready var label_3d: Label3D = $Label3D
@export var max_health:int = 5
var health:int:
	set(health_in):
		health = health_in
		label_3d.text = str(health) + "/" + str(max_health)
		label_3d.modulate = Color.RED.lerp(Color.WHITE, (float(health) / float(max_health)))
		if health < 1:
			get_tree().reload_current_scene()

func _ready() -> void:
	health = max_health
	

func take_damage() -> void:
	health -= 1
