extends RigidBody3D

@export var root_node: Node

#mouse hovers over node
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	# selects friendly unit on left mouse button pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalManager.friendly_unit_clicked.emit(root_node)
		pass
