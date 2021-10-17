class_name Task
extends Node


signal completed


func complete_task():
	emit_signal("completed")
