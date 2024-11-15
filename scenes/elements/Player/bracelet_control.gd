extends Node3D

@onready var info_popup: Node3D = $InfoPopup

func _ready() -> void:
	CommandBus.show_bracelet_info.connect(show_info_popup)
	CommandBus.hide_bracelet_info.connect(hide_info_popup)

func show_info_popup(_info_resource : Resource) -> void:
	info_popup.show_stats(_info_resource)
	
func hide_info_popup() -> void:
	info_popup.hide()
