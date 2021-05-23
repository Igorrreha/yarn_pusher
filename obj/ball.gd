extends Movable

class_name YarnBall


signal falled_into_reel(reel)
signal moved(cur_pos)
signal yarn_initiated_started

signal unreeled


export var yarn_capacity = 30

var node_yarn: Line2D


func _physics_process(delta):
	if cur_state == States.MOVE or cur_state == States.LOCKED:
		emit_signal("moved", global_position)


func on_push():
	.on_push()
	
	node_yarn.add_point(global_position)


func move(vec: Vector2):
	.move(vec)
	
	yarn_capacity -= 1
	
	if yarn_capacity == 0:
		node_collision_shape.set_deferred("disabled", true)
		emit_signal("unreeled")


func init_yarn():
	connect("falled_into_reel", node_yarn, "start_reeling")
	connect("moved", node_yarn, "move_last_point")
	
	node_yarn.add_point(global_position)


func after_fall():
	.after_fall()
	
	if node_holder_hole is Reel:
		emit_signal("falled_into_reel", node_holder_hole)
