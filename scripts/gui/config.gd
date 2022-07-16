extends Panel


onready var v_master = $VBoxContainer/volume_master/volume_master
onready var v_music = $VBoxContainer/volume_music/volume_music
onready var v_dialog = $VBoxContainer/volume_dialogue/volume_dialogue
onready var v_effects = $VBoxContainer/volume_effecs/volume_effecs


func _ready():
	v_master.value = Globals.save.volume_master
	v_music.value = calc_range_by_volume(Globals.save.volume_music)
	v_dialog.value = calc_range_by_volume(Globals.save.volume_dialogue)
	v_effects.value = calc_range_by_volume(Globals.save.volume_effects)


func calc_volume_range(v_range : float):
	return ((clamp(v_range, 0.0, 1.0) * 40.0) -30)


func calc_range_by_volume(volume : float):
	return ((clamp(volume, -30, 10) + 30) / 40)


func _vslider_end_edit(event : InputEvent):
	if event.is_action_released("mouse_click"):
		Globals.save.volume_music = calc_volume_range(v_music.value)
		Globals.save.volume_effects = calc_volume_range(v_effects.value)
		Globals.save.volume_dialogue = calc_volume_range(v_dialog.value)
		Globals.save.volume_master = v_master.value
		
		Globals.save_sv()


func _on_cancel_config_pressed():
	get_parent().visible = false


func _on_volume_master_value_changed(value):
	AudioSystem.volume_master = value
	AudioSystem.change_bus_volume_range(value)


func _on_volume_music_value_changed(value):
	AudioSystem.volume_music = calc_volume_range(value)


func _on_volume_dialogue_value_changed(value):
	AudioSystem.volume_dialogue = calc_volume_range(value)


func _on_volume_effecs_value_changed(value):
	AudioSystem.volume_effects = calc_volume_range(value)
