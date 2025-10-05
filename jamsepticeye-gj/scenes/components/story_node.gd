extends Control

@export var intro_text : String
@export var death_text : Array[String]
@export_multiline var end_text : String

var death_count = 0

signal beat_complete
var has_task = false
var current_task : Callable

var story_block = false

func _ready() -> void:
	var center = get_viewport_rect().size / 2
	%Scare.position = center
	%Scare.hide()
	self.hide()
	

func set_on_finish(task : Callable):
	current_task = task
	beat_complete.connect(current_task)
	has_task = true

func play_intro():
	story_block = true
	get_tree().paused = true
	_display_story_beat(intro_text,5)

func play_death_message():
	story_block = true
	set_on_finish(_on_death_message_end)
	var message = death_text[death_count]
	_display_story_beat(message,4,true)
	death_count += 1
	if death_count == death_text.size():
		death_count -= death_text.size()

func play_ending():
	story_block = true
	set_on_finish(_on_ending_end)
	_display_story_beat(end_text,30)

func _on_death_message_end():
	AudioManager.play_background_music("ambient_safe_kinda")
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_ending_end():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	UIManager.switch_ui(UIManager.UI.main)

func play_end():
	_display_story_beat(end_text,30)

func _resume_game():
	get_tree().paused = false

func _display_story_beat(line : String, end_delay : int,jumpscare : bool = false):
	#override while this doesnt work
	_story_beat_simple(line,end_delay,jumpscare)
	return
	
	%BG.modulate = Color.TRANSPARENT
	%Text.add_theme_color_override("font_color",Color.TRANSPARENT)
	%Text.text = line
	
		
	self.show()
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(%BG,"modulate",Color.BLACK,1)
	tween.chain().tween_property(%Text,"theme_override_colors/font_color",Color.WHITE,1)
	
	await get_tree().create_timer(end_delay).timeout
	
	if has_task:
		beat_complete.emit()
		beat_complete.disconnect(current_task)
		has_task = false
	
	story_block = false
	self.hide()

func _story_beat_simple(line : String, end_delay : int, jumpscare : bool = false):
	self.show()
	%BG.modulate = Color.BLACK
	%Text.text = ""
	
	if jumpscare:
		#%Scare.scale = Vector2(0,0)
		%Scare.show()
		AudioManager.play_short_sound_effect("monster_kill")
		#var tween : Tween = get_tree().create_tween()
		#tween.tween_property(%Scare,"scale",Vector2(1,1),1)
		await get_tree().create_timer(1).timeout
		%Scare.hide()
	
	%Text.add_theme_color_override("font_color",Color.WHITE)
	%Text.text = line
	
	await get_tree().create_timer(end_delay).timeout
	if has_task:
		beat_complete.emit()
		beat_complete.disconnect(current_task)
		has_task = false
	
	story_block = false
	self.hide()
	
