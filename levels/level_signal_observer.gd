class_name LevelSignalObserver
extends NodeSignalObserver


signal emitted(level_name)


func _emitted():
	emit_signal("emitted", _get_observable_node().level_name)
