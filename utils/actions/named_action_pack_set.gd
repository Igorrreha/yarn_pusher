class_name NamedActionPackSet
extends Node


func do_pack(action_name):
	action_name = str(action_name)
	var action_pack = get_node_or_null(action_name)
	
	if action_pack == null:
		action_pack = get_node("default")
	
	for action in action_pack.get_children():
		if action is ActionWithActionName:
			action.do(action_name)
		else:
			action.do()
