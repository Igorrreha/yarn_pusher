tool

class_name Yarn
extends Line2D


signal pull_ended

export (NodePath) var _segments_container_path setget _set_segments_container_path
export (NodePath) var _ray_for_search_grabbers_path setget _set_ray_for_search_grabbers_path
export (NodePath) var _tween_path setget _set_tween_path

export var pull_dur = 2.0

var max_dist_between_segments = 8.0

var points_physical_part = []
var points_not_physical_part = []


onready var _segments_container = get_node(_segments_container_path)
onready var _ray_for_search_grabbers = get_node(_ray_for_search_grabbers_path)
onready var _tween = get_node(_tween_path)


func initialize(pos: Vector2):
	add_point(pos)


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	if _segments_container.get_child_count() > 0:
		
		# add not physical points
		points = points_not_physical_part
		
		# add physical points 
		for segment in _segments_container.get_children():
			add_point(segment.global_position)


func move_last_point(pos: Vector2):
	points[points.size()-1] = pos


func start_reeling(node_reeler: Reeler):
	var node_grabber: YarnGrabber
	
	_ray_for_search_grabbers.enabled = true
	
	# fill physical part points array
	for i in range(points.size() - 1, 0, -1):
		
		# add point
		points_physical_part.push_front(points[i])
		
		# searching for grabbers
		_ray_for_search_grabbers.global_position = points[i]
		_ray_for_search_grabbers.cast_to = points[i - 1] - points[i]
		
		_ray_for_search_grabbers.force_raycast_update()
		
		if _ray_for_search_grabbers.is_colliding():
			node_grabber = _ray_for_search_grabbers.get_collider()
			points_physical_part.push_front(node_grabber.global_position)
			
			break
	
	
	# return if grabber is not find
	if node_grabber == null:
		return
	
	
	# fill not-physical part point array
	for i in range(points.size() - points_physical_part.size() + 1):
		points_not_physical_part.append(points[i]) 
	
	
	# create first segment
	var cur_segment = _create_segment(points_physical_part[0], null)
	node_grabber.grab(cur_segment)
	
	
	# create segments
	for i in range(1, points_physical_part.size()):
		
		var section_vec = points_physical_part[i] - points_physical_part[i-1]
		var inner_segments_amount = ceil(section_vec.length() / max_dist_between_segments)
		
		var dist_between_segments = section_vec.length() / inner_segments_amount if inner_segments_amount > 0 else 0
		
		for j in range(inner_segments_amount):
			cur_segment = _create_segment(section_vec.normalized() * ((1 + j) * dist_between_segments) + points_physical_part[i-1], cur_segment)
	
	
	# connect last segment to reeler
	var node_joint = Global.tscn_yarn_segment_joint.instance()
	
	node_joint.length = 1
	node_joint.rest_length = 1
	
	cur_segment.add_child(node_joint)
	
	node_joint.node_a = node_joint.get_path_to(cur_segment)
	node_joint.node_b = node_joint.get_path_to(node_reeler)
	
	
	# start reeling
	_tween.remove_all()
	_tween.interpolate_method(self, "_pull_on", 1.0, 0.0, pull_dur)
	_tween.start()


func _pull_on(coef):
	for segment in _segments_container.get_children():
		if not segment.joint == null:
			segment.joint.rest_length = (segment.joint.length - 1) * coef + 1


func _create_segment(pos, pinned_obj):
	var new_segment = Global.tscn_yarn_segment.instance()
	new_segment.position = pos
	
	_segments_container.add_child(new_segment)
	
	if not pinned_obj == null:
		var node_joint = Global.tscn_yarn_segment_joint.instance()
		
		var segment_vec = pinned_obj.global_position - new_segment.global_position
		node_joint.length = segment_vec.length()
		node_joint.rest_length = node_joint.length
		
		node_joint.rotation = segment_vec.angle() - PI/2
		
		new_segment.add_child(node_joint)
		
		node_joint.node_a = node_joint.get_path_to(new_segment)
		node_joint.node_b = node_joint.get_path_to(pinned_obj)
		
		new_segment.joint = node_joint
	
	return new_segment


# SETTERS
func _set_segments_container_path(new_value: NodePath):
	_segments_container_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


func _set_ray_for_search_grabbers_path(new_value: NodePath):
	_ray_for_search_grabbers_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


func _set_tween_path(new_value: NodePath):
	_tween_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _segments_container_path.is_empty():
		message += Warnings.field_is_empty("Segments Container Path")
	
	if _ray_for_search_grabbers_path.is_empty():
		message += Warnings.field_is_empty("Ray For Search Grabbers Path")
	
	if _tween_path.is_empty():
		message += Warnings.field_is_empty("Tween Path")
	
	return message.strip_edges()
