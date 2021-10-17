class_name Hero
extends Movable


signal died


func _ready():
	connect("stopped_by_collision_with_obj", self, "_push_obj")


func move_up():
	_move(Vector2.UP * Global.cell_size)


func move_down():
	_move(Vector2.DOWN * Global.cell_size)


func move_left():
	_move(Vector2.LEFT * Global.cell_size)


func move_right():
	_move(Vector2.RIGHT * Global.cell_size)


func _input(event):
	if event.is_action_pressed("player_up"):
		move_up()
	elif event.is_action_pressed("player_down"):
		move_down()
	elif event.is_action_pressed("player_left"):
		move_left()
	elif event.is_action_pressed("player_right"):
		move_right()


func _push_obj(obj, push_vec: Vector2):
	if obj is Movable and obj.can_be_pushed:
		obj.on_pushed(push_vec)
