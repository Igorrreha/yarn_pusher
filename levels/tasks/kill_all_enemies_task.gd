tool

class_name KillAllEnemiesTask
extends Task


export (Array, NodePath) var _enemies_containers_paths setget _set_enemies_containers_paths


var _living_enemies_number := 0


func _ready():
	if Engine.editor_hint:
		return
	
	for container_path in _enemies_containers_paths:
		for child in get_node(container_path).get_children():
			if child is Enemy:
				child.connect("died", self, "_enemy_died")
				_living_enemies_number += 1


func _enemy_died():
	_living_enemies_number -= 1
	
	if _living_enemies_number == 0:
		complete_task()


# SETTERS
func _set_enemies_containers_paths(new_value: Array):
	_enemies_containers_paths = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _enemies_containers_paths.empty():
		message += Warnings.field_is_empty("Enemies Containers Paths")
	else:
		for i in range(_enemies_containers_paths.size()):
			if _enemies_containers_paths[i].is_empty():
				message += Warnings.array_item_is_empty("Enemies Containers Paths", str(i))
	
	return message.strip_edges()
