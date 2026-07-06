extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 7

var look_dir : Vector2
@onready var camra = $Camera3D
var camra_sence = 50

var CapMouse = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if Input.is_action_just_pressed("Pause"):
			CapMouse = !CapMouse
		
		if CapMouse:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
			
	_rotate_camra(delta)
	move_and_slide()
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion: look_dir = event.relative * 0.01
			
func _rotate_camra(delta: float, sence_mod:float = 1.0):
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	look_dir += input
	rotation.y -= look_dir.x * camra_sence * delta
	camra.rotation.x = clamp(camra.rotation.x - look_dir.y * camra_sence * sence_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO
	
