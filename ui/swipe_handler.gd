class_name SwipeHandler
extends Node


signal drag_started(position)
signal drag_ended(position)
signal swiped(direction)


export var swipe_distance_to_handle := 5.0


var _drag_started := false 
var _drag_start_point: Vector2


func _ready():
	pass


func _input(event):
	if (event is InputEventScreenTouch
	and event.index == 0):
		if event.pressed:
			_drag_start_point = event.position
			_drag_started = true
			emit_signal("drag_started")
			
		else:
			_drag_start_point = Vector2.ZERO
			_drag_started = false
			emit_signal("drag_ended")
	
	if (event is InputEventScreenDrag
	and _drag_started
	and event.index == 0):
		var swipe_vector: Vector2 = event.position - _drag_start_point
		if swipe_vector.length() >= swipe_distance_to_handle:
			emit_signal("swiped", swipe_vector.normalized())
			_drag_started = false
