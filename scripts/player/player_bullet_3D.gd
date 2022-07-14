extends Area



func _physics_process(_delta):
	global_transform.origin -= global_transform.basis.z


func _on_player_bullet_3D_area_entered(area : Area):
	area.get_parent().life -= 1
#	get_parent().emit_particles(global_transform, true)
	queue_free()


func _on_player_bullet_3D_body_entered(_body):
	get_parent().emit_particles(global_transform, false)
	queue_free()
