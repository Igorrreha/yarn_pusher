extends Line2D

class_name Yarn


signal pull_ended


var max_dist_between_segments = 16.0

onready var node_segments = $Segments


func _process(delta):
	if node_segments.get_child_count() > 0:
		var new_points = []
		for segment in node_segments.get_children():
			new_points.append(segment.global_position)
		
		points = new_points


func start_reeling():
	# create first segment
	var cur_segment = create_segment(points[0], null)
	
	# create segments
	for i in range(1, points.size()):
		
		var section_vec = points[i] - points[i-1]
		var inner_segments_amount = ceil(section_vec.length() / max_dist_between_segments)
		
		var dist_between_segments = section_vec.length() / inner_segments_amount
		
		for j in range(inner_segments_amount):
			cur_segment = create_segment(section_vec.normalized() * ((1 + j) * dist_between_segments) + points[i-1], cur_segment)


func pull_on(dist, target):
	if node_segments.get_child_count() < 2:
		emit_signal("pull_ended")
		return
	
	var prelast_segment = node_segments.get_child(node_segments.get_child_count() - 2) 
	
	var vec_to_target = prelast_segment.global_position - target
	var new_pos = prelast_segment.global_position - (vec_to_target.normalized() * dist).clamped(vec_to_target.length())
	
	prelast_segment.global_position = new_pos
	
	if prelast_segment.global_position == target:
		prelast_segment.queue_free()


func create_segment(pos, pinned_obj):
	var new_segment = Global.tscn_yarn_segment.instance()
	new_segment.position = pos

	node_segments.add_child(new_segment)
	
	if not pinned_obj == null:
		var node_joint = new_segment.get_node("SegmentJoint")
#		node_joint.node_a = node_joint.get_path_to(pinned_obj)
		node_joint.node_a = node_joint.get_path_to(pinned_obj)
		
	
	return new_segment

