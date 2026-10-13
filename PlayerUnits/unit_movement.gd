extends Node

@export var movement_speed: float
@export var moveable_object: Node
var unit_attack: Node
var position_move_to: Vector3
var is_moving: bool

# connects signals up
func _ready() -> void:
	SignalManager.map_clicked.connect(_move_to)
	SignalManager.enemy_unit_right_clicked.connect(_move_to_enemy)
	SignalManager.enemy_unit_reached.connect(_enemy_unit_reached)
	SignalManager.enemy_unit_exited_attack_range.connect(_re_move_to_attack)

# called every frame
func _physics_process(delta: float) -> void:
	if moveable_object.is_in_group("Friendly") and is_moving == true:
		_movement(delta)

# set position for unit to move to
func _move_to(movement_position: Vector3):
	if moveable_object.is_clicked == true:
		is_moving = true
		position_move_to = movement_position
		position_move_to.y = moveable_object.position.y

# moves unit to selected position, based on movement speed and delta
func _movement(delta: float):
	moveable_object.velocity = moveable_object.global_position.direction_to(position_move_to) * movement_speed * delta
	moveable_object.move_and_slide()
	
	# if unit is in a radius of the position to move to, then stop moving unit
	if moveable_object.global_position.x - position_move_to.x < 1 and moveable_object.global_position.x - position_move_to.x > -1 and moveable_object.global_position.z - position_move_to.z < 1 and moveable_object.global_position.z - position_move_to.z > -1:
		is_moving = false

# if unit is clicked, move to enemy position
func _move_to_enemy(attack_node: Node):
	if moveable_object.is_clicked == true:
		is_moving = true
		unit_attack = attack_node
		position_move_to = attack_node.position
		position_move_to.y = moveable_object.position.y

# moves unit to enemy position (when enemy leaves unit attack radius)
func _re_move_to_attack(attack_node: Node):
	if unit_attack == attack_node:
		is_moving = true
		position_move_to = attack_node.position
		position_move_to.y = moveable_object.position.y

# stops unit from moving once, reaching enemy unit
func _enemy_unit_reached(attack_node: Node):
	if attack_node == unit_attack:
		is_moving = false
