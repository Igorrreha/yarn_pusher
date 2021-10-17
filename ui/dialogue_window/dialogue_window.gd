class_name DialogueTextLabel 
extends RichTextLabel


signal dialogue_opened
signal dialogue_closed
signal show_animation_started
signal show_animation_ended


var _messages_queue = []
var _message_show_speed = 20 # in chars per sec


onready var _message_show_tween: Tween = Tween.new()


func _ready():
	_message_show_tween = Tween.new()
	_message_show_tween.connect("tween_all_completed", self, 
			"emit_signal", ["show_animation_ended"])


func _input(event):
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			if _message_show_tween.is_active():
				_end_message_animation()
			else:
				if(!_try_show_next_message()):
					_close_dialogue()


# открывает диалоговое окно и начинает показ сообщения
func show_messages(messages):
	_messages_queue.append_array(messages)
	_show_message()
	visible = true
	
	emit_signal("dialogue_opened")


# проигрывает анимацию постепенного вывода сообщения
func _show_message():
	percent_visible = 0
	
	text = _messages_queue.pop_front()
	
	var dur = text.length() * (1.0 / _message_show_speed)
	_message_show_tween.interpolate_property(self, "percent_visible", 
			0, 1, dur)
	
	_message_show_tween.start()
	emit_signal("show_animation_started")


# immediately ends message showing animation
func _end_message_animation():
	_message_show_tween.remove_all()
	percent_visible = 1


# пробует послать на вывод следующее сообщение
func _try_show_next_message() -> bool:
	if !_messages_queue.empty():
		_show_message()
		
		return true
	
	return false


# закрывает диалог
func _close_dialogue():
	if visible:
		visible = false
		
		emit_signal("dialogue_closed")
