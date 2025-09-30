extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_continue_button_down() -> void:
	%UIManager.switch_ui(%UIManager.UI.ingame)
	pass # Replace with function body.
	
func _on_options_button_down() -> void:
	%UIManager.switch_ui(%UIManager.UI.options)
	pass # Replace with function body.

func _on_totitle_button_down() -> void:
	%UIManager.switch_ui(%UIManager.UI.main)
	pass # Replace with function body.
