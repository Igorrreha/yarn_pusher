tool

class_name Enemy
extends StaticBody2D


signal died


enum State {
	IDLE,
	DEAD,
}

export (NodePath) var _hitbox_area_path setget _set_hitbox_area_path
export (NodePath) var _collision_shape_path setget _set_collision_shape_path

var _cur_state = State.IDLE 


onready var _hitbox_area = get_node(_hitbox_area_path)
onready var _collision_shape = get_node(_collision_shape_path)


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	if _cur_state == State.DEAD: 
		return
	
	var overlapping_bodies = _hitbox_area.get_overlapping_bodies()
	
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
		
		if final_count == sides_arr.size():
			_die()


func _die():
	print("enemy died")
	
	_cur_state = State.DEAD
	
	_collision_shape.set_deferred("disabled", true)
	
	emit_signal("died")


# SETTERS
func _set_hitbox_area_path(new_value: NodePath):
	_hitbox_area_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


func _set_collision_shape_path(new_value: NodePath):
	_collision_shape_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _hitbox_area_path.is_empty():
		message += Warnings.field_is_empty("Hitbox Area Path") 
	
	if _collision_shape_path.is_empty():
		message += Warnings.field_is_empty("Collision Shape Path") 
	
	return message.strip_edges()
