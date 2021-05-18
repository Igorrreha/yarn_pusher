extends Area2D

class_name Movable

enum MoveTypes {
	ONE_STEP, MOVE_TO_SOLID
}
export (MoveTypes) var cur_move_type = MoveTypes.ONE_STEP

enum States {
	IDLE, MOVE, LOCKED
}
export (States) var cur_state = States.IDLE

export var move_dur = 0.2
export var move_buffer = Vector2()
export var is_fallable = true

onready var node_move_tween: Tween = $TweenMove
onready var node_move_ray: RayCast2D = $RayMove
onready var node_collision_shape: CollisionShape2D = $CollisionShape2D


signal stopped_by_collision_with_obj(obj, move_vec)


func move(vec: Vector2):
	if cur_state == States.LOCKED:
		return
	
	node_move_ray.rotation = vec.angle()
	node_move_ray.force_raycast_update()
	
	# collsion with solid
	if node_move_ray.is_colliding():
		var collider = node_move_ray.get_collider()
		emit_signal("stopped_by_collision_with_obj", collider, vec)
		
		clear_move_buffer()
		cur_state = States.IDLE
		
		return
	
	# moving
	if cur_state == States.IDLE:
		var new_pos = position + vec
		
		node_move_tween.remove_all()
		node_move_tween.interpolate_property(self, "position", position, new_pos, move_dur)
		
		node_move_tween.start()
		
		cur_state = States.MOVE
	
	else:
		move_buffer = vec


func on_push():
	pass


func fall_into(obj):
	node_collision_shape.set_deferred("disabled", true)
	cur_state = States.LOCKED


func clear_move_buffer():
	move_buffer = Vector2()


func _on_TweenMove_tween_all_completed():
	if cur_state == States.LOCKED:
		return
	
	cur_state = States.IDLE
	
	match cur_move_type:
		MoveTypes.ONE_STEP:
			if not move_buffer.length() == 0:
				move(move_buffer)
				clear_move_buffer()
		
		MoveTypes.MOVE_TO_SOLID:
			move(move_buffer)


func _on_Movable_area_entered(area):
	if is_fallable:
		if area is Hole:
			area.fill(self)
			fall_into(area)
