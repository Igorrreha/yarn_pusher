tool

class_name LevelChanger, "res://img/editor_icons/level_changer.svg"
extends Node


signal changed(level)


export (String, DIR) var _dir_levels setget _set_dir_levels


var _cur_level: Level


func change(_name: String):
	if _cur_level != null:
		_cur_level.queue_free()
	
	var level_tscn_path = _dir_levels + "/" + _name + ".tscn"
	
	var tscn_level = load(level_tscn_path)
	assert(tscn_level != null, "Missed level scene in path %s" % level_tscn_path)
	
	var new_level = tscn_level.instance()
	assert(new_level is Level, "Level sceen root must inherits \"Level\" class")
	
	add_child(new_level)
	
	_cur_level = new_level
	emit_signal("changed", new_level)


# SETTERS
func _set_dir_levels(new_value: String):
	_dir_levels = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _dir_levels == "":
		message += Warnings.field_is_empty("Dir Levels")
	
	return message
