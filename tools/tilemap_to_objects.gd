tool
extends EditorScript


var _tscn_box: PackedScene = preload("res://obj/movables/power_box.tscn")
var _tscn_socket: PackedScene = preload("res://obj/holes/power_socket.tscn")
var _tscn_door: PackedScene = preload("res://obj/power_door.tscn")
var _tscn_lamp_rg: PackedScene = preload("res://obj/small_lamp_redgreen.tscn")

var _box_parent_path: NodePath = "PowerBoxes"
var _socket_parent_path: NodePath = "PowerSockets"
var _door_parent_path: NodePath = "Doors"
var _lamp_rg_parent_path: NodePath = "Lamps"

var _objs_settings: Dictionary


func _run():
	_setup_objs_settings()
	
	var root = get_scene()
	var tilemap: TileMap = root.get_node("TileMap")
	var tileset: TileSet = tilemap.tile_set
	var cell_size = tilemap.cell_size * tilemap.scale
	
	for cell in tilemap.get_used_cells():
		var tile = tilemap.get_cellv(cell)
		var tile_name = tileset.tile_get_name(tile)
		
		if not _objs_settings.has(tile_name):
			continue
		
		var obj_settings = _objs_settings[tile_name]
		_create_node(obj_settings.tscn, obj_settings.parent, cell * cell_size)


func _setup_objs_settings():
	var scene = get_scene()
	
	_objs_settings["power_box"] = {
		"tscn": _tscn_box,
		"parent": scene.get_node(_box_parent_path)
	}
	
	_objs_settings["power_socket"] = {
		"tscn": _tscn_socket,
		"parent": scene.get_node(_socket_parent_path)
	}
	
	_objs_settings["power_door"] = {
		"tscn": _tscn_door,
		"parent": scene.get_node(_door_parent_path)
	}
	
	_objs_settings["lamp_rg"] = {
		"tscn": _tscn_lamp_rg,
		"parent": scene.get_node(_lamp_rg_parent_path)
	}


func _create_node(tscn, parent_scene, position):
	var new_node = tscn.instance()
	
	parent_scene.add_child(new_node)
	new_node.position = position
	new_node.set_owner(get_scene())
