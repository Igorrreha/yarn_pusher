tool

extends EditorScript


var node_root: Line2D
var node_segments

var tscn_yarn_segment = preload("res://obj/yarn_segment.tscn")
var density = 16.0


func _run():
	node_root = get_scene()
	node_segments = node_root.get_node("Segments")
	
	# remove all childs
	for child in node_segments.get_children():
		child.free()
	
	# create first segment
	var cur_segment = create_segment(node_root.points[0], null)
	
	# create segments
	for i in range(1, node_root.points.size()):
		
		var section_vec = node_root.points[i] - node_root.points[i-1]
		var inner_segments_amount = ceil(section_vec.length() / density)
		
		var density_step = section_vec.length() / inner_segments_amount
		
		for j in range(inner_segments_amount):
			cur_segment = create_segment(section_vec.normalized() * ((1 + j) * density_step) + node_root.points[i-1], cur_segment)
	
#	var first_joint = tscn_yarn_segment.instance()
	

func create_segment(pos, pinned_obj):
	var new_segment = tscn_yarn_segment.instance()
	new_segment.position = pos

	node_segments.add_child(new_segment)
	new_segment.set_owner(node_segments.get_tree().get_edited_scene_root())
	
	if not pinned_obj == null:
		var node_joint = new_segment.get_node("SegmentJoint")
		node_joint.node_a = node_joint.get_path_to(pinned_obj)
	
	return new_segment
