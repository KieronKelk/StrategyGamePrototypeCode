extends Area3D

@export var root_node: CharacterBody3D
@export var movement_speed: float
@export var enemy_target_area: Area3D
var unit_root_array = []
var closest_node = null
var closest_node_distance = 1000

# connects signals up
func _ready() -> void:
	SignalManager.unit_died.connect(_on_unit_killed)


func _physics_process(delta: float) -> void:
	# check see if unit are in radius of enemy visability
	if unit_root_array.size() > 0:
		# finds closest node to the unit
		_find_closest_node()
		
		# if unit is not in the enemy attack area, then move to
		if closest_node != enemy_target_area.closest_root_node:
			_enemy_movement(delta)
			
		# if the closest node is in the enemy target area, stop moving
		elif closest_node == enemy_target_area.closest_root_node:
			root_node.velocity = Vector3.ZERO
	
	# if no units are in radius, then move forward slowly
	else:
		root_node.velocity = Vector3(-0.05 * movement_speed * delta, 0, 0)
		root_node.move_and_slide()

func _find_closest_node():
	# loop through checking if a unit is closer, then the current closest unit based on combined distance of x and z
	for unit in unit_root_array:
		if unit != closest_node:
			var unit_distance = unit.position.x + unit.position.z
			if unit_distance < 0:
				unit_distance *= -1
				
			if unit_distance < closest_node_distance:
				closest_node = unit
				closest_node_distance = unit_distance

# enemy moves to position of the targeted unit, smoothly
func _enemy_movement(delta: float):
	var position_move_to = Vector3(closest_node.position.x, root_node.position.y, closest_node.position.z)
	root_node.velocity = root_node.global_position.direction_to(position_move_to) * movement_speed * delta
	root_node.move_and_slide()
	pass

# adds unit to array of visible units if the type is friendly
func _on_body_entered(unit: Node3D) -> void:
	if unit.is_in_group("Friendly"):
		unit_root_array.append(unit)

# removes unit to array of visible units if the type is friendly
func _on_body_exited(unit: Node3D) -> void:
	if unit.is_in_group("Friendly"):
		unit_root_array.erase(unit)

func _on_unit_killed(unit_dead: Node3D):
	# removes unit from array if present
	for unit in unit_root_array:
		if unit == unit_dead:
			unit_root_array.erase(unit)
	
	# if closest unit is dead, switch to default null settings
	if closest_node == unit_dead:
		closest_node_distance = 1000
		closest_node = null
