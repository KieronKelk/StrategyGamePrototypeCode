extends Node

# misc signals
signal friendly_unit_clicked(object_clicked: Node)
signal de_select_all_units()
signal map_clicked(place_clicked: Vector3)
signal unit_died(unit_dead: Node3D)

# enemy only signals
signal enemy_unit_right_clicked(object_clicked: Node)
signal enemy_unit_reached(enemy_unit: Node)
signal enemy_unit_exited_attack_range()

# unit spawn
signal unit_spawn_information(spawn_position: Vector3)
signal unit_spawned(unit_spawne)
signal de_select_unit_to_spawn()

# game over signal
signal level_over()
