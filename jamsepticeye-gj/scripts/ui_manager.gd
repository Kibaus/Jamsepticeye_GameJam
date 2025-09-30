extends Control

enum UI {
	none = 0,
	main = 1,
	pause = 2,
	options = 3,
	ingame = 4
}

var current_ui : UI = UI.none
var previous_ui : UI = UI.none

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_ui(UI.main)

func _process(delta: float) -> void:
		if Input.is_action_just_pressed("pause_game"):
			if current_ui != UI.main:
				if current_ui == UI.ingame:
					switch_ui(UI.pause)
					return
					
				if current_ui == UI.pause || current_ui == UI.options:
					switch_ui(UI.ingame)
					return

func switch_ui(id : UI):
	if current_ui == id:
		return
	
	previous_ui = current_ui
	current_ui = id
	
	$ui_main.hide()
	$ui_pause.hide()
	$ui_options.hide()
	$ui_ingame.hide()
	
	match id:
		UI.main: 
			$ui_main.show()
			get_tree().paused = true
		UI.pause: 
			$ui_pause.show()
			get_tree().paused = true
		UI.options: 
			$ui_options.show()
		UI.ingame: 
			$ui_ingame.show()
			get_tree().paused = false
