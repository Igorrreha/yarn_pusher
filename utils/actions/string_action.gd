class_name StringAction
extends Node


signal done(string)


export (String) var _string: String


func do():
	emit_signal("done", _string)
