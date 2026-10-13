extends CharacterBody3D

@export var root_node: Node
@export var is_clicked_sprite: Sprite3D
var is_unit_clicked
@export var base_click_show_time: float
var click_show_time: float

# sets the sprite color to not being selected and connects the signal up
func _ready() -> void:
	is_clicked_sprite.modulate = Color(1,1,1,0.5)
	SignalManager.level_over.connect(_level_over)

#mouse hovers over node
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# if mouse button right is pressed, the enemy unit is selected to be attacked
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		SignalManager.enemy_unit_right_clicked.emit(root_node)
		click_show_time = base_click_show_time
		is_unit_clicked = true
		is_clicked_sprite.modulate = Color(1,1,1,1)
		pass

func _process(delta: float) -> void:
	# delay before, sprite color is returned to not being selected state
	if is_unit_clicked == true:
		click_show_time -= delta
		if click_show_time <= 0:
			is_unit_clicked = false
			is_clicked_sprite.modulate = Color(1,1,1,0.5)

# on level over, deletes unit 
func _level_over():
	queue_free()
