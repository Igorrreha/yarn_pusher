tool

extends Area2D


signal activated
signal deactivated


export (NodePath) var _collision_shape_path setget _set_collision_shape_path
export (bool) var _is_active = false


onready var _collision_shape: CollisionShape2D = get_node(_collision_shape_path)


func _ready():
	if Engine.editor_hint:
		return
	
	if _is_active:
		activate()
	else:
		deactivate()


func activate():
	if not _is_active:
		_is_active = true
		_collision_shape.set_deferred("disabled", true)
		
		emit_signal("activated")


func deactivate():
	if _is_active:
		_is_active = false
		_collision_shape.set_deferred("disabled", false)
		
		emit_signal("deactivated")


# SETTERS
func _set_collision_shape_path(new_value: NodePath):
	_collision_shape_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _collision_shape_path.is_empty():
		message += Warnings.field_is_empty("Collision Shape Path") 
	
	return message.strip_edges()
