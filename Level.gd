extends Navigation

const SPEED = 10.0

var camrot = 0.0
var m = SpatialMaterial.new()

var path = []
var show_path = true
export(NodePath) var player_path
export(NodePath) var agent_path
onready var player = get_node(player_path)
onready var agent = get_node(agent_path)
onready var camera = get_node("CameraBase/Camera")

func _ready():
	
	set_process_input(true)
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white


func _physics_process(delta):
	if agent == null:
		agent = get_node(agent_path)
		player = get_node(player_path)
		return
	
	track_object(player)
	
	var direction = Vector3()

	# We need to scale the movement speed by how much delta has passed,
	# otherwise the motion won't be smooth.
	var step_size = delta * SPEED
	
	if path.size() > 0:
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination = path[0]
		direction = destination - agent.translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > direction.length():
			step_size = direction.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

		# Move the robot towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the robot only looks left and right, not up/down.
		direction.y = 0
		if direction:
			# Direction is relative, so apply it to the robot's location to
			# get a point we can actually look at.
			var look_at_point = agent.translation + direction.normalized()
			# Make the robot look at the point.
			agent.look_at(look_at_point, Vector3.UP)
		agent.set_velocity()
		agent.move()

func track_object(obj):
	var point = obj.translation
	var target_point = get_closest_point(point)
	# Set the path between the robots current location and our target.
	path = get_simple_path(agent.translation, target_point, true)
