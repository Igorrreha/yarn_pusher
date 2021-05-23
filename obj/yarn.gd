extends Line2D

class_name Yarn


signal pull_ended


export var pull_dur = 2.0

var max_dist_between_segments = 8.0

var points_physical_part = []
var points_not_physical_part = []

onready var node_segments = $Segments
onready var node_ray_grabber_searcher = $RayGrabberSearcher
onready var node_tween = $TweenReeling


func _physics_process(delta):
	if node_segments.get_child_count() > 0:
		
		# add not physical points
		points = points_not_physical_part
		
		# add physical points 
		for segment in node_segments.get_children():
			add_point(segment.global_position)


func move_last_point(pos: Vector2):
	points[points.size()-1] = pos


func start_reeling(node_reel: Reel):
	var node_grabber: YarnGrabber
	
	node_ray_grabber_searcher.enabled = true
	
	# fill physical part points array
	for i in range(points.size() - 1, 0, -1):
		
		# add point
		points_physical_part.push_front(points[i])
		
		# searching for grabbers
		node_ray_grabber_searcher.global_position = points[i]
		node_ray_grabber_searcher.cast_to = points[i - 1] - points[i]
		
		node_ray_grabber_searcher.force_raycast_update()
		
		if node_ray_grabber_searcher.is_colliding():
			node_grabber = node_ray_grabber_searcher.get_collider()
			points_physical_part.push_front(node_grabber.global_position)
			
			break
	
	
	# return if grabber is not find
	if node_grabber == null:
		return
	
	
	# fill not-physical part point array
	for i in range(points.size() - points_physical_part.size() + 1):
		points_not_physical_part.append(points[i]) 
	
	
	# create first segment
	var cur_segment = create_segment(points_physical_part[0], null)
	node_grabber.node_joint.node_b = node_grabber.node_joint.get_path_to(cur_segment)
	
	
	# create segments
	for i in range(1, points_physical_part.size()):
		
		var section_vec = points_physical_part[i] - points_physical_part[i-1]
		var inner_segments_amount = ceil(section_vec.length() / max_dist_between_segments)
		
		var dist_between_segments = section_vec.length() / inner_segments_amount if inner_segments_amount > 0 else 0
		
		for j in range(inner_segments_amount):
			cur_segment = create_segment(section_vec.normalized() * ((1 + j) * dist_between_segments) + points_physical_part[i-1], cur_segment)
	
	
	# connect last segment to reel
	var node_joint = Global.tscn_yarn_segment_joint.instance()
	
	node_joint.length = 1
	node_joint.rest_length = 1
	
	cur_segment.add_child(node_joint)
	
	node_joint.node_a = node_joint.get_path_to(cur_segment)
	node_joint.node_b = node_joint.get_path_to(node_reel)
	
	
	# start reeling
	node_tween.remove_all()
	node_tween.interpolate_method(self, "pull_on", 1.0, 0.0, pull_dur)
	node_tween.start()


func pull_on(coef):
	for segment in node_segments.get_children():
		if not segment.node_joint == null:
			segment.node_joint.rest_length = (segment.node_joint.length - 1) * coef + 1


func create_segment(pos, pinned_obj):
	var new_segment = Global.tscn_yarn_segment.instance()
	new_segment.position = pos
	
	node_segments.add_child(new_segment)
	
	if not pinned_obj == null:
		var node_joint = Global.tscn_yarn_segment_joint.instance()
		
		var segment_vec = pinned_obj.global_position - new_segment.global_position
		node_joint.length = segment_vec.length()
		node_joint.rest_length = node_joint.length
		
		node_joint.rotation = segment_vec.angle() - PI/2
		
		new_segment.add_child(node_joint)
		
		node_joint.node_a = node_joint.get_path_to(new_segment)
		node_joint.node_b = node_joint.get_path_to(pinned_obj)
		
		new_segment.node_joint = node_joint
	
	return new_segment

