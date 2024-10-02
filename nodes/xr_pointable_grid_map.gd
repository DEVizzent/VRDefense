extends GridMap
class_name XRPointableGridMap

enum CellItem {
	INVALID = INVALID_CELL_ITEM,
	EMPTY = 0,
	PATH = 1,
	BUILT = 2,
	HOVER_BUILT = 3,
	HOVER_EMPTY = 4,
	PATH_CORNER = 5,
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
		CellItem.EMPTY, CellItem.HOVER_EMPTY:
			CommandBus.command_build_turret(map_to_local(hover_position))
		CellItem.BUILT, CellItem.HOVER_BUILT:
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
	if not is_hoverable_cell(index):
		return
	hover_previous_index = get_cell_item(hover_position)
	set_cell_item(hover_position, CellItem.HOVER_EMPTY if index == CellItem.EMPTY else CellItem.HOVER_BUILT)
	ignore_next_entered = true
	ignore_next_exited = true
	
func _unhover_cell(force:bool) -> void:
	var index : int = get_cell_item(last_hover_position)
	if index == CellItem.INVALID or is_path_cell(index):
		return
	if last_hover_position == hover_position and !force:
		return
	set_cell_item(last_hover_position, hover_previous_index)
	
func _on_turret_built(_cost:int, turret_position: Vector3) -> void:
	set_cell_item(local_to_map(turret_position), CellItem.BUILT)
	
func is_hoverable_cell(index: int)-> bool:
	return (index == CellItem.EMPTY or index == CellItem.BUILT)
func is_path_cell(index: int) -> bool:
	return index == CellItem.PATH or index == CellItem.PATH_CORNER
