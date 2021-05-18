extends Area2D

class_name Reel


var node_filler
onready var node_collision_shape = $CollisionShape2D


func fill(obj):
	node_collision_shape.set_deferred("disabled", true)
	node_filler = obj
