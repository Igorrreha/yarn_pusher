tool

class_name Hole
extends StaticBody2D


signal filled


export (NodePath) var _collision_shape_path setget _set_collision_shape_path


var _content: Node


onready var _collision_shape = get_node(_collision_shape_path)


func fill(obj: Node):
	_collision_shape.set_deferred("disabled", true)
	_content = obj


# SETTERS
func _set_collision_shape_path(new_value: NodePath):
	_collision_shape_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _collision_shape_path.is_empty():
		message += Warnings.field_is_empty("Collision Shape") 
	
	return message.strip_edges()
