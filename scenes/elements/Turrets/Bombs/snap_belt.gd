extends Node3D

var camera_3d : XRCamera3D
var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var xr_origin : XROrigin3D = get_parent().get_parent()
	camera_3d = xr_origin.find_child('XRCamera3D')
	if not camera_3d:
		push_error("Unable to find XRCamera3D in origin")
		return
	var position_y_diference : float = camera_3d.global_position.y - xr_origin.global_position.y
	position.y += position_y_diference/2
	if not UserSettings.is_righ_main_hand():
		$SnapZone.position.x *= -1
		$SnapZone2.position.x *= -1
	
func _process(_delta: float) -> void:
	if tween and tween.is_running():
		return
	var difference : float = abs(rotation.y - camera_3d.rotation.y)
	if difference >= .3:
		tween = create_tween()
		tween.tween_property(self,"rotation:y", camera_3d.rotation.y, .2)
