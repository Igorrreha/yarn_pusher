tool

class_name YarnGrabber
extends StaticBody2D


export (NodePath) var _joint_path setget _set_joint_path

onready var _joint = get_node(_joint_path)


func grab(yarn_segment: YarnSegment):
	_joint.node_b = _joint.get_path_to(yarn_segment)


# SETTERS
func _set_joint_path(new_value: NodePath):
	_joint_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _joint_path.is_empty():
		message += Warnings.field_is_empty("Joint Path") 
	
	return message.strip_edges()
