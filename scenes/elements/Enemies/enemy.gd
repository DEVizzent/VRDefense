extends PathFollow3D
class_name Enemy

@export var speed:int = 2
@export var max_health:int = 100
var reward_gears : int = 5
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var health:int:
	set(value):
		health = clamp(value, 0, max_health)
		if health == 0:
			animation_player.play("death")
			EventBus.send_enemy_defeated(self)
			return
		animation_player.play("impact")
@onready var base : Node3D = get_tree().get_first_node_in_group("base")

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1.0:
		base.take_damage()
		queue_free()

func take_damage(damage: int) -> void:
	health -= damage
