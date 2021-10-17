tool

class_name YarnBall
extends Movable


signal unreeled
signal losted


export (NodePath) var _yarn_path setget _set_yarn_path
export var _yarn_capacity = 30 # max move distance


onready var _yarn: Yarn = get_node(_yarn_path)


func _ready():
	if Engine.editor_hint:
		return
	
	_yarn.initialize(global_position)


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	if _cur_state == States.MOVE or _cur_state == States.LOCKED:
		_yarn.move_last_point(global_position)


func on_pushed(vec: Vector2):
	.on_pushed(vec)
	
	_yarn.add_point(global_position)


func move(vec: Vector2):
	.move(vec)
	
	_yarn_capacity -= 1
	
	if _yarn_capacity == 0:
		_collision_shape.set_deferred("disabled", true)
		emit_signal("unreeled")


#func _after_fall():
#	._after_fall()
#
#	if _holder_hole is Reeler:
#		_yarn.start_reeling(_holder_hole)
#	else:
#		emit_signal("losted")


# SETTERS
func _set_yarn_path(new_value: NodePath):
	_yarn_path = new_value
	
	if Engine.editor_hint:
		update_configuration_warning()


# FOR EDITOR
func _get_configuration_warning() -> String:
	var message: String = ""
	
	if _yarn_path.is_empty():
		message += Warnings.field_is_empty("Yarn Path") 
	
	return message.strip_edges()
