tool

class_name Switch
extends Node2D


signal activated
signal deactivated


export (bool) var _is_active = false


func _ready():
	if Engine.editor_hint:
		return
	
	if _is_active:
		emit_signal("activated")
	else:
		emit_signal("deactivated")


func activate():
	if not _is_active:
		_is_active = true
		
		emit_signal("activated")


func deactivate():
	if _is_active:
		_is_active = false
		
		emit_signal("deactivated")
