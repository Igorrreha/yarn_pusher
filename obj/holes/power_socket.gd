tool

class_name PowerSocket
extends Area2D


signal activated
signal deactivated


var _is_active := false


func _ready():
	if Engine.editor_hint:
		return
	
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")


func _on_area_entered(area: Area2D):
	if area is PowerBox:
		_set_active(true)


func _on_area_exited(area: Area2D):
	if area is PowerBox:
		_set_active(false)


# SETTERS
func _set_active(new_value: bool):
	_is_active = new_value
	
	emit_signal("activated" if _is_active else "deactivated")
