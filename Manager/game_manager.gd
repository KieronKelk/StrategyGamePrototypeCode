extends Node

var number_small_unit_spawn: int
var number_medium_unit_spawn: int
var number_large_unit_spawn: int
var number_of_units_left_to_spawn: int
var number_of_friendly_units: int
var number_of_enemy_units: int

# connects signal to func
func _ready() -> void:
	SignalManager.level_over.connect(_level_over)

# gets total amount of unit left to spawn
func _process(delta: float) -> void:
	number_of_units_left_to_spawn = number_small_unit_spawn + number_medium_unit_spawn + number_large_unit_spawn
	
#region level_selected
# sets number of unit of each type to spawn and number of enemies present
func _easy_level():
	number_small_unit_spawn = 3
	number_medium_unit_spawn = 1
	number_large_unit_spawn = 1
	number_of_enemy_units = 3
	

func _medium_level():
	number_small_unit_spawn = 6
	number_medium_unit_spawn = 2
	number_large_unit_spawn = 0
	number_of_enemy_units = 7

func _hard_level():
	number_small_unit_spawn = 3
	number_medium_unit_spawn = 4
	number_large_unit_spawn = 1
	number_of_enemy_units = 11
#endregion

# resets numbr of friendly units to 0 at end of level
func _level_over():
	number_of_friendly_units = 0
