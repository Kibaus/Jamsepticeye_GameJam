extends CharacterBody3D

@export var ghost_prefab : PackedScene

@export var speed = 160
@export var fall_acceleration = 75

@export var jump_enable : bool = false
@export var jump_impulse = 20

var target_velocity = Vector3.ZERO

#mouse input
@export_range(1, 100, 1) var mouse_sensitivity: int = 50
@export var max_pitch : float = 89
@export var min_pitch : float = -89

var currently_active : bool = true

func _ready() -> void:
	$MeshInstance3D.hide()
	%GhostWall.hide()
	Input.set_use_accumulated_input(false)

func _input(event) -> void:
	if currently_active:
			if event is InputEventMouseMotion:
				aim_look(event)

func _physics_process(delta: float) -> void:
	if currently_active:
		_update_movement(delta)

func _update_movement(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if Input.is_action_just_pressed("ghost_switch"):
		_ghost_switch()
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	target_velocity.x = direction.x * speed * delta
	target_velocity.z = direction.z * speed * delta
	
	if is_on_floor() == false:
		target_velocity.y = target_velocity.y -(fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump") and jump_enable:
		target_velocity.y = jump_impulse
	
	velocity = target_velocity.rotated(Vector3.UP,rotation.y)
	move_and_slide()

func _ghost_switch():
	var ghost = ghost_prefab.instantiate()
	ghost.connect("return_to_player",_return_to_player)
	get_parent().add_child(ghost)
	ghost.position = position
	ghost.rotation = rotation
	ghost.switch_to_ghost()
	$MeshInstance3D.show()
	%GhostWall.show()
	currently_active = false

func _return_to_player():
	$CamPivot/Camera3D.current = true
	$MeshInstance3D.hide()
	%GhostWall.hide()
	currently_active = true

func interact():
	var space_state = get_world_3d().direct_space_state
	var cam = $CamPivot/Camera3D
	var ray_length =  0.75
	
	var center = get_viewport().size /2

	var origin = cam.project_ray_origin(center)
	var end = origin + cam.project_ray_normal(center) * ray_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if result == null or result.is_empty():
		return
	
	if result.collider != null:
		if result.collider is Switch:
			result.collider.use()
		print("interacted with: " + result.collider.name)

#Handles aim look with the mouse.
func aim_look(event: InputEventMouseMotion)-> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.001
	
	motion *= mouse_sensitivity
	motion *= degrees_per_unit
	
	add_yaw(motion.x)
	add_pitch(motion.y)
	clamp_pitch()

func add_yaw(amount)->void:
	if is_zero_approx(amount):
		return
	
	rotate_object_local(Vector3.DOWN, deg_to_rad(amount))
	orthonormalize()

func add_pitch(amount)->void:
	if is_zero_approx(amount):
		return
	
	%CamPivot.rotate_object_local(Vector3.LEFT, deg_to_rad(amount))
	%CamPivot.orthonormalize()

func clamp_pitch()->void:
	if %CamPivot.rotation.x > deg_to_rad(min_pitch) and %CamPivot.rotation.x < deg_to_rad(max_pitch):
		return
	%CamPivot.rotation.x = clamp(%CamPivot.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	%CamPivot.orthonormalize()
