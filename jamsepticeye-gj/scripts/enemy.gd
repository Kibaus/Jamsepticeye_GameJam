class_name Enemy
extends CharacterBody3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

enum EnemyState {
	Wander,
	Alerted,
	Hunting
}

var current_state : EnemyState = EnemyState.Wander
var vision_range : int = 7

enum Direction 
{
	None,
	Forward,
	Away,
	Left,
	Right
}

var current_direction = Direction.None

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	Core.Set_active_enemy(self)
	var wanderpos = NavigationServer3D.map_get_random_point(navigation_agent.get_navigation_map(),1,false)
	set_movement_target(wanderpos)

func alerted_at(alert_pos : Vector3):
	if current_state == EnemyState.Hunting:
		return
	
	current_state = EnemyState.Alerted
	set_movement_target(alert_pos)
	%AlertedTimer.start()

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	if current_state == EnemyState.Hunting:
		set_movement_target(Core.current_player.position)
	
	if _check_for_player() == true:
		if current_state == EnemyState.Alerted:
			%AlertedTimer.stop()
		
		current_state = EnemyState.Hunting
		%SightTimer.start()
	
	_handle_nav_movement()
	_check_visual_direction()

func _check_movement_direction_angle():
	var next_path = navigation_agent.get_next_path_position()
	var next_position = Vector2(next_path.x,next_path.z)
	var current_position = Vector2(global_position.x,global_position.z)
	
	var direction = (next_position - current_position).normalized()
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
	
	_change_sprite_by_direction(diff_angle)

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

func _check_for_player():
	if Core.current_player == null:
		return false
	
	var player = Core.current_player
	
	if position.distance_to(player.position) < vision_range:
		if _vision_raycast(player.position):
			return true
			
	return false

func _vision_raycast(player_pos):
	var space_state = get_world_3d().direct_space_state
	var vision_up = Vector3(0,1,0)
	
	var query = PhysicsRayQueryParameters3D.create(position + vision_up, player_pos + vision_up)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result == null or result.is_empty():
		return false
	
	if result.collider != null:
		if result.collider is Player:
			return true
	
	return false

func _handle_nav_movement():
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func _on_sight_timer_timeout() -> void:
	current_state = EnemyState.Wander
	var wanderpos = NavigationServer3D.map_get_random_point(navigation_agent.get_navigation_map(),1,false)
	set_movement_target(wanderpos)

func _on_wander_timer_timeout() -> void:
	if current_state == EnemyState.Wander:
		var wanderpos = NavigationServer3D.map_get_random_point(navigation_agent.get_navigation_map(),1,false)
		set_movement_target(wanderpos)

func _on_alerted_timer_timeout() -> void:
	current_state = EnemyState.Wander
	var wanderpos = NavigationServer3D.map_get_random_point(navigation_agent.get_navigation_map(),1,false)
	set_movement_target(wanderpos)

func _on_navigation_agent_3d_navigation_finished() -> void:
	if current_state == EnemyState.Hunting:
		return
	
	current_state = EnemyState.Wander
	var wanderpos = NavigationServer3D.map_get_random_point(navigation_agent.get_navigation_map(),1,false)
	set_movement_target(wanderpos)
