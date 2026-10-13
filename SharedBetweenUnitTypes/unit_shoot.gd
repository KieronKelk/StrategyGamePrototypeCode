extends Area3D

enum allegiances {Friend, Enemy}
@export var unit_allegiance = allegiances.Friend

@export var unit_damage: float
@export var unit_crew_damage: float
@export var base_shot_delay: float
var shot_delay: float
var unit_shot: bool = false

var closest_root_node
var closest_root_node_distance: float = 10000
var unit_root_array = []

var selected_unit_attack_node
var is_unit_attack_selected: bool
var is_selected_unit_in_range: bool

@export var root_node: CharacterBody3D
var bullet

# connects signals
func _ready() -> void:
	SignalManager.unit_died.connect(_unit_death)
	SignalManager.enemy_unit_right_clicked.connect(_unit_selected_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# if can shoot and a target isn't manually selected
	if unit_shot == false and unit_root_array.size() > 0 and is_unit_attack_selected == false:
		unit_shot = true
		# finds closest unit
		for unit in unit_root_array:
			var unit_node = self.get_node(unit)
			var unit_distance = unit_node.position.x + unit_node.position.z
			if unit_distance < 0:
				unit_distance *= -1
			if unit_distance < closest_root_node_distance:
				closest_root_node = unit_node
				closest_root_node_distance = unit_distance
		
		# attacks closest unit
		_damage_unit()
	
	# if a unit to attack is manually selected and currently exists and can attack
	elif unit_shot == false and is_unit_attack_selected == true and selected_unit_attack_node != null and is_selected_unit_in_range == true:
		unit_shot = true
		# attacks selected unit
		_damage_unit()
	
	# delay between unit attacks
	elif unit_shot == true:
		shot_delay -= delta
		if shot_delay <= 0:
			unit_shot = false
			shot_delay = base_shot_delay

# unit enters Area3D
func _unit_enters_area(target: Node3D):
	var target_root_node = target
	# if node is eligeable adds them to the array of targetable units
	if target_root_node.is_in_group("Enemy") and unit_allegiance == allegiances.Friend:
		unit_root_array.append(target_root_node.get_path())
	elif target_root_node.is_in_group("Friendly") and unit_allegiance == allegiances.Enemy:
		unit_root_array.append(target_root_node.get_path())
	
	# if the unit is the selected attack unit, then emits the signal that the unit is in range
	if is_unit_attack_selected == true and target_root_node == selected_unit_attack_node:
		is_selected_unit_in_range = true
		SignalManager.enemy_unit_reached.emit(selected_unit_attack_node)
		pass

# damages closest targetable unit
func _damage_unit():
	# checks which allegiance unit it's attacking
	if is_unit_attack_selected == false and closest_root_node != null:
		
		if unit_allegiance == allegiances.Friend and closest_root_node.is_in_group("Enemy"):
			# gets enemy stats
			var enemy_stat = closest_root_node.get_node("enemy_stats")
		
			# damages enemy
			enemy_stat.hp -= unit_damage
			enemy_stat.crew_amount -= unit_crew_damage
			enemy_stat._crew_killed()
			
		elif unit_allegiance == allegiances.Enemy and closest_root_node.is_in_group("Friendly"):
			# gets friendly stats
			var player_stat = closest_root_node.get_node("player_stats")
		
			# damages friendly
			player_stat.hp -= unit_damage
			player_stat.crew_amount -= unit_crew_damage
			player_stat._crew_killed()
		
			
	elif is_unit_attack_selected == true:
		
		if unit_allegiance == allegiances.Friend and selected_unit_attack_node.is_in_group("Enemy"):
			
			var enemy_stat = selected_unit_attack_node.get_node("enemy_stats")
			
			# damages enemy
			enemy_stat.hp -= unit_damage
			enemy_stat.crew_amount -= unit_crew_damage
			enemy_stat._crew_killed()
			
		elif unit_allegiance == allegiances.Enemy and closest_root_node.is_in_group("Friendly"):
			# gets friendly stats
			var player_stat = selected_unit_attack_node.get_node("player_stats")
		
			# damages friendly
			player_stat.hp -= unit_damage
			player_stat.crew_amount -= unit_crew_damage
			player_stat._crew_killed()
		

# unit exits Area3D
func _unit_leaves_area(target: Node3D):
	# gets parent node to prevent errors if not already parent
	var target_root_node = target
	
	# removes from array of targetable units
	unit_root_array.erase(target_root_node.get_path())
	
	# emits signal that the selected unit is no longer in range
	if is_unit_attack_selected == true:
		is_selected_unit_in_range = false
		SignalManager.enemy_unit_exited_attack_range.emit(selected_unit_attack_node)
	
	# resets closest node to default if the unit was closest
	if closest_root_node == target:
		closest_root_node_distance = 1000
		closest_root_node = null

# removes unit from array, reset selected unit node if eligable for ever and resets closest node
func _unit_death(unit_dead: Node3D):
	var unit_root = unit_dead.get_parent()
	if unit_root == null:
		unit_root = unit_dead
		
		for unit in unit_root_array:
			var unit_node = self.get_node(unit)
			if unit_root == unit:
				unit_root_array.erase(unit)
	
	if unit_dead == selected_unit_attack_node:
		is_selected_unit_in_range = false
		is_unit_attack_selected = false
		selected_unit_attack_node = null
	
	closest_root_node = null
	closest_root_node_distance = 10000


func _unit_selected_attack(unit_root: Node):
	# gets unit to attack and sets variable
	is_unit_attack_selected = true
	selected_unit_attack_node = unit_root
	
	is_selected_unit_in_range = false
	
	# gets the unit if it is in the array already and sets variable for if unit is in range
	for unit in unit_root_array:
		var unit_node = self.get_node(unit)
		if unit_node == selected_unit_attack_node:
			is_selected_unit_in_range = true
	pass
