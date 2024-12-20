extends Node3D
class_name Bomb

signal explosion_finished()

@onready var timer : Timer = $Timer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var on_fire_particle : CPUParticles3D = $CPUParticles3D
@onready var sound: AudioStreamPlayer3D = $Sound
var stats : TurretBombStatsResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(explosion)
	animation_player.animation_finished.connect(check_explosion_finished)

func set_stats(new_stats: TurretBombStatsResource) -> void:
	stats = new_stats

func set_fire() -> void:
	if not timer.is_stopped():
		return
	on_fire_particle.emitting = true
	sound.play()
	timer.start()

func is_on_fire() -> bool:
	return on_fire_particle.emitting

func explosion() -> void:
	if not timer.is_stopped():
		timer.stop()
	animation_player.play("explosion")
	sound["parameters/switch_to_clip"] = "Explosion"
	sound.play()
	on_fire_particle.emitting = false

func make_visible(_pickable: XRToolsPickable) -> void:
	reset_bomb()
	on_fire_particle.emitting = false

func reset_bomb() -> void:
	sound.stop()
	sound["parameters/switch_to_clip"] = "Sizzle"
	animation_player.play("RESET")

func check_explosion_finished(animation_name: StringName) -> void:
	if animation_name == "explosion":
		explosion_finished.emit()
		on_fire_particle.emitting = false
