extends GridMap
class_name XRPointableGridMap

enum CellItem {
	INVALID = INVALID_CELL_ITEM,
	EMPTY = 0,
	PATH = 1,
	BUILT = 2,
	HOVER = 3
}

var hover_position: Vector3
var last_hover_position: Vector3
var hover_previous_index: int
var pressed_position: Vector3
var pressed_cell_index: int
var ignore_next_exited:bool = false
var ignore_next_entered:bool = false

func _ready() -> void:
	EventBus.turret_built.connect(_on_turret_built)

func pointer_event(event : XRToolsPointerEvent) -> void:
	match event.event_type:
		XRToolsPointerEvent.Type.ENTERED:
			if ignore_next_entered:
				ignore_next_entered = false
				return
			_on_entered(event)
		XRToolsPointerEvent.Type.EXITED:
			if ignore_next_exited:
				ignore_next_exited = false
				return
			_on_exited(event)
		XRToolsPointerEvent.Type.PRESSED:
			_on_pressed(event)
		XRToolsPointerEvent.Type.RELEASED:
			_on_released(event)
		XRToolsPointerEvent.Type.MOVED:
			_on_moved(event)

func _on_entered(event: XRToolsPointerEvent) -> void:
	hover_position = local_to_map(event.position)
	_hover_cell()

func _on_exited(_event: XRToolsPointerEvent) -> void:
	last_hover_position = hover_position
	_unhover_cell(true)

func _on_pressed(_event: XRToolsPointerEvent) -> void:
	match hover_previous_index:
		CellItem.EMPTY:
			CommandBus.command_build_turret(map_to_local(hover_position))
		CellItem.BUILT:
			CommandBus.command_control_turret(map_to_local(hover_position))

func _on_released(_event: XRToolsPointerEvent) -> void:
	pass

func _on_moved(event: XRToolsPointerEvent) -> void:
	last_hover_position = hover_position
	hover_position = local_to_map(event.position)
	if get_cell_item(hover_position) == CellItem.INVALID:
		return
	_unhover_cell(false)
	_hover_cell()
	
func _hover_cell() -> void:
	var index:int = get_cell_item(hover_position)
	if index == 3 or index == CellItem.INVALID:
		return
	hover_previous_index = get_cell_item(hover_position)
	set_cell_item(hover_position, CellItem.HOVER)
	ignore_next_entered = true
	ignore_next_exited = true
	
func _unhover_cell(force:bool) -> void:
	if get_cell_item(last_hover_position) == CellItem.INVALID:
		return
	if last_hover_position == hover_position and !force:
		return
	set_cell_item(last_hover_position, hover_previous_index)
	
func _on_turret_built(_cost:int, turret_position: Vector3) -> void:
	set_cell_item(local_to_map(turret_position), CellItem.BUILT)
