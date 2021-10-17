class_name SignalArgumentBuffer
extends Node


signal arg_stored
signal arg_shared(argument)


var _argument


func store(argument):
	_argument = argument
	emit_signal("arg_stored")


func share():
	emit_signal("arg_shared", _argument)
