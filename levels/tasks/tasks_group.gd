tool

class_name TasksGroup
extends Node


signal completed


var _uncompleted_tasks_number := 0


func _ready():
	if Engine.editor_hint:
		return
	
	for task in get_children():
		task.connect("completed", self, "_task_completed")
		_uncompleted_tasks_number += 1


func _task_completed():
	_uncompleted_tasks_number -= 1
	
	if _uncompleted_tasks_number == 0:
		emit_signal("completed")


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if get_child_count() == 0:
		message += Warnings.custom("This node must contain Task children to work")
	else:
		for child in get_children():
			if not child is Task:
				message += Warnings.custom("Non \"Task\" class child detected (%s)" % child.name)
	
	return message.strip_edges()
