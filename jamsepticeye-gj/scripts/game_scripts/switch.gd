class_name Switch

extends RigidBody3D

signal pressed

func to_top( animate : bool = true):
	if animate:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(%Movable,"rotation",Vector3(20,0,0),1).as_relative()
	else:
		%Moveable.rotation_degrees.x = 20

func to_bottom(animate : bool = true):
	if animate:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(%Movable,"rotation",Vector3(160,0,0),1).as_relative()
	else:
		%Moveable.rotation_degrees.x = 160

func use():
	pressed.emit()
	
	$AudioClient.play_oneshot("switch_press")
	
	var forward = basis.z
	Core.current_enemy.alerted_at(position + forward)

func setup_symbols(texture_a,texture_b):
	%Symbol1.texture = texture_a
	%Symbol2.texture = texture_b
