extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 7

var look_dir : Vector2
@onready var camra = $Camera3D
var camra_sence = 50

var CapMouse = false
var Crouch = false


func _physics_process(delta: float) -> void:
	#crouch
	if Input.is_action_just_pressed("crouch"):
		Crouch = !Crouch		
		if Crouch:
			var tween := get_tree().create_tween()
			tween.tween_property(self,"scale:y",0.6 , 0.5)
		else:
			var tween := get_tree().create_tween()
			tween.tween_property(self,"scale:y",1 , 0.5)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		#lock mouse to scene
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
	#camra movement
func _rotate_camra(delta: float, sence_mod:float = 1.0):
	rotation.y -= look_dir.x * camra_sence * delta
	camra.rotation.x = clamp(camra.rotation.x - look_dir.y * camra_sence * sence_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO
	
