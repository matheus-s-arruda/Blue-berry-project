extends Control


func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	var _err = get_tree().change_scene("res://scenes/main/main.tscn")


