extends Node3D


@onready var timer : Timer = $Timer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var on_fire_particle : CPUParticles3D = $CPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(explosion)

func set_fire() -> void:
	if !timer.is_stopped():
		return
	on_fire_particle.emitting = true
	timer.start()

func explosion() -> void:
	animation_player.play("explosion")
	on_fire_particle.emitting = false

func make_visible(_pickable: XRToolsPickable) -> void:
	animation_player.play("RESET")
	on_fire_particle.emitting = false
