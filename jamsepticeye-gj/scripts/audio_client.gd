extends Node3D

func _ready() -> void:
	pass


#Create stream that will free after finished
func play_oneshot(
		p_audio_tag: String, 
		p_max_distance: float = 0.0, 
		p_unit_size: float = 10) -> AudioStreamPlayer3D:
	if AudioManager.get_audio_by_tag(p_audio_tag) == null :
		return

	var new_oneshot_stream = AudioStreamPlayer3D.new()
	new_oneshot_stream.stream = AudioManager.get_audio_by_tag(p_audio_tag).file
	new_oneshot_stream.max_distance = p_max_distance
	new_oneshot_stream.unit_size = p_unit_size
	new_oneshot_stream.bus = AudioManager.BUS_SFX
	add_child(new_oneshot_stream)
	new_oneshot_stream.connect("finished", Callable(new_oneshot_stream, "queue_free"))
	new_oneshot_stream.play()
	return new_oneshot_stream

#Create stream that can multiplay 
func play_polyphony(
		p_audio_tag: String, 
		p_max_distance: float = 10.0, 
		p_unit_size: float = 10, 
		p_max_polyphony: int = 3) -> AudioStreamPlayer3D:
	if AudioManager.get_audio_by_tag(p_audio_tag) == null :
		return
	var new_polyphony_stream = AudioStreamPlayer3D.new()
	new_polyphony_stream.stream = AudioManager.get_audio_by_tag(p_audio_tag).file
	new_polyphony_stream.max_distance = p_max_distance
	new_polyphony_stream.unit_size = p_unit_size
	new_polyphony_stream.max_polyphony = p_max_polyphony
	new_polyphony_stream.bus = AudioManager.BUS_SFX
	add_child(new_polyphony_stream)
	new_polyphony_stream.play()
	return new_polyphony_stream

#Create stream that maintain until free it 
func play_maintain(
		p_audio_tag: String, 
		p_max_distance: float = 5.0, 
		p_unit_size: float = 10) -> AudioStreamPlayer3D:
	if AudioManager.get_audio_by_tag(p_audio_tag) == null :
		return
	var new_maintain_stream = AudioStreamPlayer3D.new()
	new_maintain_stream.stream = AudioManager.get_audio_by_tag(p_audio_tag).file
	new_maintain_stream.max_distance = p_max_distance
	new_maintain_stream.unit_size = p_unit_size
	new_maintain_stream.bus = AudioManager.BUS_SFX
	add_child(new_maintain_stream)
	new_maintain_stream.connect("finished", Callable(new_maintain_stream, "play"))
	new_maintain_stream.play()
	return new_maintain_stream

#Free all stream available
func free_all_stream() -> void:
	for child in get_children():
		if(is_instance_valid(child)):
			child.queue_free()
