extends Node3D

signal explosion_finished()

@onready var timer : Timer = $Timer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var on_fire_particle : CPUParticles3D = $CPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(explosion)
	animation_player.animation_finished.connect(check_explosion_finished)

func set_fire() -> void:
	if not timer.is_stopped():
		return
	on_fire_particle.emitting = true
	timer.start()

func explosion() -> void:
	if not timer.is_stopped():
		timer.stop()
	animation_player.play("explosion")
	on_fire_particle.emitting = false

func make_visible(_pickable: XRToolsPickable) -> void:
	reset_bomb()
	on_fire_particle.emitting = false

func reset_bomb() -> void:
	animation_player.play("RESET")

func check_explosion_finished(animation_name: StringName) -> void:
	if animation_name == "explosion":
		explosion_finished.emit()
		on_fire_particle.emitting = false
