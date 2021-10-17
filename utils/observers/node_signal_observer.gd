class_name NodeSignalObserver
extends Node


var _observable_node: Node setget ,_get_observable_node
export (String) var _signal_name: String


func start_observing(node: Node):
	if _observable_node != null:
		_observable_node.disconnect(_signal_name, self, "_emitted")
	
	_observable_node = node
	_observable_node.connect(_signal_name, self, "_emitted")


func _get_observable_node() -> Node:
	return _observable_node


func _emitted():
	pass
