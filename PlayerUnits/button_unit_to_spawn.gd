extends Button

enum type {Small, Medium, Large}
@export var unit_type = type.Small
@export var in_game_ui: Control
@export var number_to_spawn: int
@export var number_to_spawn_text: Label
@export var enemy_spawn_path: String
var node_to_spawn

# sets the unit to spawn and connects the signals up
func _ready() -> void:
	node_to_spawn = load(enemy_spawn_path)
	SignalManager.unit_spawned.connect(_unit_spawned)
	pass # Replace with function body.


# sets the text of how many units can be spawned
func _process(delta: float) -> void:
	if unit_type == type.Small:
		number_to_spawn = GameManager.number_small_unit_spawn
	elif unit_type == type.Medium:
		number_to_spawn = GameManager.number_medium_unit_spawn
	elif unit_type == type.Large:
		number_to_spawn = GameManager.number_large_unit_spawn
	number_to_spawn_text.text = str(number_to_spawn)
	pass

# if there are units to spawn, when the button is clicked the unit is selected to spawn
func _on_pressed() -> void:
	if number_to_spawn > 0:
		in_game_ui._unit_to_spawn_selection(node_to_spawn, number_to_spawn)
	pass # Replace with function body.

# takes away the total number of how many units are left to spawn
func _unit_spawned(spawned_unit):
	if spawned_unit == node_to_spawn:
		if unit_type == type.Small:
			GameManager.number_small_unit_spawn -= 1
		elif unit_type == type.Medium:
			GameManager.number_medium_unit_spawn -= 1
		elif unit_type == type.Large:
			GameManager.number_large_unit_spawn -= 1
