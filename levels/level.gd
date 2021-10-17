tool

class_name Level
extends YSort


signal completed
signal failed


export (String) var level_name setget _set_level_name


func complete():
	emit_signal("completed")


func fail():
	emit_signal("failed")


func _to_string() -> String:
	return level_name


# SETTERS
func _set_level_name(new_value: String):
	level_name = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if level_name.empty():
		message += Warnings.field_is_empty("Level Name")
	
	return message.strip_edges()
