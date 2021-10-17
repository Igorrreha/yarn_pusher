tool

class_name Movable
extends Area2D


signal stopped_by_collision_with_obj(obj, move_vec)


enum MoveTypes {
	ONE_STEP, MOVE_TO_SOLID
}

enum States {
	IDLE, MOVE, LOCKED
}


export (NodePath) var _move_tween_path setget _set_move_tween_path
export (NodePath) var _move_ray_path setget _set_move_ray_path
export (NodePath) var _collision_shape_path setget _set_collision_shape_path

export (MoveTypes) var _cur_move_type = MoveTypes.ONE_STEP

export var _move_dur = 0.2
export var _move_vec_buffer = Vector2()

export var can_be_pushed = true


var _cur_state = States.IDLE


onready var _move_tween: Tween = get_node(_move_tween_path)
onready var _move_ray: RayCast2D = get_node(_move_ray_path)
onready var _collision_shape: CollisionShape2D = get_node(_collision_shape_path)


func _ready():
	if Engine.editor_hint:
		return
	
	_move_ray.cast_to.x = Global.cell_size * 0.75


func _move(vec: Vector2):
	if _cur_state == States.LOCKED:
		return
	
	_move_ray.rotation = vec.angle()
	_move_ray.force_raycast_update()
	
	# way is locked
	if _move_ray.is_colliding():
		var collider = _move_ray.get_collider()
		emit_signal("stopped_by_collision_with_obj", collider, vec)
		
		_clear_move_buffer()
		_cur_state = States.IDLE
		
		return
	
	# moving
	if _cur_state == States.IDLE:
		var new_pos = position + vec
		
		_move_tween.remove_all()
		_move_tween.interpolate_property(self, "position", position, new_pos, _move_dur)
		
		_move_tween.start()
		
		_cur_state = States.MOVE
	
	else:
		_move_vec_buffer = vec


func on_pushed(vec: Vector2):
	if _cur_move_type == MoveTypes.MOVE_TO_SOLID:
		_move_vec_buffer = vec
	
	_move(vec)


func _clear_move_buffer():
	_move_vec_buffer = Vector2()


func _on_TweenMove_tween_all_completed():
	if _cur_state == States.LOCKED:
		return
	
	_cur_state = States.IDLE
	
	match _cur_move_type:
		MoveTypes.ONE_STEP:
			if not _move_vec_buffer.length() == 0:
				_move(_move_vec_buffer)
				_clear_move_buffer()
		
		MoveTypes.MOVE_TO_SOLID:
			_move(_move_vec_buffer)


# SETTERS
func _set_move_tween_path(new_value: NodePath):
	_move_tween_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


func _set_move_ray_path(new_value: NodePath):
	_move_ray_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


func _set_collision_shape_path(new_value: NodePath):
	_collision_shape_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _move_tween_path.is_empty():
		message += Warnings.field_is_empty("Move Tween Path")
	
	if _move_ray_path.is_empty():
		message += Warnings.field_is_empty("Move Ray Path")
	
	if _collision_shape_path.is_empty():
		message += Warnings.field_is_empty("Collision Shape Path")
	
	return message.strip_edges()
