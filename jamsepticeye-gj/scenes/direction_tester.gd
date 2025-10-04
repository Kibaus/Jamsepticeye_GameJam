extends Node3D

enum Direction 
{
	None,
	Forward,
	Away,
	Left,
	Right
}

var current_direction = Direction.None

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y -= 3 * delta
	

func _check_movement_direction_angle():
	var flat_position = Vector2(global_position.x, global_position.z)
	var flat_front = Vector2(%in_front.global_position.x,%in_front.global_position.z)
	
	var direction = (flat_front - flat_position).normalized()
	return int(rad_to_deg(direction.angle()))

func _check_cam_direction_angle():
	var current_position = Vector2(global_position.x,global_position.z)
	var active_cam = get_viewport().get_camera_3d()
	var cam_position = Vector2(active_cam.global_position.x,active_cam.global_position.z)
	var direction_to_cam = (cam_position - current_position).normalized()
	return int(rad_to_deg(direction_to_cam.angle()))

func _check_visual_direction():
	var move_direction_angle = _check_movement_direction_angle()
	if move_direction_angle < 0:
		move_direction_angle += 360
	var angle_to_cam = _check_cam_direction_angle()
	if angle_to_cam < 0:
		angle_to_cam += 360
	
	var diff_angle = angle_to_cam - move_direction_angle
	diff_angle = (diff_angle + 180)  % 360 - 180
	if diff_angle < 0:
		diff_angle += 360
	
	print("move angle:" + str(move_direction_angle))
	print("cam angle:" + str(angle_to_cam))
	print("difference: " + str(diff_angle))
	
	return diff_angle

func _change_sprite_by_direction(angle):
	#away
	if angle >= 135 and angle < 225:
		if current_direction != Direction.Away:
			current_direction = Direction.Away
			%AnimSprite.play("walk_away")
			%AnimSprite.flip_h = false
	#right
	if angle >= 45 and angle < 135:
		if current_direction != Direction.Right:
			current_direction = Direction.Right
			%AnimSprite.play("walk_side")
			%AnimSprite.flip_h = false
	#toward
	if (angle >= 0 and angle < 45) or angle >= 315:
		if current_direction != Direction.Forward:
			current_direction = Direction.Forward
			%AnimSprite.play("walk_forward")
			%AnimSprite.flip_h = false
	#left
	if angle >= 225 and angle < 315:
		if current_direction != Direction.Left:
			current_direction = Direction.Left
			%AnimSprite.play("walk_side")
			%AnimSprite.flip_h = true

func _on_timer_timeout() -> void:
	var diff_angle = _check_visual_direction()
	_change_sprite_by_direction(diff_angle)
