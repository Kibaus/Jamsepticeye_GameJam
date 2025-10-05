extends Node

static var first_load : bool  = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if first_load == false:
		return
	
	#AudioManager.set_background_music_volume(0)
	first_load = false
