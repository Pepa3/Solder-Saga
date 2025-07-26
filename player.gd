extends CharacterBody3D
@export var speed = 14
@export var mouse_sensitivity = -0.005
@export var jump_impulse = 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_velocity = Vector3.ZERO

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

func _unhandled_input(event):
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(event.relative.x*mouse_sensitivity)
		$Camera.rotate_x(event.relative.y*mouse_sensitivity)
	
