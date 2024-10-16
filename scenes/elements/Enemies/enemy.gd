extends PathFollow3D
class_name Enemy

@export var speed:int = 2
@export var max_health:int = 100
@export var meshes: Array[MeshInstance3D]
var reward_gears : int = 5
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var material: StandardMaterial3D
var impact_material: StandardMaterial3D = load("res://scenes/elements/enemies/goblin/goblin_material_unshaded.tres")

var health:int:
	set(value):
		health = clamp(value, 0, max_health)
		if health == 0:
			animation_player.play("die")
			EventBus.send_enemy_defeated(self)
			return
		animation_player.play("impact")
@onready var base : Node3D = get_tree().get_first_node_in_group("base")

func _ready() -> void:
	health = max_health
	material = meshes[0].get_surface_override_material(0)
	animation_player.animation_finished.connect(_animate_sprint)
	_animate_sprint("")

func init(stats: EnemyStats) -> void:
	max_health = stats.health
	speed = stats.speed
	_set_colormap_from_stats(stats)

func _set_colormap_from_stats(stats: EnemyStats) -> void:
	if not stats.material:
		return
	for mesh in meshes:
		mesh.set_surface_override_material(0, stats.material)

func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1.0:
		base.take_damage()
		queue_free()

func take_damage(damage: int) -> void:
	health -= damage

func _animate_sprint(_anim_name: StringName) -> void:
	animation_player.play("sprint")

func show_impact_material() -> void:
	for mesh in meshes:
		mesh.set_surface_override_material(0, impact_material)

func show_regular_material() -> void:
	for mesh in meshes:
		mesh.set_surface_override_material(0, material)
