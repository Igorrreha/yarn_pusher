extends Area2D


signal hero_entered
signal hero_exited


func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")


func _on_area_entered(area: Area2D):
	if area is Hero:
		emit_signal("hero_entered")


func _on_area_exited(area: Area2D):
	if area is Hero:
		emit_signal("hero_exited")
