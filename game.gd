extends Node2D


onready var node_player = $Cat
onready var node_balls = $Balls
onready var node_yarn = $Yarn
onready var node_reels = $Reels


func _ready():
	# connect signals
	node_player.connect("stopped_by_collision_with_obj", self, "push_obj")
	
	# create yarn for each Ball
	for ball in node_balls.get_children():
		var new_yarn = Global.tscn_yarn.instance()
		node_yarn.add_child(new_yarn)
		
		ball.node_yarn = new_yarn
		ball.init_yarn()


func push_obj(obj, push_vec: Vector2):
	if obj is Ball:
		obj.move_buffer = push_vec
		obj.move(obj.move_buffer)
		
		obj.on_push()
