extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var shoot_range
export(float) var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	$muzzle_flash.emitting = true
	print("shooting")
	var hit = $RayCast.get_collider()
	if hit:
		print("we hit something")
		if hit.has_method("take_damage"):
			hit.take_damage(damage)
	else:
		print("not hit, sadge")

