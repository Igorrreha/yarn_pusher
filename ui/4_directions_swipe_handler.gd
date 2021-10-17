extends SwipeHandler


signal swiped_up()
signal swiped_down()
signal swiped_left()
signal swiped_right()


func _ready():
	connect("swiped", self, "_on_swipe")


func _on_swipe(direction: Vector2):
	if abs(Vector2.RIGHT.angle_to(direction)) < PI/4:
		emit_signal("swiped_right")
	elif abs(Vector2.LEFT.angle_to(direction)) < PI/4:
		emit_signal("swiped_left")
	elif abs(Vector2.UP.angle_to(direction)) < PI/4:
		emit_signal("swiped_up")
	else:
		emit_signal("swiped_down")
