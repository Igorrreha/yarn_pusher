extends RigidBody2D

class_name YarnSegment


func _ready():
	prints($SegmentJoint.node_a, $SegmentJoint.node_b)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(name)
