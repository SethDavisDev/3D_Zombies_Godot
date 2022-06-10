extends KinematicBody

onready var health = get_node("Health")

var move_speed = 10
var fall_accel = 75
var velocity = Vector3.ZERO

var rot_x = 0
var rot_y = 0
const LOOKAROUND_SPEED = 0.01

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rot_x -= event.relative.x * LOOKAROUND_SPEED
		rot_y -= event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis() # reset rotation
		rot_y = clamp(rot_y, -1.25, 1.25)
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		$Camera.transform.basis = Basis()
		$Camera.rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var direction = Vector3.ZERO
	direction +=  global_transform.basis.x * (Input.get_action_strength("right") - Input.get_action_strength("left"))
	direction +=  -global_transform.basis.z * (Input.get_action_strength("fwd") - Input.get_action_strength("back") )
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	
	velocity.y -= fall_accel * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)

func take_damage(amount):
	print("took damage")
	health.delta(amount, false)
