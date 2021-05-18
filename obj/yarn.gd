extends Line2D

class_name Yarn


onready var node_segments = $Segments

var max_dist_between_segments = 16.0


func _ready():
	pass
#	start_reeling()


func start_reeling():
	# remove all childs
	for child in node_segments.get_children():
		child.free()
	
	# create first segment
	var cur_segment = create_segment(points[0], null)
	
	# create segments
	for i in range(1, points.size()):
		
		var section_vec = points[i] - points[i-1]
		var inner_segments_amount = ceil(section_vec.length() / max_dist_between_segments)
		
		var dist_between_segments = section_vec.length() / inner_segments_amount
		
		for j in range(inner_segments_amount):
			cur_segment = create_segment(section_vec.normalized() * ((1 + j) * dist_between_segments) + points[i-1], cur_segment)
	
#	var first_joint = tscn_yarn_segment.instance()
	

func create_segment(pos, pinned_obj):
	var new_segment = Global.tscn_yarn_segment.instance()
	new_segment.position = pos

	node_segments.add_child(new_segment)
	new_segment.set_owner(node_segments.get_tree().get_edited_scene_root())
	
	if not pinned_obj == null:
		var node_joint = new_segment.get_node("SegmentJoint")
#		node_joint.node_a = node_joint.get_path_to(pinned_obj)
		node_joint.node_a = pinned_obj.get_path()
	
	return new_segment

