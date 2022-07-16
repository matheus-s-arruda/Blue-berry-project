class_name Constants extends Node


const LEVEL_SCENE_PATH := [
	"res://scenes/campaing/cap_1/cena_1.tscn",
	"res://scenes/campaing/cap_2/cap_2.tscn",
	"res://scenes/campaing/cap_3/cap_3.tscn",
	"res://scenes/campaing/cap_3/cap_3.tscn",
]
const TRANSITION_SCENE := "res://scenes/splash/transition_scene.tscn"
const STATUS_ITEM = preload("res://scenes/gui/status_bar_item.tscn")


class CallExecutioner extends Reference:
	var is_func : bool
	var call : String
	var value
	
	func _init(_is_func : bool, _call : String, _value = null):
		is_func = _is_func; call = _call; value = _value
	
	func execute(node : Node):
		if is_func:
			if value: node.call(call, value)
			else: node.call(call)
		else:
			node.call("set", call, value)
