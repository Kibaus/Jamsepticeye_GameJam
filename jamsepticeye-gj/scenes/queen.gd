class_name Queen

extends RigidBody3D

func wake_up():
	%AnimSprite.play("open")
	AudioManager.play_background_music("menu_ambiance")
	
	await get_tree().create_timer(3).timeout
	UIManager.ui_ingame.story.play_ending()
