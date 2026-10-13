extends Control

var pre_loaded_asset
var number_can_spawn

# connects signals to functions
func _ready() -> void:
	SignalManager.unit_spawn_information.connect(_spawn_unit)
	SignalManager.de_select_unit_to_spawn.connect(_de_select_spawn_unit)

# sets unit type and amount allowed to spawn, de-selects all units
func _unit_to_spawn_selection(unit_type_selected, number_to_spawn):
	pre_loaded_asset = unit_type_selected
	number_can_spawn = number_to_spawn
	SignalManager.de_select_all_units.emit()

# unit spawn
func _spawn_unit(spawn_location: Vector3):
	# if a unit is selected and there are units to spawn
	if pre_loaded_asset != null and number_can_spawn > 0:
		# instantiates unit, sets it's position and other misc actions
		var unit_spawned = pre_loaded_asset.instantiate()
		self.get_tree().root.add_child.call_deferred(unit_spawned)
		unit_spawned.position = Vector3(spawn_location.x, 4, spawn_location.z)
		SignalManager.unit_spawned.emit(pre_loaded_asset)
		number_can_spawn -= 1

# resets selected unit
func _de_select_spawn_unit():
	pre_loaded_asset = null
