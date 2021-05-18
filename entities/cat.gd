extends Movable


func _input(event):
	if event.is_action_pressed("player_up"):
		move(Vector2.UP * Global.cell_size)
	elif event.is_action_pressed("player_down"):
		move(Vector2.DOWN * Global.cell_size)
	elif event.is_action_pressed("player_left"):
		move(Vector2.LEFT * Global.cell_size)
	elif event.is_action_pressed("player_right"):
		move(Vector2.RIGHT * Global.cell_size)
