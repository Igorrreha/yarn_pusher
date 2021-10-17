class_name NodeAction
extends Node


signal done(node)


export (NodePath) var _node_path: NodePath


func do():
	emit_signal("done", get_node(_node_path))
