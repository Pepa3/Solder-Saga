extends CharacterBody3D
var speed = 5
var pickup_speed = 3
var mouse_sensitivity = -0.005
var jump_impulse = 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_velocity = Vector3.ZERO
var picked_object: Node3D = null

func _physics_process(delta):
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_impulse
		
	if not is_on_floor():
		velocity.y = velocity.y - (gravity * delta)
		
	move_and_slide()
	if picked_object:
		picked_object.global_position = picked_object.global_position.move_toward(
			$Camera/Pickup.global_position,
			delta*pickup_speed*abs($Camera/Pickup.global_position.distance_to(picked_object.global_position)))
			

func _unhandled_input(event):
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(event.relative.x*mouse_sensitivity)
		$Camera.rotate_x(event.relative.y*mouse_sensitivity)
	if event is InputEventMouseButton && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if (event as InputEventMouseButton).is_pressed() && $Camera/Ray.is_colliding():
			picked_object = $Camera/Ray.get_collider()
			if picked_object is RigidBody3D:
				(picked_object as RigidBody3D).gravity_scale=0
		elif (event as InputEventMouseButton).is_released():
			if picked_object is RigidBody3D:
				(picked_object as RigidBody3D).gravity_scale=1
			picked_object=null
