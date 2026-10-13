extends Node3D

var is_level_over: bool
var level_over_delay: float = 0.25

func _process(delta: float) -> void:
	# sets level over, if no enemy or allied units remain
	if (GameManager.number_of_friendly_units <= 0 and GameManager.number_of_units_left_to_spawn <= 0) or GameManager.number_of_enemy_units <= 0:
		is_level_over = true
	
	# delay before loading to main menu
	if is_level_over == true:
		level_over_delay -= delta
		if level_over_delay < 0:
			SignalManager.level_over.emit()
			get_tree().change_scene_to_file("res://UI/main_menu.tscn")
