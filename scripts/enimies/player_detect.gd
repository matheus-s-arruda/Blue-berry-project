extends Area


onready var collision = $CollisionShape


func _on_player_detect_body_entered(_body):
	alert_all()


func count_childs():
	yield(get_tree(), "idle_frame")
	if get_child_count() == 1:
		get_parent().call_deferred("count_childs")
		get_parent().remove_child(self)
		queue_free()


func alert_all():
	for c in get_children():
		if c is KinematicBody:
			c.can_update_path = true
	collision.disabled = true
