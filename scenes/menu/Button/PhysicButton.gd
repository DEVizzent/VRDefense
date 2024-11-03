@tool
class_name XRPhysicButton
extends Node3D

signal button_pressed(button:Variant)
signal button_released(button:Variant)

@export var size: Vector3 = Vector3(1.0,1.0,1.0)
@export var text: String = "Button"
@export var font_size: int = 45
@export var material_override : StandardMaterial3D

@onready var interactable_area_button: XRToolsInteractableAreaButton = $InteractableAreaButton
@onready var collision_shape_3d: CollisionShape3D = $InteractableAreaButton/CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var label_3d: Label3D = $Label3D
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape_3d.shape.size = size
	mesh_instance_3d.scale = size
	label_3d.text = text
	label_3d.position.z = (size.z / 2) + .005
	label_3d.font_size = font_size
	label_3d.outline_size = int(font_size/3)
	interactable_area_button.button_pressed.connect(_on_button_pressed)
	interactable_area_button.button_released.connect(_on_button_released)
	if not material_override:
		return
	set_material(material_override)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		collision_shape_3d.shape.size = size
		mesh_instance_3d.scale = size
		label_3d.text = text
		label_3d.position.z = (size.z / 2) + .005
		label_3d.font_size = font_size
		label_3d.outline_size = int(font_size/3)
		if not material_override:
			return
		set_material(material_override)
		
func set_material(material : StandardMaterial3D)-> void:
	mesh_instance_3d.set_surface_override_material(0, material)
		
func get_material()-> Material:
	return mesh_instance_3d.get_surface_override_material(0)
		
func _on_button_pressed(_button: Variant)->void:
	if !timer.is_stopped():
		return
	button_pressed.emit(self)
	timer.start()
func _on_button_released(_button: Variant)->void:
	button_released.emit(self)

func enable() -> void:
	interactable_area_button.monitoring = true

func disable() -> void:
	interactable_area_button.monitoring = false
