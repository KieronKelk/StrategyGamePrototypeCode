extends Button

enum level_select {Easy, Normal, Hard}
@export var level_type = level_select.Easy
@export var level_load_path: String
var level_to_load

# opens level based on the button pressed
func _button_pressed():
	if level_type == level_select.Easy:
		GameManager._easy_level()
	elif level_type == level_select.Normal:
		GameManager._medium_level()
	elif level_type == level_select.Hard:
		GameManager._hard_level()
	
	get_tree().change_scene_to_file(level_load_path)
