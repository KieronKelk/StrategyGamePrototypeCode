extends CharacterBody3D

@export var movement_speed: float
var node_to_target: CharacterBody3D

func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(node_to_target.position) * movement_speed * delta
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == node_to_target:
		# play explosion VFX + sound and then destroy self
		queue_free()
