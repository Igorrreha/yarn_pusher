extends Hole

class_name Reel


export var pull_on_speed = 100.0

var pulling_started = false


func _physics_process(delta):
	if pulling_started:
		node_filler.node_yarn.pull_on(pull_on_speed * delta, global_position)


func fill(obj):
	.fill(obj)
	
	if obj is YarnBall:
		node_filler.node_yarn.connect("pull_ended", self, "end_pull")
		pulling_started = true


func end_pull():
	pulling_started = false
