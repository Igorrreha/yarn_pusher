extends Movable

class_name YarnBall


var node_yarn: Line2D


func _physics_process(delta):
	if cur_state == States.MOVE or cur_state == States.LOCKED:
		node_yarn.points[node_yarn.points.size()-1] = global_position


func on_push():
	.on_push()
	add_yarn_point()


func init_yarn():
	add_yarn_point()


func add_yarn_point():
	var points = node_yarn.points
	points.append(global_position)
	
	node_yarn.points = points


func fall_into(obj):
	.fall_into(obj)
	
	node_yarn.start_reeling()
