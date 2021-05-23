extends StaticBody2D

class_name Enemy


onready var node_hitbox = $Hitbox
onready var node_collision_shape = $CollisionShape2D


func _physics_process(delta):
	var overlapping_bodies = node_hitbox.get_overlapping_bodies()
	
	if overlapping_bodies.size() > 8:
		
		var sides_arr = [0, 0, 0, 0, 0, 0, 0, 0]
		
		for body in overlapping_bodies:
			var vec = (global_position - body.global_position).normalized()
			var check_vec = Vector2.RIGHT
			
			for i in range(sides_arr.size()):
				if check_vec.rotated(i * (PI*2 / sides_arr.size())).angle_to(vec) < PI/4:
					sides_arr[i] = 1
		
		var final_count = 0
		for i in sides_arr:
			final_count += i
		
#		if final_count == sides_arr.size():
#			node_collision_shape.set_deferred("disabled", true)
