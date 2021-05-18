extends Node

onready var node_ui = $ParallaxBackground/UI
onready var node_label_fps = $ParallaxBackground/UI/FPS


func _physics_process(delta):
	node_label_fps.text = str(Engine.get_frames_per_second())
