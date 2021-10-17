class_name ActionWithActionName
extends Node


signal done(string)


func do(action_name: String):
	emit_signal("done", action_name)
