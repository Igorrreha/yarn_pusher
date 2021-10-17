tool

extends Camera2D


func _init():
	if Engine.editor_hint:
		update()


func _draw():
	if Engine.editor_hint:
		_draw_icon()


func _draw_icon():
	var size = 8
	draw_polyline([
		Vector2(-size, -size * 0.5),
		Vector2(-size, -size),
		Vector2(-size * 0.5, -size),
	], Color.red)
	
	draw_polyline([
		Vector2(size, -size * 0.5),
		Vector2(size, -size),
		Vector2(size * 0.5, -size),
	], Color.red)
	
	draw_polyline([
		Vector2(size, size * 0.5),
		Vector2(size, size),
		Vector2(size * 0.5, size),
	], Color.red)
	
	draw_polyline([
		Vector2(-size, size * 0.5),
		Vector2(-size, size),
		Vector2(-size * 0.5, size),
	], Color.red)


func focus_to_node(node: Node2D):
	global_position = node.global_position
