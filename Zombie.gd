extends KinematicBody


var fall_accel = 75
var velocity = Vector3.ZERO
var path = []
var path_node = 0
const SPEED = 10


export(NodePath) var player_path
export(NodePath) var nav_path
onready var player: KinematicBody = get_node(player_path)
onready var nav = get_node(nav_path)

signal enemy_killed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var direction = Vector3()
	
	var step_size = SPEED
	
	if path.size() > 0:
		
		var destination = path[0]
		direction = destination - global_transform.origin
		
		if (step_size * delta) > direction.length():
			
			step_size = direction.length()/delta
			# We should also remove this node since we're about to reach it.
			path.remove(0)
		direction = direction.normalized()
		velocity.x = direction.x * step_size
		velocity.z = direction.z * step_size
		
		velocity = move_and_slide(velocity, Vector3.UP)
	var look_vec = Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z)
	look_at(look_vec, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	

func take_damage(amount):
	$Health.delta(amount, false)
	if $Health.current_health <= 0:
		die()

func die():
	emit_signal("enemy_killed")
	queue_free()


func _on_Timer_timeout():
	move_to(player.global_transform.origin)
