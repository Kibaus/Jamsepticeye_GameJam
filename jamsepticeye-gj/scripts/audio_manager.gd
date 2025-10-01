@tool
extends Node

#Volume controller, call and set it by two way
#Call the func or adjust background_music_volume directly, not _background_music_volume
var _background_music_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var background_music_volume: float = 1.0 : 
	set(value): set_background_music_volume(value)
	get: return _background_music_volume
func set_background_music_volume(pVolume: float) -> void:
	_background_music_volume = clamp(pVolume, 0.0, 1.0)
	if(background_music != null) :
		background_music.volume_linear = _background_music_volume

#SFX controller, call and set it by two way, not include _sound_effect_volume
#Call the func or adjust sound_effect_volume directly, not _sound_effect_volume
var _sound_effect_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var sound_effect_volume: float = 1.0 :
	set(value): set_sound_effect_volume(value)
	get: return _sound_effect_volume
func set_sound_effect_volume(pVolume: float):
		_sound_effect_volume = clamp(pVolume, 0.0, 1.0)
		for child in get_children():
			if child is AudioStreamPlayer and child != background_music:
				child.volume_linear = pVolume		


@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@export var sound_list: Array[AudioWithTag] = []

var music_folder = "res://audio/music/"
var sfx_folder = "res://audio/sfx/"

func _ready() -> void:
	sound_list.clear()
	load_sounds_from_folder(music_folder)
	load_sounds_from_folder(sfx_folder)
	background_music.volume_linear = background_music_volume
	#Call defer in case get tree paused
	if Engine.is_editor_hint() == false:
		background_music.call_deferred("play")

#Use this to auto load sound from folder to list
func load_sounds_from_folder(folder_path: String) -> void:
	var dir = DirAccess.open(folder_path)
	if not dir:
		print("Can't access folder: ", folder_path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".ogg") or file_name.ends_with(".wav") or file_name.ends_with(".mp3"):
				var audio_path = folder_path + file_name
				var audio_stream = load(audio_path) as AudioStream 
				if audio_stream:
					var tag_name = file_name.get_basename()
					if not _get_audio_by_tag(tag_name):
						var audio_res = AudioWithTag.new()
						audio_res.file = audio_stream
						audio_res.tag = tag_name
						sound_list.append(audio_res)
		file_name = dir.get_next()
	dir.list_dir_end()

#Find the audio file by it's name
func _get_audio_by_tag(pTag: String) -> AudioWithTag:
	for audio_res in sound_list:
		if audio_res.tag == pTag:
			return audio_res
	return null

#Play the sound and it will be destroy after finished
func play_sound_effect(pTag: String) -> void:
	var audio_res = _get_audio_by_tag(pTag)
	if not audio_res:
		print("(Oneshot) Audio File not found: ", pTag)
		return
	
	var player = AudioStreamPlayer.new()
	player.volume_linear = sound_effect_volume
	player.stream = audio_res.file
	
	add_child(player)
	player.connect("finished", Callable(player, "queue_free"))
	player.call_deferred("play")
	#player.play()

#Update the background music now
func play_background_music(pTag: String) -> void:
	var fade_time: float = 1.0
	var new_audio = _get_audio_by_tag(pTag)
	if not new_audio:
		print("(Background Music) Audio File not found: ", pTag)
		return

	var tween = create_tween()
	tween.tween_property(background_music, "volume_db", -80, fade_time)
	tween.tween_callback(func(): _switch_background_music(new_audio, fade_time))

func _switch_background_music(new_audio: AudioWithTag, fade_time: float) -> void:
	print("Cast")

	background_music.stream = new_audio.file
	#Temporary set, when all music import and manual set loop, don't need
	background_music.connect("finished", Callable(background_music, "play"))
	background_music.call_deferred("play")


	var target_db = background_music_volume
	var tween = create_tween()
	tween.tween_property(background_music, "volume_linear", target_db, fade_time)
