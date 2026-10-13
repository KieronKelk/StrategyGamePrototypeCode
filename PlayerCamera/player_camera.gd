extends Camera3D

@export var move_speed: float
var camera_movement_input: Vector3
@export var camera_pivot: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# gets camera movement based on inputs
#region player_camera_movement
	if Input.is_action_pressed("move_right"):
		camera_movement_input.x = 1
	elif Input.is_action_pressed("move_left"):
		camera_movement_input.x = -1
	else:
		camera_movement_input.x = 0
	
	if Input.is_action_pressed("move_up"):
		camera_movement_input.z = -1
	elif Input.is_action_pressed("move_down"):
		camera_movement_input.z = 1
	else:
		camera_movement_input.z = 0
#endregion
	
	# zooms camera in or out only a certain amount based on player input
#region player_zoom
	if Input.is_action_pressed("zoom_in"):
		camera_movement_input.y = -1
	elif Input.is_action_pressed("zoom_out"):
		camera_movement_input.y = +1
	else:
		camera_movement_input.y = 0
	
	if (self.fov <= 30 and camera_movement_input.y == -1) or  (self.fov >= 120 and camera_movement_input.y == 1):
		camera_movement_input.y = 0
#endregion
	
	# moves camera and zooms in based on player inputs
	self.fov += camera_movement_input.y * delta * move_speed
	var camera_position = Vector3 (camera_movement_input.x * move_speed * delta, 0, camera_movement_input.z * move_speed * delta)
	self.position += camera_position
