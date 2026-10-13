extends Node

func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	# emits map clicked signal (for unit movement) on right click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		SignalManager.map_clicked.emit(event_position)
	
	# emits unit spawn signal on left click
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalManager.unit_spawn_information.emit(event_position)
