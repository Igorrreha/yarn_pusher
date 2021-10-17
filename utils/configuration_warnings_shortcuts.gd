class_name Warnings
# Shortcuts for editor_configuration_warning messges


## SETTERS
#func _set*(new_value: NodePath):
#	* = new_value
#	
#	if Engine.editor_hint:
#		update_configuration_warning()


## FOR EDITOR
#func _get_configuration_warning() -> String:
#	var message: String = ""
#	
#	if *.is_empty():
#		message += Warnings.field_is_empty(*) 
#	
#	return message.strip_edges()


static func custom(text: String):
	return "%s\n\n" % text


static func field_is_empty(name: String) -> String:
	return "Field \"%s\" is empty! Check the Inspector\n\n" % name


static func array_item_is_empty(array_name: String, item_name: String):
	return "[{0}] item of field \"{1}\" item is empty! Check the Inspector\n\n".format([item_name, array_name])
