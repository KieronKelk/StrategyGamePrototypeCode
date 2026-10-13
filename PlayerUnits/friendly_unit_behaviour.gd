extends CharacterBody3D

var is_clicked: bool
@export var root_node: Node
@export var is_clicked_sprite: Sprite3D

# connecting up signals and setting sprite color to not selected
func _ready() -> void:
	SignalManager.friendly_unit_clicked.connect(_unit_clicked_on)
	SignalManager.de_select_all_units.connect(_de_select_units)
	SignalManager.level_over.connect(_level_over)
	GameManager.number_of_friendly_units += 1
	is_clicked_sprite.modulate = Color(1,1,1,0.5)

# changes sprite color and is_clicked is to the opposite values of the current selected one, if the node clicked on is this one
func _unit_clicked_on(node_clicked_on):
	if node_clicked_on == self:
		if is_clicked == false:
			is_clicked = true
			is_clicked_sprite.modulate = Color(1,1,1,1)
		else:
			is_clicked = false
			is_clicked_sprite.modulate = Color(1,1,1,0.5)

#mouse hovers over node
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# if left mouse button is pressed, unit is clicked on
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalManager.friendly_unit_clicked.emit(root_node)
		pass

# changes variables to not selected state
func _de_select_units():
	is_clicked = false
	is_clicked_sprite.modulate = Color(1,1,1,0.5)

# delete unit at end of level (prevents bug of unit not destroying despite scene change)
func _level_over():
	queue_free()
