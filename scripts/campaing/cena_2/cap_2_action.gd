extends Node2D


var entry_style := false

onready var tween := $Tween
onready var player := $player_2d
onready var hand_1 := $narrador_hand2
onready var hand_2 := $narrador_hand


func _ready():
	player.can_move = false
	player.shadow.visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	
	if entry_style:
		var _err = tween.interpolate_property(hand_1, "rect_position", hand_1.rect_position, Vector2(800, 250), 1.5, Tween.TRANS_QUAD)
		_err = tween.interpolate_property(player, "position", player.position, Vector2(850, 470), 1.5, Tween.TRANS_QUAD)
		_err = tween.interpolate_property(player, "rotation_degrees", player.rotation_degrees, 0, 1.5, Tween.TRANS_QUAD)
		tween.start()
		
		yield(get_tree().create_timer(2.0), "timeout")
		hand_2.rect_position = hand_1.rect_position
		hand_1.visible = false
		
		_err = tween.interpolate_property(player, "position", player.position, Vector2(player.position.x, 900), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		
		yield(get_tree().create_timer(0.3), "timeout")
		_err = tween.interpolate_property(hand_2, "rect_position", hand_2.rect_position, Vector2(hand_2.rect_position.x, -200), 1.0, Tween.TRANS_QUAD)
		tween.start()
		
		player.shadow.visible = true
		yield(get_tree().create_timer(0.5), "timeout")
		player.look_at_mouse = true
		
	else:
		player._move.x = 1
		player.look_at_mouse = true
		player.rotation_degrees = 0
		var _err = tween.interpolate_property(player, "position", player.position, Vector2(500, 700), 1.5)
		tween.start()
		
		yield(get_tree().create_timer(1.5), "timeout")
		
	
	player.can_move = true






