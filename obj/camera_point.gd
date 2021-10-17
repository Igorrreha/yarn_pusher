tool

extends Position2D


func _init():
	if Engine.editor_hint:
		update()


func _draw():
	if Engine.editor_hint:
		_draw_icon()
		_draw_camera_view_rect()


func _draw_icon():
	var size = 6
	draw_polygon([
		Vector2(0, -size),
		Vector2(size, 0),
		Vector2(0, size),
		Vector2(-size, 0),
	], [Color.red])


func _draw_camera_view_rect():
	var window_width = ProjectSettings.get_setting("display/window/size/width")
	var window_height = ProjectSettings.get_setting("display/window/size/height")
	draw_rect(Rect2(-window_width/2, -window_height/2, window_width, window_height), 
			Color(1, 0, 0, 0.3), false)
