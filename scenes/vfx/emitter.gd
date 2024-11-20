extends Node3D
class_name Emitter

@export var particles : Array[GPUParticles3D]

func emit() -> void:
	for particle in particles:
		particle.emitting = true
